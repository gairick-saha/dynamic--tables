import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './screens/home_screen.dart';
import './cubits/data_cubit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dynamic Tables Demo',
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
      ).copyWith(
        useMaterial3: true,
      ),
      home: BlocProvider<DataCubit>(
        create: (context) => DataCubit(),
        child: const HomeScreen(),
      ),
    );
  }
}
