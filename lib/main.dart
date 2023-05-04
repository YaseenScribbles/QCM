import 'package:flutter/material.dart';
import 'package:qcm/pages/loading.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QCM',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const Loading(),
    );
  }
}
