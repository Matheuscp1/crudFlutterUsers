import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/User.dart';
import 'package:flutter_application_1/widgets/User-item.w.dart';
// ignore: depend_on_referenced_packages, unused_import
import 'package:http/http.dart' as http;

main() => runApp(const ListUsers());

class ListUsers extends StatelessWidget {
  const ListUsers({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ListUsersPage(),
    );
  }
}

class ListUsersPage extends StatefulWidget {
  ListUsersPage({super.key});

  @override
  State<ListUsersPage> createState() => _ListUsersPageState();
}

class _ListUsersPageState extends State<ListUsersPage> {
  final User user = User(title: 'add');
  final String baseUrl =
      'http://eduqhub-api-dev-lb-1386179597.us-east-2.elb.amazonaws.com/test-dev';
  @override
  void initState() {
    super.initState();
    http.get(Uri.parse('${this.baseUrl}/users'));
  }

  Future<List?> getUsers() async {
    var response = await http.get(Uri.parse('${this.baseUrl}/users'));
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(title: const Text(('Crud Usuários'))),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: <Widget>[
            FutureBuilder<List?>(
                future: getUsers(),
                builder: (ctx, snpashot) {
                  switch (snpashot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    case ConnectionState.active:
                    case ConnectionState.done:
                  }
                  if (snpashot.hasData) {
                    return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snpashot.data?.length,
                        itemBuilder: (context, index) {
                          final User user =
                              User(title: snpashot.data?[index]['firstName']);
                          return UserListItem(
                              user: user, onDelete: (user) => {});
                        });
                  } else {
                    return const Center(
                      child: Text("Nenhum dado a ser exibido!"),
                    );
                  }
                })
          ],
        ),
      ),
    ));
  }
}
