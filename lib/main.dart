import 'package:flutter/material.dart';

main() => runApp(const ListUsers());

class ListUsers extends StatelessWidget {
  const ListUsers({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ListUsersPage(),
    );
  }
}

class ListUsersPage extends StatelessWidget {
  const ListUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
      child: Center(
          child: Card(
        color: Colors.blue,
        child: Text('Initi'),
      )),
    )));
  }
}
