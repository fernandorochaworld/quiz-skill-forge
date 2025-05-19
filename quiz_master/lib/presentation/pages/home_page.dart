import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/topics/topics_bloc.dart';
import '../blocs/topics/topics_event.dart';
import '../blocs/topics/topics_state.dart';
import 'topics_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Master'),
        centerTitle: true,
      ),
      body: BlocBuilder<TopicsBloc, TopicsState>(
        builder: (context, state) {
          if (state is TopicsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TopicsLoaded) {
            return const TopicsPage();
          } else if (state is TopicsError) {
            return Center(
              child: Text('Error: ${state.message}'),
            );
          }
          return const Center(child: Text('No topics available'));
        },
      ),
    );
  }
} 