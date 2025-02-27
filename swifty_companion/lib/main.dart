import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:swifty_companion/pages/search.dart';
import 'package:swifty_companion/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthService _authService = AuthService();
  
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<String?>(
        future: _authService.getAccessToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasError || !snapshot.hasData) {
            return Scaffold(body: Center(child: Text("Authentication failed")));
          } else {
            return SearchPage(accessToken: snapshot.data!);
          }
        },
      ),
    );
  }
}
