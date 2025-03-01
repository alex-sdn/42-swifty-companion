import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:swifty_companion/models/userdetails_model.dart';

class UserDetailsService {
  static Future<UserDetails> getUserDetails(String login, String accessToken) async {
    final Uri searchUri = Uri.parse("https://api.intra.42.fr/v2/users/$login");
    final response = await http.get(
      searchUri,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);

      List<Project> projects = data["projects_users"].map<Project>((projectData) {
        return Project(
          name: projectData["project"]["name"],
          grade: projectData["final_mark"],
          validated: projectData["validated?"],
        );
      }).toList();

      List<Skill>?  skills;
      double        level = 0;
      if (!data["cursus_users"].isEmpty) {
        skills = data["cursus_users"].last["skills"].map<Skill>((skillData) {
          return Skill(
            name: skillData["name"],
            level: skillData["level"]
          );
        }).toList();

        data["cursus_users"].length > 2
        ? level = data["cursus_users"][1]["level"]
        : level = data["cursus_users"].last["level"];
      }

      final userDetails = UserDetails(
        login: login,
        avatar: data["image"]["versions"]["medium"],
        fullName: data["displayname"],
        level: level,
        campus: data["campus"].last["name"],
        projects: projects,
        skills: skills
      );

      return userDetails;
    } else {
      throw Exception('Failed to get user details');
    }
  }
}
