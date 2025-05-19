import 'package:equatable/equatable.dart';
import '../../../domain/entities/quiz_question.dart';

abstract class QuizState extends Equatable {
  const QuizState();

  @override
  List<Object?> get props => [];
}

class QuizInitial extends QuizState {}

class QuizLoading extends QuizState {}

class QuizLoaded extends QuizState {
  final List<QuizQuestion> questions;
  final int currentQuestionIndex;
  final Map<String, String> userAnswers;
  final bool showExplanation;

  const QuizLoaded({
    required this.questions,
    required this.currentQuestionIndex,
    required this.userAnswers,
    this.showExplanation = false,
  });

  QuizLoaded copyWith({
    List<QuizQuestion>? questions,
    int? currentQuestionIndex,
    Map<String, String>? userAnswers,
    bool? showExplanation,
  }) {
    return QuizLoaded(
      questions: questions ?? this.questions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      userAnswers: userAnswers ?? this.userAnswers,
      showExplanation: showExplanation ?? this.showExplanation,
    );
  }

  bool get isLastQuestion => currentQuestionIndex == questions.length - 1;
  QuizQuestion get currentQuestion => questions[currentQuestionIndex];
  String? get currentAnswer => userAnswers[currentQuestion.id];
  bool get isCurrentQuestionAnswered => currentAnswer != null;

  @override
  List<Object?> get props => [
        questions,
        currentQuestionIndex,
        userAnswers,
        showExplanation,
      ];
}

class QuizError extends QuizState {
  final String message;

  const QuizError(this.message);

  @override
  List<Object?> get props => [message];
}

class QuizCompleted extends QuizState {
  final List<QuizQuestion> questions;
  final Map<String, String> userAnswers;
  final int correctAnswers;
  final List<QuizQuestion> wrongAnswers;

  const QuizCompleted({
    required this.questions,
    required this.userAnswers,
    required this.correctAnswers,
    required this.wrongAnswers,
  });

  double get score => correctAnswers / questions.length;

  @override
  List<Object?> get props => [questions, userAnswers, correctAnswers, wrongAnswers];
} 