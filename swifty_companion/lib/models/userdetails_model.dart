
class Project {
  String  name;
  int?    grade;
  bool?   validated;

  Project({
    required this.name,
    required this.grade,
    required this.validated
  });
}

class Skill {
  String  name;
  double  level;

  Skill({required this.name, required this.level});
}

class UserDetails {
  String        login;
  String?       avatar;
  String        fullName;
  double        level;
  String        campus;
  List<Project> projects;
  List<Skill>   skills;

  UserDetails({
    required this.login,
    required this.avatar,
    required this.fullName,
    required this.level,
    required this.campus,
    required this.projects,
    required this.skills
  });
}