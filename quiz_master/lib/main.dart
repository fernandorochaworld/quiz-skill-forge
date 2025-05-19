import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/themes/app_theme.dart';
import 'data/repositories/quiz_repository_impl.dart';
import 'domain/entities/user_progress.dart';
import 'presentation/blocs/topics/topics_bloc.dart';
import 'presentation/blocs/topics/topics_event.dart';
import 'presentation/pages/topics_page.dart';
import 'presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(UserProgressAdapter());
  final progressBox = await Hive.openBox<UserProgress>('progress');
  
  // Create repository
  final repository = QuizRepositoryImpl(progressBox);

  runApp(QuizApp(repository: repository));
}

class QuizApp extends StatelessWidget {
  final QuizRepositoryImpl repository;

  const QuizApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TopicsBloc(repository: repository)
            ..add(LoadTopics()),
        ),
      ],
      child: MaterialApp(
        title: 'Quiz Master',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: BlocProvider(
          create: (context) => TopicsBloc(repository: repository)
            ..add(LoadTopics()),
          child: const HomePage(),
        ),
      ),
    );
  }
}
