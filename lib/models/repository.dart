class Repository {
  final String name;
  final String owner;
  final String description;
  final int forks;
  final int watchers;

  Repository({
    required this.name,
    required this.owner,
    required this.description,
    required this.forks,
    required this.watchers,
  });

  factory Repository.fromJson(Map<String, dynamic> json) {
    return Repository(
      name: json['name'] ?? '',
      owner: json['owner']['login'] ?? '',
      description: json['description'] ?? '',
      forks: json['forks'] ?? 0,
      watchers: json['watchers_count'] ?? 0,
    );
  }
}
