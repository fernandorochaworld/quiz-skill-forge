import 'package:equatable/equatable.dart';

abstract class QuizEvent extends Equatable {
  const QuizEvent();

  @override
  List<Object?> get props => [];
}

class LoadQuiz extends QuizEvent {
  final String topicId;

  const LoadQuiz(this.topicId);

  @override
  List<Object?> get props => [topicId];
}

class AnswerQuestion extends QuizEvent {
  final String questionId;
  final String answer;

  const AnswerQuestion({
    required this.questionId,
    required this.answer,
  });

  @override
  List<Object?> get props => [questionId, answer];
}

class NextQuestion extends QuizEvent {}

class PreviousQuestion extends QuizEvent {}

class ShowExplanation extends QuizEvent {}

class CompleteQuiz extends QuizEvent {} 