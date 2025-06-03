import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartbustracking/auth/auth_bloc.dart';
import 'package:smartbustracking/auth/auth_event.dart';
import 'package:smartbustracking/dashboard/dashboard_bloc.dart';
import 'package:smartbustracking/dashboard/dashboard_event.dart';
import 'package:smartbustracking/dashboard/dashboard_state.dart';
import 'login_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    final currentDate = DateTime.now().toIso8601String().split('T')[0];
    context.read<DashboardBloc>().add(LoadAdminDashboard(date: currentDate));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: _loadDashboard),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is DashboardLoaded) {
            final data = state.data['result'];

            if (data == null || data.isEmpty) {
              return Center(child: Text('No data available'));
            }

            return RefreshIndicator(
              onRefresh: _loadDashboard,
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final item = data[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(item['title'] ?? 'No title'),
                      subtitle: Text(item['description'] ?? ''),
                    ),
                  );
                },
              ),
            );
          } else if (state is DashboardError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
                    SizedBox(height: 16),
                    Text(
                      'Something went wrong.',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Please try again later.',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadDashboard,
                      child: Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }
          return Center(child: Text('Welcome to Admin Dashboard'));
        },
      ),
    );
  }
}
