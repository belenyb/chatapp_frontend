import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../services/users_service.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List<User> users = [];
  final UsersService usersService = UsersService();

  @override
  void initState() {
    _getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AuthService authService = Provider.of<AuthService>(context);
    final SocketService socketService = Provider.of<SocketService>(context);
    final User user = authService.user!;

    return Scaffold(
      appBar: AppBar(
        title: Text(user.name, style: theme.textTheme.titleMedium),
        backgroundColor: Colors.white,
        elevation: 0.2,
        leading: IconButton(
          onPressed: () {
            socketService.disconnect();
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
            child: socketService.serverStatus == ServerStatus.Online
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.cell_tower,
                        color: Color.fromARGB(255, 62, 154, 65),
                      ),
                      Text("Online",
                          style: theme.textTheme.bodySmall!.copyWith(
                              fontSize: 10,
                              color: const Color.fromARGB(255, 62, 154, 65))),
                    ],
                  )
                : Column(
                    children: [
                      const Icon(
                        Icons.cell_tower,
                        color: Color.fromARGB(255, 212, 58, 47),
                      ),
                      Text("Offline",
                          style: theme.textTheme.bodySmall!.copyWith(
                              fontSize: 10,
                              color: const Color.fromARGB(255, 212, 58, 47)))
                    ],
                  ),
          )
        ],
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 8),
        child: Center(
          child: RefreshIndicator(
            onRefresh: _getUsers,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: users.length,
              separatorBuilder: (_, i) => const Divider(),
              itemBuilder: (_, i) => _getUserListTile(users[i]),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _getUsers() async {
    users = await usersService.getUsers();
    setState(() {});
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
      onTap: () {
        final ChatService chatService =
            Provider.of<ChatService>(context, listen: false);
        chatService.userTo = user;
        Navigator.pushNamed(context, 'chat');
      },
    );
  }
}
