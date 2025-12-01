class Usuario {
  final int id;
  final String? username;
  final String? email;

  Usuario({required this.id, this.username, this.email});

  factory Usuario.fromJson(dynamic j) {
    if (j == null) throw ArgumentError('UsuarioRef json null');
    if (j is int) return Usuario(id: j);
    final Map<String, dynamic> m = (j as Map).cast<String, dynamic>();
    return Usuario(
      id: m['id'] ?? 0,
      username: m['username'] ?? m['nome'],
      email: m['email'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        if (username != null) 'username': username,
        if (email != null) 'email': email,
      };
}