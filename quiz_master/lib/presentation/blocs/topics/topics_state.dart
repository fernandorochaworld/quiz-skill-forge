import 'package:equatable/equatable.dart';
import '../../../domain/entities/topic.dart';
import '../../../domain/entities/user_progress.dart';

abstract class TopicsState extends Equatable {
  const TopicsState();

  @override
  List<Object?> get props => [];
}

class TopicsInitial extends TopicsState {}

class TopicsLoading extends TopicsState {}

class TopicsLoaded extends TopicsState {
  final List<Topic> topics;
  final Map<String, UserProgress> progress;

  const TopicsLoaded({
    required this.topics,
    required this.progress,
  });

  @override
  List<Object?> get props => [topics, progress];
}

class TopicsError extends TopicsState {
  final String message;

  const TopicsError(this.message);

  @override
  List<Object?> get props => [message];
} 