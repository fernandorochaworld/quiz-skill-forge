import 'package:equatable/equatable.dart';
import '../../../domain/entities/topic.dart';

abstract class TopicsState extends Equatable {
  const TopicsState();

  @override
  List<Object?> get props => [];
}

class TopicsInitial extends TopicsState {}

class TopicsLoading extends TopicsState {}

class TopicsLoaded extends TopicsState {
  final List<Topic> topics;

  const TopicsLoaded(this.topics);

  @override
  List<Object?> get props => [topics];
}

class TopicsError extends TopicsState {
  final String message;

  const TopicsError(this.message);

  @override
  List<Object?> get props => [message];
} 