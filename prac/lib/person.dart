import 'package:equatable/equatable.dart';

class Person extends Equatable {
  Person({
    required this.id,
    required this.name,
    required this.email,
  });

  final int id;
  final String name;
  final String email;


  @override
  String toString() => 'Person(id: $id, name: $name, email: $email)';

  Person copyWith({
    int? id,
    String? name,
    String? email,
  }) {
    return Person(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  @override
  List<Object> get props => [id, name, email];
}
