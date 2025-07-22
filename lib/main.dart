import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import './routes/app_routes.dart';
import './services/supabase_service.dart';
import './theme/app_theme.dart';
import 'core/app_export.dart';
import 'presentation/dashboard_home/dashboard_home.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Sizer for responsive design
  Sizer.init();

  // Initialize Supabase
  try {
    SupabaseService();
  } catch (e) {
    debugPrint('Failed to initialize Supabase: $e');
  }

  runApp(const LuxeVistaResortApp());
}

class LuxeVistaResortApp extends StatelessWidget {
  const LuxeVistaResortApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LuxeVista Resort',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: 1.0,
          ),
          child: child!,
        );
      },
      routes: AppRoutes.routes,
      initialRoute: AppRoutes.loginScreen,
    );
  }
}