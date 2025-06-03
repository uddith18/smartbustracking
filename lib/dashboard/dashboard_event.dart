import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class LoadAdminDashboard extends DashboardEvent {
  final String date;

  const LoadAdminDashboard({required this.date});

  @override
  List<Object> get props => [date];
}

class LoadParentDashboard extends DashboardEvent {
  final int studentId;
  final String date;
  final int routeId;

  const LoadParentDashboard({
    required this.studentId,
    required this.date,
    required this.routeId,
  });

  @override
  List<Object> get props => [studentId, date, routeId];
}

class LoadMorningBusStatus extends DashboardEvent {
  final int studentId;

  const LoadMorningBusStatus({required this.studentId});

  @override
  List<Object> get props => [studentId];
}

class LoadEveningBusStatus extends DashboardEvent {
  final int studentId;

  const LoadEveningBusStatus({required this.studentId});

  @override
  List<Object> get props => [studentId];
}
