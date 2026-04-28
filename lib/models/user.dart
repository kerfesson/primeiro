class User {
  final int? id;
  final String name;
  final String email;

  User({this.id, required this.name, required this.email});
  Map<String, dynamic> toMap() {
    return {
       if (id!= null)'id': id,
        'name': name,
        'email': email,
      };
}

factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email']);
  }
}
