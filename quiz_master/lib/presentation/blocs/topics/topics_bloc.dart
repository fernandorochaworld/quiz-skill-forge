import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/quiz_repository.dart';
import 'topics_event.dart';
import 'topics_state.dart';

class TopicsBloc extends Bloc<TopicsEvent, TopicsState> {
  final QuizRepository repository;

  TopicsBloc({required this.repository}) : super(TopicsInitial()) {
    on<LoadTopics>(_onLoadTopics);
    on<RefreshTopics>(_onRefreshTopics);
  }

  Future<void> _onLoadTopics(
    LoadTopics event,
    Emitter<TopicsState> emit,
  ) async {
    emit(TopicsLoading());
    try {
      final topics = await repository.getTopics();
      emit(TopicsLoaded(topics));
    } catch (e) {
      emit(TopicsError(e.toString()));
    }
  }

  Future<void> _onRefreshTopics(
    RefreshTopics event,
    Emitter<TopicsState> emit,
  ) async {
    try {
      final topics = await repository.getTopics();
      emit(TopicsLoaded(topics));
    } catch (e) {
      emit(TopicsError(e.toString()));
    }
  }
} 