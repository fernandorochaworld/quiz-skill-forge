import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/topics/topics_bloc.dart';
import '../blocs/topics/topics_event.dart';
import '../blocs/topics/topics_state.dart';
import '../widgets/topic_card.dart';
import '../../domain/repositories/quiz_repository.dart';

class TopicsPage extends StatelessWidget {
  const TopicsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TopicsBloc(
        context.read<QuizRepository>(),
      )..add(LoadTopics()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Topics'),
        ),
        body: BlocBuilder<TopicsBloc, TopicsState>(
          builder: (context, state) {
            if (state is TopicsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TopicsLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<TopicsBloc>().add(RefreshTopics());
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.topics.length,
                  itemBuilder: (context, index) {
                    final topic = state.topics[index];
                    final progress = state.progress[topic.id];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: TopicCard(
                        topic: topic,
                        progress: progress,
                      ),
                    );
                  },
                ),
              );
            } else if (state is TopicsError) {
              return Center(
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
                        context.read<TopicsBloc>().add(LoadTopics());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
} 