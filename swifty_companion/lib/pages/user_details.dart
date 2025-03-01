import 'package:flutter/material.dart';
import 'package:swifty_companion/models/userdetails_model.dart';
import 'package:swifty_companion/services/userdetails_service.dart';

class UserDetailsPage extends StatefulWidget {
  final String accessToken;
  final String login;

  const UserDetailsPage({
    super.key,
    required this.accessToken,
    required this.login
  });

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  late UserDetails userDetails;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    try {
      userDetails = await UserDetailsService.getUserDetails(widget.login, widget.accessToken);

      setState(() {
        _isLoading = false;
      });
    } catch(error) {
      if (!mounted) return; 
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: $error"),
      ));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.login),
        centerTitle: true,
        backgroundColor: Colors.white
      ),
      body: _isLoading
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // MAIN DETAILS
              _mainDetails(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text("Projects", style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500)),
                    _projectsList(),
                    SizedBox(height: 20),
                    Text("Skills", style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500)),
                    _skillsList()
                  ]
                )
              ),
            ],
          ),
        )
    );
  }

  Container _skillsList() {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
      padding: EdgeInsets.symmetric(vertical: 10.0),
      constraints: BoxConstraints(
        maxHeight: 300
      ),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10)
      ),
      child: SingleChildScrollView(
        child: Column(
          children: userDetails.skills.isEmpty
            ? [Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Text("No skills found")
              )]
            : userDetails.skills.map((skill) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          " ${skill.name}",
                          style: TextStyle(
                            fontSize: 15,
                          )
                        ),
                        Text(
                          "Level ${skill.level.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 15,
                          )
                        )
                      ],
                    ),
                    SizedBox(height: 3),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        LinearProgressIndicator(
                          value: skill.level / 21,
                          minHeight: 26,
                          borderRadius: BorderRadius.circular(10),
                          backgroundColor: const Color.fromARGB(255, 211, 211, 211),
                          valueColor: AlwaysStoppedAnimation(Colors.blueGrey),                    
                        ),
                        Text(
                          "${(skill.level / 21 * 100).toStringAsFixed(2)}%",
                          style: TextStyle(fontSize: 14),
                        )
                      ],
                    )
                  ],
                ) 
              );
            }).toList(),
        )
      )
    );
  }

  Container _projectsList() {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
      padding: EdgeInsets.symmetric(vertical: 10.0),
      constraints: BoxConstraints(
        maxHeight: 300
      ),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10)
      ),
      child: SingleChildScrollView(
        child: Column(
          children: userDetails.projects.isEmpty
            ? [Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Text("No projects found")
              )]
            : userDetails.projects.map((project) {
              Color gradeColor = project.validated == true
                ? Colors.green
                : project.validated == false
                  ? Colors.red
                  : Colors.grey;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        project.name,
                        style: TextStyle(
                          fontSize: 15,
                          color: project.validated != null ? Colors.black87 : Colors.grey
                        )
                      ),
                    ),
                    Text(
                      project.grade != null ? project.grade.toString() : "In Progress",
                      style: TextStyle(fontSize: 15, color: gradeColor),
                    ),
                  ],
                ),
              );
            }).toList(),
        )
      )
    );
  }

  Container _mainDetails() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey[200]
      ),
      child: Column(
        children: [
          // AVATAR
          Center(child: CircleAvatar(
            radius: 100,
            backgroundImage: userDetails.avatar != null
              ? NetworkImage(userDetails.avatar ?? '')
              : AssetImage('assets/images/42_logo.jpg'),
          )),
          SizedBox(height: 15),
          Text(
            userDetails.fullName,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 6),
          // CAMPUS
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on, 
                color: Colors.grey[700],
                size: 18,
              ),
              SizedBox(width: 2),
              Text(
                userDetails.campus,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              )
            ],
          ),
          SizedBox(height: 14),
          // LEVEL
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Stack(
              alignment: Alignment.center,
              children: [
                LinearProgressIndicator(
                  value: userDetails.level % 1,
                  minHeight: 36,
                  borderRadius: BorderRadius.circular(15),
                  backgroundColor: const Color.fromARGB(255, 211, 211, 211),
                  valueColor: AlwaysStoppedAnimation(Colors.lightBlue),                    
                ),
                Text(
                  "Level ${userDetails.level.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
