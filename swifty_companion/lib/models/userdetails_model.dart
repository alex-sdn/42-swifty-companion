
class Project {
  String  name;
  int?    grade;
  bool?   validated;

  Project({
    required this.name,
    required this.grade,
    required this.validated
  });

  @override
  String toString() {
    return 'Project(name: $name, grade: $grade, validated: $validated)';
  }
}

class Skill {
  String  name;
  double  level;

  Skill({required this.name, required this.level});

  @override
  String toString() {
    // TODO: implement toString
    return 'Skill(name: $name, level: $level)';
  }
}

class UserDetails {
  String        login;
  String        avatar;
  String        fullName;
  double        level;
  List<Project> projects;
  List<Skill>   skills;

  UserDetails({
    required this.login,
    required this.avatar,
    required this.fullName,
    required this.level,
    required this.projects,
    required this.skills
  });

  @override
  String toString() {
    return 'UserDetails(login: $login, avatar: $avatar, fullName: $fullName, level: $level, projects: ${projects.map((project) => project.toString()).toList()}, skills: ${skills.map((skill) => skill.toString()).toList()})';
  }
}