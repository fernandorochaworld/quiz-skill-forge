import 'package:equatable/equatable.dart';

class Question extends Equatable {
  final String id;
  final String topicId;
  final String text;
  final List<Answer> answers;
  final String? explanation;
  final String? imageUrl;
  final int difficulty;

  const Question({
    required this.id,
    required this.topicId,
    required this.text,
    required this.answers,
    this.explanation,
    this.imageUrl,
    required this.difficulty,
  });

  bool get isFullyAnswered => answers.every((answer) => answer.isSelected != null);

  @override
  List<Object?> get props => [
        id,
        topicId,
        text,
        answers,
        explanation,
        imageUrl,
        difficulty,
      ];
}

class Answer extends Equatable {
  final String id;
  final String text;
  final bool isCorrect;
  bool? isSelected;

  Answer({
    required this.id,
    required this.text,
    required this.isCorrect,
    this.isSelected,
  });

  @override
  List<Object?> get props => [id, text, isCorrect, isSelected];
} 