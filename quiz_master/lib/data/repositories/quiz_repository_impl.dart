import 'package:hive/hive.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/entities/topic.dart';
import '../../domain/entities/quiz_question.dart';
import '../../domain/entities/user_progress.dart';
import '../../domain/repositories/quiz_repository.dart';

class QuizRepositoryImpl implements QuizRepository {
  final Box<UserProgress> _progressBox;

  QuizRepositoryImpl(this._progressBox);

  @override
  Future<List<Topic>> getTopics() async {
    return [
      Topic(
        id: '1',
        name: 'JavaScript',
        description: 'Test your JavaScript knowledge',
        imageUrl: 'assets/images/javascript.png',
        questionCount: 10,
      ),
      Topic(
        id: '2',
        name: 'Node.js',
        description: 'Master Node.js concepts',
        imageUrl: 'assets/images/nodejs.png',
        questionCount: 10,
      ),
      Topic(
        id: '3',
        name: 'Excel',
        description: 'Excel formulas and functions',
        imageUrl: 'assets/images/excel.png',
        questionCount: 10,
      ),
    ];
  }

  @override
  Future<List<QuizQuestion>> getQuestionsByTopic(String topicId) async {
    String jsonFile;
    switch (topicId) {
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

    try {
      final String jsonString = await rootBundle.loadString(jsonFile);
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> questionsJson = jsonData['questions'];

      return questionsJson.map((json) => QuizQuestion.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load questions: $e');
    }
  }

  @override
  Future<void> saveUserProgress(UserProgress progress) async {
    await _progressBox.put(progress.topicId, progress);
  }

  @override
  Future<UserProgress?> getUserProgress(String topicId) async {
    return _progressBox.get(topicId);
  }

  @override
  Future<void> clearUserProgress(String topicId) async {
    await _progressBox.delete(topicId);
  }
} 