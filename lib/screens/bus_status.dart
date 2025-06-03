import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartbustracking/auth/auth_bloc.dart';
import 'package:smartbustracking/auth/auth_event.dart';
import 'package:smartbustracking/dashboard/dashboard_bloc.dart';
import 'package:smartbustracking/dashboard/dashboard_event.dart';
import 'package:smartbustracking/dashboard/dashboard_state.dart';
import 'login_screen.dart';

class StudentBusStatusScreen extends StatefulWidget {
  @override
  _StudentBusStatusScreenState createState() => _StudentBusStatusScreenState();
}

class _StudentBusStatusScreenState extends State<StudentBusStatusScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  final int studentId = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() => _currentIndex = _tabController.index);
        _loadBusStatus(_currentIndex);
      }
    });
    _loadBusStatus(0); 
  }

  void _loadBusStatus(int tabIndex) {
    final event = tabIndex == 0
        ? LoadMorningBusStatus(studentId: studentId)
        : LoadEveningBusStatus(studentId: studentId);
    context.read<DashboardBloc>().add(event);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bus Status'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => _loadBusStatus(_currentIndex),
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(icon: Icon(Icons.wb_sunny), text: 'Morning'),
            Tab(icon: Icon(Icons.nights_stay), text: 'Evening'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: ['Morning', 'Evening'].map(_buildBusStatusTab).toList(),
      ),
    );
  }

  Widget _buildBusStatusTab(String period) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is DashboardLoaded) {
          final data = state.data;
          return RefreshIndicator(
            onRefresh: () async => _loadBusStatus(period == 'Morning' ? 0 : 1),
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderCard(period),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildStatusCard('Bus Status', data['bus_status'] ?? 'Unknown', Icons.directions_bus, Colors.green)),
                      SizedBox(width: 16),
                      Expanded(child: _buildStatusCard('ETA', data['eta'] ?? 'N/A', Icons.access_time, Colors.blue)),
                    ],
                  ),
                  SizedBox(height: 16),
                  _buildJourneyInfoCard(data, period),
                ],
              ),
            ),
          );
        } else if (state is DashboardError) {
          return _buildErrorState(period, state.message);
        }
        return _buildPlaceholderState(period);
      },
    );
  }

  Widget _buildHeaderCard(String period) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              period == 'Morning' ? Icons.wb_sunny : Icons.nights_stay,
              size: 40,
              color: period == 'Morning' ? Colors.orange : Colors.indigo,
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$period Bus Status', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('Student ID: $studentId', style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
            Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _buildJourneyInfoCard(Map<String, dynamic> data, String period) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info, color: Colors.blue),
                SizedBox(width: 8),
                Text('Journey Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 16),
            _buildJourneyStep('Pickup Point', data['pickup_point'] ?? 'N/A', true),
            _buildJourneyStep('Current Location', data['current_location'] ?? 'N/A', true),
            _buildJourneyStep('Destination', data['destination'] ?? 'N/A', false),
          ],
        ),
      ),
    );
  }

  Widget _buildJourneyStep(String title, String location, bool completed) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            completed ? Icons.check_circle : Icons.radio_button_unchecked,
            color: completed ? Colors.green : Colors.grey,
            size: 20,
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
              Text(location, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String period, String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text('Error loading bus status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[600])),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _loadBusStatus(period == 'Morning' ? 0 : 1),
              child: Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderState(String period) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.directions_bus, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('Welcome to $period Bus Tracking', style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
