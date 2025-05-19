import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/themes/app_theme.dart';
import 'data/repositories/quiz_repository_impl.dart';
import 'domain/entities/user_progress.dart';
import 'domain/repositories/quiz_repository.dart';
import 'presentation/blocs/topics/topics_bloc.dart';
import 'presentation/blocs/topics/topics_event.dart';
import 'presentation/pages/topics_page.dart';
import 'presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register Hive adapters
  Hive.registerAdapter(UserProgressAdapter());
  
  // Open Hive boxes
  final progressBox = await Hive.openBox<UserProgress>('progress');
  
  // Create repository
  final repository = QuizRepositoryImpl(progressBox);

  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final QuizRepository repository;

  const MyApp({
    super.key,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<QuizRepository>.value(value: repository),
        BlocProvider<TopicsBloc>(
          create: (context) => TopicsBloc(repository)..add(LoadTopics()),
        ),
      ],
      child: MaterialApp(
        title: 'Quiz Master',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const TopicsPage(),
      ),
    );
  }
}
