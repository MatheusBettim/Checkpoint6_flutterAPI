import 'package:flutter/material.dart';
import 'package:github_api_demo/api/github_api.dart';
import 'package:github_api_demo/models/repository.dart';
import 'package:github_api_demo/pages/branches_page.dart';
import 'package:github_api_demo/pages/following_page.dart';
import 'package:github_api_demo/pages/followers_page.dart';

import '../models/user.dart';

class RepositoriesPage extends StatefulWidget {
  final User user;
  RepositoriesPage(this.user);

  @override
  State<RepositoriesPage> createState() => _RepositoriesPageState();
}

class _RepositoriesPageState extends State<RepositoriesPage> {
  late Future<List<Repository>> futureRepositories;
  int _currentIndex = 2;

  @override
  void initState() {
    futureRepositories = GitHubApi().getRepositories(widget.user.login);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Repositories"),
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
              child: _buildRepositoriesList(),
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
            if (index == 0) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => FollowingPage(widget.user),
                ),
              );
            } else if (index == 1) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => FollowersPage(widget.user),
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

  Widget _buildRepositoriesList() {
    return FutureBuilder<List<Repository>>(
      future: futureRepositories,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text("Error"),
          );
        } else {
          final repositories = snapshot.data ?? [];
          return ListView.builder(
            itemCount: repositories.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(repositories[index].name),
                subtitle: Text(repositories[index].description),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Forks: ${repositories[index].forks}'),
                    Text('Watchers: ${repositories[index].watchers}'),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) =>
                          BranchesPage(repositories[index]),
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }
}
