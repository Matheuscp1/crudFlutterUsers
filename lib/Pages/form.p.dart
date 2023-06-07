import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/User.m.dart';
import 'package:flutter_application_1/utils/apiUrl.u.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class FormUser extends StatefulWidget {
  const FormUser({super.key, this.arguments});

  final User? arguments;

  @override
  State<FormUser> createState() => _FormUserState();
}

class _FormUserState extends State<FormUser> {
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};
  final String baseUrl = ApiURL.getStates;
  dynamic _statesValue;
  List _states = [];
  dynamic _citiesValue;
  List _cities = ['..others'];
  final TextEditingController _date = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _briefController = TextEditingController();
  @override
  initState() {
    super.initState();
    /* WidgetsBinding.instance.addPostFrameCallback((_) {
      // Obtendo os argumentos da rota usando um Builder
      argumento = ModalRoute.of(context)!.settings.arguments as User;
      setState(() {});
      print(argumento);
    }); */
    if (widget.arguments != null) updateControllers();
    getStates();
  }

  Future<void> updateControllers() async {
    User? user = widget.arguments!;
    String? dateFormated = DateFormat('dd/MM/yyyy').format(user!.birthDate!);
    _date.text = dateFormated;
    _nameController.text = user.firstName!;
    _lastNameController.text = user.lastName!;
    _emailController.text = user.email!;
    _briefController.text = user.brief!;
    _statesValue = user.state ?? 'CE';
    await getCities(_statesValue);
    var foundCity = _cities.contains(user.city!);
    if (foundCity) _citiesValue = user.city;
  }

  Future<dynamic> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    final urlUser = ApiURL.getUsers;
    if (!isValid) return;
    _formKey.currentState?.save();

    try {
      Map data = {
        "email": "${_formData['email']}",
        "firstName": "${_formData['firstName']}",
        "lastName": "${_formData['lastName']}",
        "birthDate": "${_formData['birthDate']}",
        "state": "${_formData['state']}",
        "city": "${_formData['city']}",
        "brief": "${_formData['brief']}"
      };
      //encode Map to JSON
      var body = json.encode(data);
      var response = await http.post(
        Uri.parse(urlUser),
        body: body,
        headers: {"Content-Type": "application/json"},
      ).timeout(const Duration(seconds: 10));
      print(response.body);
      print(body);
      if (response.statusCode != 201) {
        if (context.mounted) {
          return showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Ocorreu um erro!'),
                  content: const Text('Tente novamente mais tarde'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Voltar'))
                  ],
                );
              });
        }
      }
      if (context.mounted) Navigator.of(context).pop();
      //print(_states);
    } catch (e) {}
  }

  Future<void> getStates() async {
    try {
      var response = await http
          .get(Uri.parse(baseUrl))
          .timeout(const Duration(seconds: 10));
      var states = json.decode(response.body);
      if (response.statusCode != 200) {
        setState(() {
          _states = ['CE', 'SP', 'MG', 'BA', 'SE', 'TO'];
        });
      }
      setState(() {
        _states = states;
      });
      //print(_states);
    } catch (e) {}
  }

  Future<void> getCities(String stateUF) async {
    final urlCities = '${ApiURL.getCities}?stateUF=$stateUF';
    try {
      var response = await http
          .get(Uri.parse(urlCities))
          .timeout(const Duration(seconds: 10));

      var cities = json.decode(utf8.decode(response.bodyBytes));
      if (response.statusCode != 200) {
        setState(() {
          _cities = ["...others"];
        });
      }
      setState(() {
        _cities = cities;
      });
      if (response.body.length == 2) {
        setState(() {
          _cities = ["...others"];
        });
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(title: const Text(('Crud Usuários'))),
            body: Padding(
              padding: const EdgeInsets.all(0),
              child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      const Divider(),
                      TextFormField(
                        controller: _nameController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            fillColor: const Color(0xFFF5F5F5),
                            filled: true,
                            prefixIcon: const Icon(Icons.person),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: Color(0xFFFAFAFA),
                                  width: 2.0,
                                )),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16)),
                            labelText: 'Nome',
                            labelStyle: const TextStyle(
                                fontSize: 20.0, color: Color(0xFF9E9E9E)),
                            hintText: 'Como gostaria de ser chamado?'),
                        onSaved: (_firstName) =>
                            _formData['firstName'] = _firstName ?? '',
                        validator: (_firstName) {
                          final firstName = _firstName ?? '';
                          if (firstName.trim().isEmpty) {
                            return 'Nome é Obrigatório';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      TextFormField(
                        controller: _lastNameController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            fillColor: const Color(0xFFF5F5F5),
                            filled: true,
                            prefixIcon: const Icon(Icons.person),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: Color(0xFFFAFAFA),
                                  width: 2.0,
                                )),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16)),
                            labelText: 'Sobre nome',
                            labelStyle: const TextStyle(
                                fontSize: 20.0, color: Color(0xFF9E9E9E)),
                            hintText: 'Seu sobre nome'),
                        onSaved: (lastName) =>
                            _formData['lastName'] = lastName ?? '',
                        validator: (_lastName) {
                          final lastName = _lastName ?? '';
                          if (lastName.trim().isEmpty) {
                            return 'Sobre nome é Obrigatório';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      TextFormField(
                        controller: _emailController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            fillColor: const Color(0xFFF5F5F5),
                            filled: true,
                            prefixIcon: const Icon(Icons.email),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: Color(0xFFFAFAFA),
                                  width: 2.0,
                                )),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16)),
                            labelText: 'Email',
                            labelStyle: const TextStyle(
                                fontSize: 20.0, color: Color(0xFF9E9E9E)),
                            hintText: 'email'),
                        onSaved: (email) => _formData['email'] = email ?? '',
                        validator: (_email) {
                          final email = _email ?? '';
                          bool emailValid = RegExp(
                                  r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                              .hasMatch(email);
                          if (email.trim().isEmpty) {
                            return 'Email é Obrigatório';
                          }
                          if (!emailValid) {
                            return 'Email inválido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      TextFormField(
                        readOnly: true,
                        controller: _date,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.datetime,
                        decoration: InputDecoration(
                            fillColor: const Color(0xFFF5F5F5),
                            filled: true,
                            prefixIcon: const Icon(
                              Icons.calendar_month_rounded,
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: Color(0xFFFAFAFA),
                                  width: 2.0,
                                )),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16)),
                            labelText: 'Data de nascimento',
                            labelStyle: const TextStyle(
                                fontSize: 20.0, color: Color(0xFF9E9E9E)),
                            hintText: 'hint'),
                        onSaved: (birthDate) => _formData['birthDate'] =
                            DateFormat('yyyy-MM-dd').format(
                                DateFormat('dd/MM/yyyy').parse(_date.text)),
                        onTap: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2030))
                              .then((date) {
                            setState(() {
                              _date.text =
                                  DateFormat('dd/MM/yyyy').format(date!);
                            });
                            //print(_selectDate);
                          });
                        },
                        validator: (_birthDate) {
                          final birthDate = _birthDate ?? '';
                          if (birthDate.trim().isEmpty) {
                            return 'Data de nascimento  é Obrigatório';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      DropdownButtonFormField(
                          validator: (value) =>
                              value == null ? 'Estado é Obrigatorio' : null,
                          value: _statesValue,
                          items: _states.map((e) {
                            return DropdownMenuItem(value: e, child: Text(e));
                          }).toList(),
                          onChanged: (_value) async {
                            final Object value = _value ?? '';
                            setState(() {
                              _statesValue = _value;
                              _citiesValue = null;
                            });
                            await getCities(value as String);
                            print(_citiesValue);
                          },
                          onSaved: (state) => _formData['state'] = state ?? '',
                          decoration: InputDecoration(
                              fillColor: const Color(0xFFF5F5F5),
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFFAFAFA),
                                    width: 2.0,
                                  )),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              labelText: 'Estado',
                              labelStyle: const TextStyle(
                                  fontSize: 20.0, color: Color(0xFF9E9E9E)),
                              hintText: 'Selecione uma estado')),
                      const SizedBox(
                        height: 40,
                      ),
                      DropdownButtonFormField(
                          validator: (value) =>
                              value == null ? 'Cidade é Obrigatorio' : null,
                          value: _citiesValue,
                          items: _cities?.map((e) {
                            return DropdownMenuItem(value: e, child: Text(e));
                          }).toList(),
                          onChanged: (_value) => {
                                setState(() {
                                  _citiesValue = _value.toString();
                                })
                              },
                          onSaved: (city) => _formData['city'] = city ?? '',
                          decoration: InputDecoration(
                              fillColor: const Color(0xFFF5F5F5),
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFFAFAFA),
                                    width: 2.0,
                                  )),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              labelText: 'Cidade',
                              labelStyle: const TextStyle(
                                  fontSize: 20.0, color: Color(0xFF9E9E9E)),
                              hintText: 'Selecione uma cidade')),
                      const SizedBox(
                        height: 40,
                      ),
                      TextFormField(
                        controller: _briefController,
                        onFieldSubmitted: (_) => _submitForm(),
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        decoration: InputDecoration(
                            alignLabelWithHint: true,
                            fillColor: const Color(0xFFF5F5F5),
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: Color(0xFFFAFAFA),
                                  width: 2.0,
                                )),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16)),
                            labelText: 'Sobre você',
                            labelStyle: const TextStyle(
                                fontSize: 20.0, color: Color(0xFF9E9E9E)),
                            hintText: 'Conte nós sobre você'),
                        onSaved: (brief) => _formData['brief'] = brief ?? '',
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF007D30).withOpacity(0.9),
                                spreadRadius: 2,
                                offset: Offset(0, 6),
                              )
                            ]),
                        height: 60,
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              foregroundColor: Colors.white,
                              backgroundColor: Color(0xFF00E457)),
                          child: const Text('Salvar',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Nunito')),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  )),
            )));
  }
}
