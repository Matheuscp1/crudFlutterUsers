import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/User.m.dart';

class UserListItem extends StatelessWidget {
  const UserListItem({Key? key, required this.user, required this.onDelete})
      : super(key: key);
  final User user;
  final void Function(User user) onDelete;
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey<User>(user),
      direction: DismissDirection.endToStart,
      background: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4), color: Colors.red),
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(16),
        alignment: Alignment.centerRight,
        child: Icon(Icons.delete),
      ),
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Deseja deletar?'),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Voltar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Deletar'),
                  onPressed: () {
                    onDelete(user);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4), color: Colors.grey[200]),
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(16),
        child:
            /*       Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(
            user.title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          )
        ]) */
            GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            /*   showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Deseja deletar?'),
                  actions: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle: Theme.of(context).textTheme.labelLarge,
                      ),
                      child: const Text('Voltar'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                        textStyle: Theme.of(context).textTheme.labelLarge,
                      ),
                      child: const Text('Deletar'),
                      onPressed: () {
                        onDelete(user);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            ); */
            Navigator.of(context).pushNamed('/form', arguments: user);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            alignment: Alignment.center,
            child: const CircleAvatar(
              child: Icon(Icons.account_circle),
            ),
          ),
        ),
      ),
    );
  }
}
