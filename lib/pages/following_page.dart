import 'package:flutter/material.dart';
import 'package:github_api_demo/api/github_api.dart';
import 'package:github_api_demo/pages/followers_page.dart';
import 'package:github_api_demo/pages/repositories_page.dart';
import '../models/user.dart';

class FollowingPage extends StatefulWidget {
  final User user;
  FollowingPage(this.user);

  @override
  State<FollowingPage> createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
  late Future<List<User>> futureUsers;
  int _currentIndex = 0;

  @override
  void initState() {
    futureUsers = GitHubApi().getFollowing(widget.user.login);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Following"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CircleAvatar(
                      radius: 50.0,
                      backgroundColor: Colors.blue,
                      backgroundImage: NetworkImage(widget.user.avatarUrl),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    widget.user.login,
                    style: TextStyle(fontSize: 22),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: _buildFollowingList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Following',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Followers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'Repositories',
          ),
        ],
        onTap: (index) {
          if (_currentIndex != index) {
            if (index == 1) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => FollowersPage(widget.user),
                ),
              );
            } else if (index == 2) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) =>
                      RepositoriesPage(widget.user),
                ),
              );
            }

            setState(() {
              _currentIndex = index;
            });
          }
        },
      ),
    );
  }

  Widget _buildFollowingList() {
    return FutureBuilder<List<User>>(
      future: futureUsers,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text("Erro"),
          );
        } else {
          final users = snapshot.data ?? [];
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(users[index].avatarUrl),
                ),
                title: Text(users[index].login),
              );
            },
          );
        }
      },
    );
  }
}
