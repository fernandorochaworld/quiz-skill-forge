import 'package:equatable/equatable.dart';

class Topic extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final int questionCount;

  const Topic({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.questionCount,
  });

  @override
  List<Object?> get props => [id, name, description, imageUrl, questionCount];
} 