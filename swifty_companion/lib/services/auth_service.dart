import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final String fortytwoUID = dotenv.env['FORTYTWO_UID'] ?? '';
  final String fortytwoSecret = dotenv.env['FORTYTWO_SECRET'] ?? '';
  final String apiUrl = "https://api.intra.42.fr";

  // final storage = FlutterSecureStorage();

  Future<String?> getAccessToken() async {
    // String? token = await storage.read(key: "access_token");

    // token ??= await fetchAccessToken();

    String? token = await fetchAccessToken();

    return token;
  }

  Future<String?> fetchAccessToken() async {
    final Uri tokenUri = Uri.parse("$apiUrl/oauth/token");

    final response = await http.post(
      tokenUri,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {
        "grant_type": "client_credentials",
        "client_id": fortytwoUID,
        "client_secret": fortytwoSecret,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final String token = data["access_token"];
      // final int expiresIn = data["expires_in"];
      // final int createdAt = data["created_at"];  Calculate time of expiry?

      // await storage.write(key: "access_token", value: token);
      return token;
    } else {
      print("Failed to fetch access token: ${response.body}"); //debug
      return null;
    }
  }
}
