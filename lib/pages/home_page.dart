import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:talkk/models/user_profile.dart';
import 'package:talkk/pages/chat_page.dart';
import 'package:talkk/services/alert_service.dart';
import 'package:talkk/services/auth_service.dart';
import 'package:talkk/services/database_service.dart';
import 'package:talkk/services/navigation_service.dart';
import 'package:talkk/widgets/chat_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GetIt getIt = GetIt.instance;
  late AuthService _authService;
  late NavigationService _navigationService;
  late AlertService _alertService;
  late DatabaseService _databaseService;

  @override
  initState() {
    super.initState();

    _authService = getIt.get<AuthService>();
    _navigationService = getIt.get<NavigationService>();
    _alertService = getIt.get<AlertService>();
    _databaseService = getIt.get<DatabaseService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages"),
        actions: [
          IconButton(
              onPressed: () async {
                bool result = await _authService.logout();
                if (result) {
                  _alertService.showToast(
                      text: "Successfully logged out!", icon: Icons.check);
                  _navigationService.pushReplacementNamed("/login");
                }
              },
              color: Colors.red,
              icon: const Icon(Icons.logout))
        ],
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        child: _chatsList(),
      ),
    );
  }

  Widget _chatsList() {
    return StreamBuilder(
        stream: _databaseService.getUserProfiles(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Unable to load data."));
          }
          if (snapshot.hasData && snapshot.data != null) {
            final users = snapshot.data!.docs;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                UserProfile user = users[index].data();
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ChatTile(
                    onTap: () async {
                      final chatExists = await _databaseService.checkChatExist(
                          _authService.user!.uid, user.uid!);

                      if (!chatExists) {
                        await _databaseService.createNewChat(
                          _authService.user!.uid,
                          user.uid!,
                        );
                      }
                      _navigationService
                          .push(MaterialPageRoute(builder: (context) {
                        return ChatPage(chatUser: user);
                      }));
                    },
                    userProfile: user,
                  ),
                );
              },
            );
          }

          return const Center(child: CircularProgressIndicator());
        });
  }
}
