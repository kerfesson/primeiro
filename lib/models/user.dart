class User {
  final int? id;
  final String name;
  final String email;
  final String telefone;

  User({this.id, required this.name, required this.email, required this.telefone});
  Map<String, dynamic> toMap() {
    return {
       if (id!= null)'id': id,
        'name': name,
        'email': email,
        'telefone': telefone,
      };
}

factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      telefone: map['telefone']
    );
  }
}
