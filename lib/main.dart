import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/api_service.dart';
import 'auth/auth_bloc.dart';
import 'dashboard/dashboard_bloc.dart';
import 'screens/login_screen.dart';
import 'screens/admin_dashboard.dart';
import 'screens/parent_dashboard.dart';
import 'screens/bus_status.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(ApiService()),
        ),
        BlocProvider(
          create: (context) => DashboardBloc(ApiService()),
        ),
      ],
      child: MaterialApp(
        title: 'Smart Track',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: AuthWrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoggedIn = false;
  String _userType = '';

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String userType = prefs.getString('userType') ?? '';
    
    setState(() {
      _isLoggedIn = isLoggedIn;
      _userType = userType;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoggedIn) {
      return LoginScreen();
    }

    switch (_userType) {
      case 'Admin':
        return AdminDashboardScreen();
      case 'Assistant':
        return ParentDashboardScreen();
      case 'Student':
        return StudentBusStatusScreen();
      default:
        return LoginScreen();
    }
  }
}