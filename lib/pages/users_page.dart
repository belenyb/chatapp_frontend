import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final List<User> users = [
    User(isOnline: true, email: 'maria@gmail.com', name: 'Maria', uid: '1'),
    User(isOnline: false, email: 'pepe@gmail.com', name: 'Esteban', uid: '2'),
    User(isOnline: false, email: 'pepe@gmail.com', name: 'Roberto', uid: '3'),
    User(isOnline: false, email: 'pepe@gmail.com', name: 'Belen', uid: '4'),
  ];
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AuthService authService = Provider.of<AuthService>(context);
    final User user = authService.user!;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(user.name, style: theme.textTheme.titleMedium),
          backgroundColor: Colors.white,
          elevation: 0.2,
          leading: IconButton(
            onPressed: () {
              // TODO disconnect sockets
              Navigator.pushReplacementNamed(context, 'login');
              AuthService.deleteToken();
            },
            icon: Icon(
              Icons.exit_to_app_outlined,
              color: theme.primaryColor,
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: const Icon(
                Icons.check_circle,
                color: Colors.blueAccent,
              ),
            )
          ],
        ),
        body: Container(
          margin: const EdgeInsets.only(top: 8),
          child: Center(
            child: RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(Duration(milliseconds: 2000));
                print('Refresh ready!');
              },
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: users.length,
                separatorBuilder: (_, i) => const Divider(),
                itemBuilder: (_, i) => _getUserListTile(users[i]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ListTile _getUserListTile(User user) {
    return ListTile(
      title: Text(user.name),
      subtitle: Text(user.email),
      leading: CircleAvatar(
        child: Text(
          user.name.substring(0, 2),
        ),
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: user.isOnline ? Colors.green[300] : Colors.red[300],
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
