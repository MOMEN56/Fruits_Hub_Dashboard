import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fruits_hub_dashboard/core/helper_functions/on_generate_routes.dart';
import 'package:fruits_hub_dashboard/core/service/get_it_service.dart';
import 'package:fruits_hub_dashboard/features/dashboard/presentation/views/dashboard_view.dart';
import 'package:fruits_hub_dashboard/firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase

  // Supabase
  await Supabase.initialize(
    url: 'https://iwhxwcqfcpcblvdifidv.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Iml3aHh3Y3FmY3BjYmx2ZGlmaWR2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njk2MjA0NzgsImV4cCI6MjA4NTE5NjQ3OH0.BZp9PXcXXOJbb5Npy3wra7JO6Ed0M-JrRqYXSQ8F83c',
  );
  // GetIt setup بعد التهيئة
  setupGetit();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      initialRoute: DashboardView.routeName,
      onGenerateRoute: onGenerateRoute,
    );
  }
}
