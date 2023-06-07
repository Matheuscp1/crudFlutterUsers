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

main() => runApp(MaterialApp(
      home: const ListUsers(),
      routes: {
        AppRoutes.FORM: (context) => FormUser(
            arguments: ModalRoute.of(context)?.settings.arguments as User)
      },
      theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFFFAFAFA),
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.android: CustomPageTransitionsBuilder(),
            TargetPlatform.iOS: CustomPageTransitionsBuilder(),
          })),
    ));

class ListUsers extends StatefulWidget {
  const ListUsers({super.key});

  @override
  State<ListUsers> createState() => _ListUsersState();
}

class _ListUsersState extends State<ListUsers> {
  String? ab;
  final String baseUrl = ApiURL.getUsers;

  Future<List?> getUsers() async {
    try {
      var response = await http
          .get(Uri.parse(baseUrl))
          .timeout(const Duration(seconds: 10));
      var users = json.decode(utf8.decode(response.bodyBytes));
      if (response.statusCode != 200) return [];
      return users;
    } catch (e) {}
    return null;
  }

  Future<void> deleteUser(id) async {
    try {
      var deleteURL = '$baseUrl/$id';
      var response = await http
          .delete(Uri.parse(deleteURL))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) return;
      getUsers();
      setState(() {});
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar:
                AppBar(title: const Text(('Listagem de Usuários')), actions: [
              IconButton(
                  onPressed: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const FormUser())).then((value) {
                          setState(() {});
                        })
                      },
                  icon: const Icon(Icons.add))
            ]),
            body: RefreshIndicator(
              notificationPredicate: (notification) {
                // with NestedScrollView local(depth == 0) OverscrollNotification are not sent
                if (notification.depth == 0) {
                  return notification.depth == 0;
                }
                return notification.depth == 1;
              },
              onRefresh: () {
                setState(() {});
                return getUsers();
              },
              child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
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
                                    dynamic userMap =
                                        jsonEncode(snpashot.data?[index]);
                                    final User user =
                                        User.fromJson(jsonDecode(userMap));
                                    return UserListItem(
                                        user: user, onDelete: deleteUser);
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
                  )),
            )));
  }
}
