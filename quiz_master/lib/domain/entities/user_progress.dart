import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'user_progress.g.dart';

@HiveType(typeId: 0)
class UserProgress extends Equatable {
  @HiveField(0)
  final String topicId;
  
  @HiveField(1)
  final int questionsAttempted;
  
  @HiveField(2)
  final int correctAnswers;
  
  @HiveField(3)
  final DateTime lastAttempt;

  const UserProgress({
    required this.topicId,
    required this.questionsAttempted,
    required this.correctAnswers,
    required this.lastAttempt,
  });

  double get accuracy => questionsAttempted > 0 
      ? correctAnswers / questionsAttempted 
      : 0.0;

  @override
  List<Object?> get props => [
        topicId,
        questionsAttempted,
        correctAnswers,
        lastAttempt,
      ];
} 