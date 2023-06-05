import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Pages/form.p.dart';
import 'package:flutter_application_1/model/User.m.dart';
import 'package:flutter_application_1/utils/apiUrl.u.dart';
import 'package:flutter_application_1/utils/appRoutes.u.dart';
import 'package:flutter_application_1/utils/transition.u.dart';
import 'package:flutter_application_1/widgets/User-item.w.dart';
// ignore: depend_on_referenced_packages, unused_import
import 'package:http/http.dart' as http;

main() => runApp(const ListUsers());

class ListUsers extends StatelessWidget {
  const ListUsers({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
          child: Scaffold(
              appBar: AppBar(title: const Text(('Crud Usuários'))),
              body: SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: ListUsersPage(),
              ))),
      routes: {AppRoutes.FORM: (ctx) => FormUser()},
      theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFFFAFAFA),
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.android: CustomPageTransitionsBuilder(),
            TargetPlatform.iOS: CustomPageTransitionsBuilder(),
          })),
    );
  }
}

class ListUsersPage extends StatefulWidget {
  ListUsersPage({super.key});

  @override
  State<ListUsersPage> createState() => _ListUsersPageState();
}

class _ListUsersPageState extends State<ListUsersPage> {
  final String baseUrl = ApiURL.getUsers;
  @override
  void initState() {
    super.initState();
    http.get(Uri.parse(baseUrl));
  }

  Future<List?> getUsers() async {
    try {
      var response = await http
          .get(Uri.parse(baseUrl))
          .timeout(const Duration(seconds: 10));
      var users = json.decode(response.body);
      if (response.statusCode != 200) return [];
      return users;
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        FutureBuilder<List?>(
            future: getUsers(),
            builder: (ctx, snpashot) {
              switch (snpashot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height,
                    child: const CircularProgressIndicator(),
                  );
                case ConnectionState.active:
                case ConnectionState.done:
              }
              if (snpashot.hasData && snpashot.data!.isNotEmpty) {
                return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snpashot.data?.length,
                    itemBuilder: (context, index) {
                      final User user =
                          User(title: snpashot.data?[index]['firstName']);
                      return UserListItem(user: user, onDelete: (user) => {});
                    });
              } else {
                return Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height,
                  child: const Text('Nenhum dado a ser exibido!',
                      style: TextStyle(fontSize: 25)),
                );
              }
            })
      ],
    );
  }
}
