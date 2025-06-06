import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/quiz_question.dart';
import '../../../domain/entities/user_progress.dart';
import '../../../domain/repositories/quiz_repository.dart';
import 'quiz_event.dart';
import 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final QuizRepository _repository;

  QuizBloc(this._repository) : super(QuizInitial()) {
    on<LoadQuiz>(_onLoadQuiz);
    on<AnswerQuestion>(_onAnswerQuestion);
    on<NextQuestion>(_onNextQuestion);
    on<PreviousQuestion>(_onPreviousQuestion);
    on<ShowExplanation>(_onShowExplanation);
    on<CompleteQuiz>(_onCompleteQuiz);
  }

  Future<void> _onLoadQuiz(
    LoadQuiz event,
    Emitter<QuizState> emit,
  ) async {
    emit(QuizLoading());
    try {
      String jsonFile;
      switch (event.topicId) {
        case '1':
          jsonFile = 'assets/data/javascript_questions.json';
          break;
        case '2':
          jsonFile = 'assets/data/nodejs_questions.json';
          break;
        case '3':
          jsonFile = 'assets/data/excel_questions.json';
          break;
        default:
          throw Exception('Invalid topic ID');
      }

      final jsonString = await rootBundle.loadString(jsonFile);
      final jsonData = json.decode(jsonString);
      final questions = (jsonData['questions'] as List)
          .map((q) => QuizQuestion.fromJson(q))
          .toList();

      // Randomize questions
      questions.shuffle();

      // Randomize options for each question
      for (var question in questions) {
        question.options.shuffle();
      }

      emit(QuizLoaded(
        questions: questions,
        currentQuestionIndex: 0,
        userAnswers: {},
      ));
    } catch (e) {
      emit(QuizError(e.toString()));
    }
  }

  void _onAnswerQuestion(
    AnswerQuestion event,
    Emitter<QuizState> emit,
  ) {
    if (state is QuizLoaded) {
      final currentState = state as QuizLoaded;
      final updatedAnswers = Map<String, String>.from(currentState.userAnswers);
      updatedAnswers[event.questionId] = event.answer;

      emit(currentState.copyWith(
        userAnswers: updatedAnswers,
        showExplanation: true,
      ));
    }
  }

  void _onNextQuestion(
    NextQuestion event,
    Emitter<QuizState> emit,
  ) {
    if (state is QuizLoaded) {
      final currentState = state as QuizLoaded;
      if (!currentState.isLastQuestion) {
        emit(currentState.copyWith(
          currentQuestionIndex: currentState.currentQuestionIndex + 1,
          showExplanation: false,
        ));
      }
    }
  }

  void _onPreviousQuestion(
    PreviousQuestion event,
    Emitter<QuizState> emit,
  ) {
    if (state is QuizLoaded) {
      final currentState = state as QuizLoaded;
      if (currentState.currentQuestionIndex > 0) {
        emit(currentState.copyWith(
          currentQuestionIndex: currentState.currentQuestionIndex - 1,
          showExplanation: false,
        ));
      }
    }
  }

  void _onShowExplanation(
    ShowExplanation event,
    Emitter<QuizState> emit,
  ) {
    if (state is QuizLoaded) {
      final currentState = state as QuizLoaded;
      emit(currentState.copyWith(showExplanation: true));
    }
  }

  void _onCompleteQuiz(
    CompleteQuiz event,
    Emitter<QuizState> emit,
  ) async {
    if (state is QuizLoaded) {
      final currentState = state as QuizLoaded;
      int correctAnswers = 0;
      final wrongAnswers = <QuizQuestion>[];

      for (final question in currentState.questions) {
        final userAnswer = currentState.userAnswers[question.id];
        if (userAnswer == question.correctAnswer) {
          correctAnswers++;
        } else {
          wrongAnswers.add(question);
        }
      }

      final score = correctAnswers / currentState.questions.length;
      
      // Save the progress
      final progress = UserProgress(
        topicId: event.topicId,
        questionsAttempted: currentState.questions.length,
        correctAnswers: correctAnswers,
        lastAttempt: DateTime.now(),
      );
      
      await _repository.saveUserProgress(progress);

      emit(QuizCompleted(
        questions: currentState.questions,
        userAnswers: currentState.userAnswers,
        correctAnswers: correctAnswers,
        wrongAnswers: wrongAnswers,
      ));
    }
  }
} 