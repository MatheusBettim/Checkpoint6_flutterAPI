import 'package:flutter/material.dart';
import 'package:github_api_demo/api/github_api.dart';
import 'package:github_api_demo/models/repository.dart';

class BranchesPage extends StatefulWidget {
  final Repository repository;

  BranchesPage(this.repository);

  @override
  State<BranchesPage> createState() => _BranchesPageState();
}

class _BranchesPageState extends State<BranchesPage> {
  late Future<List<String>> futureBranches;

  @override
  void initState() {
    if (widget.repository != null && widget.repository.name != null) {
      futureBranches = GitHubApi().getBranches(
        widget.repository.owner,
        widget.repository.name,
      );
    } else {
      print('Error');
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Branches - ${widget.repository.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<String>>(
          future: futureBranches,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            } else {
              final branches = snapshot.data ?? [];
              return ListView.builder(
                itemCount: branches.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(branches[index]),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
