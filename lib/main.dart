import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '1.dart';
import 'Check In - Check out/check in chekout.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrintRebuildDirtyWidgets = false;
  await Supabase.initialize(
    url: 'https://thftmoghwfgztcdmbrho.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRoZnRtb2dod2ZnenRjZG1icmhvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDM3NjAxOTksImV4cCI6MjA1OTMzNjE5OX0.rKy8P6BoyADmMVp9MrR1EzFJNvnoIoGwvKYU2Leyn-M',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
     //home: Demo(),
      home:AttendanceScreen(),
    );
  }
}
