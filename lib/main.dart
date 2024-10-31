import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:talkk/services/auth_service.dart';
import 'package:talkk/services/navigation_service.dart';
import 'package:talkk/utils.dart';

void main() async {
  await setup();
  runApp(MyApp());
}

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupFirebass();
  await registerServices();
}

class MyApp extends StatelessWidget {
  final GetIt _getIt = GetIt.instance;

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigationService navigationService = _getIt.get<NavigationService>();
    final AuthService authService = _getIt.get<AuthService>();

    return MaterialApp(
      navigatorKey: navigationService.navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      initialRoute: authService.user != null ? "/home" : "/login",
      routes: navigationService.routes,
    );
  }
}
