import 'package:equatable/equatable.dart';

class QuizQuestion extends Equatable {
  final String id;
  final String text;
  final String type;
  final List<QuestionOption> options;
  final String correctAnswer;
  final String explanation;

  const QuizQuestion({
    required this.id,
    required this.text,
    required this.type,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'] as String,
      text: json['text'] as String,
      type: json['type'] as String,
      options: (json['options'] as List)
          .map((option) => QuestionOption.fromJson(option))
          .toList(),
      correctAnswer: json['correctAnswer'] as String,
      explanation: json['explanation'] as String,
    );
  }

  @override
  List<Object?> get props => [id, text, type, options, correctAnswer, explanation];
}

class QuestionOption extends Equatable {
  final String id;
  final String text;

  const QuestionOption({
    required this.id,
    required this.text,
  });

  factory QuestionOption.fromJson(Map<String, dynamic> json) {
    return QuestionOption(
      id: json['id'] as String,
      text: json['text'] as String,
    );
  }

  @override
  List<Object?> get props => [id, text];
} 