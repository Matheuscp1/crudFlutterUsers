import 'package:crud_users/model/User.m.dart';
import 'package:flutter/material.dart';

class UserListItem extends StatefulWidget {
  const UserListItem(
      {Key? key,
      required this.user,
      required this.onDelete,
      required this.onNavigate})
      : super(key: key);
  final User user;
  final void Function(String user) onDelete;
  final VoidCallback onNavigate;

  @override
  State<UserListItem> createState() => _UserListItemState();
}

class _UserListItemState extends State<UserListItem> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey<User>(widget.user),
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
                    Navigator.of(context).pop(true);
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Deletar'),
                  onPressed: () {
                    widget.onDelete(widget.user.id!);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          Navigator.of(context)
              .pushNamed('/form', arguments: widget.user)
              .then((value) {
            widget.onNavigate();
          });
        },
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            alignment: Alignment.center,
            child: Card(
              color: const Color(0xFFF5F5F5),
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                  side: const BorderSide(
                    color: Colors.grey,
                  )),
              child: ListTile(
                  title: Text(widget.user.firstName ?? 'Vazio'),
                  subtitle: Text(widget.user.lastName ?? 'Vazio'),
                  leading: widget.user.picture != null &&
                          widget.user.picture!.contains('https')
                      ? Image.network(widget.user.picture!)
                      : null),
            )),
      ),
    );
  }
}

/*         decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4), color: Colors.grey[200]),
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(16), */