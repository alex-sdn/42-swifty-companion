import 'package:flutter/material.dart';
import 'package:swifty_companion/models/usersearch_model.dart';
import 'package:swifty_companion/pages/user_details.dart';
import 'package:swifty_companion/services/search_service.dart';

class SearchPage extends StatefulWidget {
  final String accessToken;

  const SearchPage({super.key, required this.accessToken});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<UserSearch> _searchResults = [];
  bool _hasSearched = false;
  bool _isLoading = false;

  Future<void> _performSearch(String query) async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<UserSearch> results = await SearchService().searchUsers(query, widget.accessToken);

      setState(() {
        _searchResults = results;
        _hasSearched = true;
      });
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: $error"),
      ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search Users")),
      backgroundColor:  Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _searchField(),
            SizedBox(height: 20),
            if (_isLoading) CircularProgressIndicator(),
            _resultsList(),
          ],
        ),
      ),
    );
  }

  Expanded _resultsList() {
    return Expanded(
      child: _hasSearched
        ? (_searchResults.isEmpty
          ? Center(child: Text("No users found."))
          : ListView.builder(
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: _searchResults[index].avatar != null
                      ? NetworkImage(_searchResults[index].avatar ?? '')
                      : AssetImage('assets/images/42_logo.jpg'),
                ),
                title: Text(_searchResults[index].login),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserDetailsPage(
                      login: _searchResults[index].login,
                      accessToken: widget.accessToken
                    ))
                  );
                },
              );
            },
          ))
        : Container(),
    );
  }

  TextField _searchField() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        labelText: 'Enter student login',
        labelStyle: TextStyle(color: Colors.black),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            _performSearch(_searchController.text.trim());
          },
        ),
      ),
      onSubmitted: (value) {
        _performSearch(value.trim());
      },
    );
  }
}
