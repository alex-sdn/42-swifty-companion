import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  final String accessToken;

  const SearchPage({super.key, required this.accessToken});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('SEARCH PAGE\n$accessToken')
      )
    );
  }
}
