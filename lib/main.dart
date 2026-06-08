import 'package:crypto_tracker/data/models/coin_model.dart';
import 'package:crypto_tracker/logic/cubits/coin_cubit.dart';
import 'package:crypto_tracker/logic/cubits/theme_cubit.dart';
import 'package:crypto_tracker/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CoinModelAdapter());
  await Hive.openBox('coinsBox');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CoinCubit()),
        BlocProvider(create: (context) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeState) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: const HomeScreen(),
            theme: ThemeData(
              brightness: Brightness.light,
              scaffoldBackgroundColor: Colors.grey[100],
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                elevation: 0,
                titleTextStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                iconTheme: IconThemeData(color: Colors.black),
              ),
              cardTheme: CardThemeData(color: Colors.white),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              scaffoldBackgroundColor: const Color(0xFF121212),
              appBarTheme: AppBarTheme(
                backgroundColor: Color(0xFF121212),
                elevation: 0,
                iconTheme: IconThemeData(color: Colors.white),
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              cardColor: const Color(0xFF1E1E1E),
            ),
            themeMode: themeState,
          );
        },
      ),
    );
  }
}
