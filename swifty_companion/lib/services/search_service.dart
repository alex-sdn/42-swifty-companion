import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:swifty_companion/models/usersearch_model.dart';

class SearchService {
  Future<List<UserSearch>> searchUsers(String query, String? accessToken) async {
    final Uri searchUri = Uri.parse("https://api.intra.42.fr/v2/users?range[login]=$query,${query}z");
    final response = await http.get(
      searchUri,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      List<UserSearch> users = data.map<UserSearch>((userData) {
        return UserSearch(
          login: userData["login"],
          avatar: userData["image"]["versions"]["small"],
        );
      }).toList();

      return users;
    } else {
      throw Exception('Failed to load users');
    }
  }
}
