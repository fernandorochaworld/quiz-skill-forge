import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/quiz/quiz_bloc.dart';
import '../blocs/quiz/quiz_event.dart';
import '../blocs/quiz/quiz_state.dart';
import '../../domain/entities/topic.dart';
import '../../domain/entities/quiz_question.dart';
import '../../domain/repositories/quiz_repository.dart';

class QuizPage extends StatelessWidget {
  final Topic topic;

  const QuizPage({
    super.key,
    required this.topic,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuizBloc(
        context.read<QuizRepository>(),
      )..add(LoadQuiz(topic.id)),
      child: BlocBuilder<QuizBloc, QuizState>(
        builder: (context, state) {
          if (state is QuizLoading) {
            return Scaffold(
              appBar: AppBar(title: Text(topic.name)),
              body: const Center(child: CircularProgressIndicator()),
            );
          } else if (state is QuizLoaded) {
            return Scaffold(
              appBar: AppBar(
                title: Text(topic.name),
                actions: [
                  if (state.isCurrentQuestionAnswered)
                    IconButton(
                      icon: const Icon(Icons.help_outline),
                      onPressed: () {
                        context.read<QuizBloc>().add(ShowExplanation());
                      },
                    ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    LinearProgressIndicator(
                      value: (state.currentQuestionIndex + 1) / state.questions.length,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Question ${state.currentQuestionIndex + 1} of ${state.questions.length}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.currentQuestion.text,
                                      style: Theme.of(context).textTheme.titleLarge,
                                    ),
                                    const SizedBox(height: 24),
                                    ...state.currentQuestion.options.map(
                                      (option) => Padding(
                                        padding: const EdgeInsets.only(bottom: 8.0),
                                        child: _AnswerOption(
                                          option: option,
                                          isSelected: state.currentAnswer == option.id,
                                          isCorrect: state.showExplanation &&
                                              option.id == state.currentQuestion.correctAnswer,
                                          isWrong: state.showExplanation &&
                                              state.currentAnswer == option.id &&
                                              option.id != state.currentQuestion.correctAnswer,
                                          onTap: state.showExplanation
                                              ? null
                                              : () {
                                                  context.read<QuizBloc>().add(
                                                        AnswerQuestion(
                                                          questionId: state.currentQuestion.id,
                                                          answer: option.id,
                                                        ),
                                                      );
                                                },
                                        ),
                                      ),
                                    ),
                                    if (state.showExplanation) ...[
                                      const SizedBox(height: 24),
                                      const Divider(),
                                      const SizedBox(height: 16),
                                      Text(
                                        'Explanation:',
                                        style: Theme.of(context).textTheme.titleMedium,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        state.currentQuestion.explanation,
                                        style: Theme.of(context).textTheme.bodyMedium,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (state.currentQuestionIndex > 0)
                          ElevatedButton(
                            onPressed: () {
                              context.read<QuizBloc>().add(PreviousQuestion());
                            },
                            child: const Text('Previous'),
                          )
                        else
                          const SizedBox.shrink(),
                        if (state.isLastQuestion)
                          ElevatedButton(
                            onPressed: () {
                              context.read<QuizBloc>().add(CompleteQuiz(topic.id));
                            },
                            child: const Text('Finish Quiz'),
                          )
                        else
                          ElevatedButton(
                            onPressed: state.isCurrentQuestionAnswered
                                ? () {
                                    context.read<QuizBloc>().add(NextQuestion());
                                  }
                                : null,
                            child: const Text('Next'),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else if (state is QuizCompleted) {
            return Scaffold(
              appBar: AppBar(title: Text(topic.name)),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Quiz Completed!',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Score: ${(state.score * 100).toStringAsFixed(1)}%',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    if (state.wrongAnswers.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Text(
                        'Review Wrong Answers:',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      ...state.wrongAnswers.map((question) => Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                question.text,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Your Answer: ${state.userAnswers[question.id]}',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.red,
                                ),
                              ),
                              Text(
                                'Correct Answer: ${question.correctAnswer}',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Explanation: ${question.explanation}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      )),
                    ],
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Back to Topics'),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is QuizError) {
            return Scaffold(
              appBar: AppBar(title: Text(topic.name)),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error: ${state.message}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<QuizBloc>().add(LoadQuiz(topic.id));
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _AnswerOption extends StatelessWidget {
  final QuestionOption option;
  final bool isSelected;
  final bool isCorrect;
  final bool isWrong;
  final VoidCallback? onTap;

  const _AnswerOption({
    required this.option,
    required this.isSelected,
    required this.isCorrect,
    required this.isWrong,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color? backgroundColor;
    if (isCorrect) {
      backgroundColor = Colors.green.withOpacity(0.1);
    } else if (isWrong) {
      backgroundColor = Colors.red.withOpacity(0.1);
    } else if (isSelected) {
      backgroundColor = Theme.of(context).colorScheme.primary.withOpacity(0.1);
    }

    return Card(
      color: backgroundColor,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isCorrect
                        ? Colors.green
                        : isWrong
                            ? Colors.red
                            : isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.outline,
                  ),
                ),
                child: isSelected
                    ? Icon(
                        isCorrect
                            ? Icons.check_circle
                            : isWrong
                                ? Icons.cancel
                                : Icons.circle,
                        size: 16,
                        color: isCorrect
                            ? Colors.green
                            : isWrong
                                ? Colors.red
                                : Theme.of(context).colorScheme.primary,
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  option.text,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 