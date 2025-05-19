import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/topic.dart';
import '../../../domain/entities/user_progress.dart';
import '../../../domain/repositories/quiz_repository.dart';
import 'topics_event.dart';
import 'topics_state.dart';

class TopicsBloc extends Bloc<TopicsEvent, TopicsState> {
  final QuizRepository _repository;

  TopicsBloc(this._repository) : super(TopicsInitial()) {
    on<LoadTopics>(_onLoadTopics);
    on<RefreshTopics>(_onRefreshTopics);
  }

  Future<void> _onLoadTopics(
    LoadTopics event,
    Emitter<TopicsState> emit,
  ) async {
    emit(TopicsLoading());
    try {
      final topics = await _repository.getTopics();
      final progress = <String, UserProgress>{};
      
      // Load progress for each topic
      for (final topic in topics) {
        final topicProgress = await _repository.getUserProgress(topic.id);
        if (topicProgress != null) {
          progress[topic.id] = topicProgress;
        }
      }

      emit(TopicsLoaded(
        topics: topics,
        progress: progress,
      ));
    } catch (e) {
      emit(TopicsError(e.toString()));
    }
  }

  Future<void> _onRefreshTopics(
    RefreshTopics event,
    Emitter<TopicsState> emit,
  ) async {
    try {
      final topics = await _repository.getTopics();
      final progress = <String, UserProgress>{};
      
      // Load progress for each topic
      for (final topic in topics) {
        final topicProgress = await _repository.getUserProgress(topic.id);
        if (topicProgress != null) {
          progress[topic.id] = topicProgress;
        }
      }

      emit(TopicsLoaded(
        topics: topics,
        progress: progress,
      ));
    } catch (e) {
      emit(TopicsError(e.toString()));
    }
  }
} 