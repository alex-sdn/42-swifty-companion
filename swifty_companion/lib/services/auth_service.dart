import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final String fortytwoUID = dotenv.env['FORTYTWO_UID'] ?? '';
  final String fortytwoSecret = dotenv.env['FORTYTWO_SECRET'] ?? '';
  final String apiUrl = "https://api.intra.42.fr";

  final storage = FlutterSecureStorage();

  Future<String?> getAccessToken() async {
    String? token = await storage.read(key: "access_token");
    String? expiry = await storage.read(key: "expiry_time");

    if (token == null || !isTokenValid(expiry)) {
      return await fetchAccessToken();
    }
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
      final DateTime expiry = DateTime.now().add(Duration(seconds: data["expires_in"]));

      await storage.write(key: "access_token", value: token);
      await storage.write(key: "expiry_time", value: expiry.toIso8601String());
      return token;
    } else {
      throw Exception("Failed to fetch access token: ${response.body}");
    }
  }

  bool isTokenValid(String? expiry) {
    if (expiry == null) return false;

    final DateTime expiryTime = DateTime.parse(expiry);

    return DateTime.now().isBefore(expiryTime);
  }
}
