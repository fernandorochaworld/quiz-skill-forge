import 'package:equatable/equatable.dart';

abstract class TopicsEvent extends Equatable {
  const TopicsEvent();

  @override
  List<Object?> get props => [];
}

class LoadTopics extends TopicsEvent {}

class RefreshTopics extends TopicsEvent {} 