import '../entities/topic.dart';
import '../entities/quiz_question.dart';
import '../entities/user_progress.dart';

abstract class QuizRepository {
  Future<List<Topic>> getTopics();
  Future<List<QuizQuestion>> getQuestionsByTopic(String topicId);
  Future<void> saveUserProgress(UserProgress progress);
  Future<UserProgress?> getUserProgress(String topicId);
  Future<void> clearUserProgress(String topicId);
} 