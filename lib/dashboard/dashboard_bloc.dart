
// lib/bloc/dashboard/dashboard_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/api_service.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final ApiService apiService;

  DashboardBloc(this.apiService) : super(DashboardInitial()) {
    on<LoadAdminDashboard>(_onLoadAdminDashboard);
    on<LoadParentDashboard>(_onLoadParentDashboard);
    on<LoadMorningBusStatus>(_onLoadMorningBusStatus);
    on<LoadEveningBusStatus>(_onLoadEveningBusStatus);
  }

  Future<void> _onLoadAdminDashboard(LoadAdminDashboard event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading());
    try {
      final data = await apiService.getAdminDashboard(event.date);
      emit(DashboardLoaded(data: data));
    } catch (e) {
      emit(DashboardError(message: e.toString()));
    }
  }

  Future<void> _onLoadParentDashboard(LoadParentDashboard event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading());
    try {
      final data = await apiService.getParentDashboard(event.studentId, event.date, event.routeId);
      emit(DashboardLoaded(data: data));
    } catch (e) {
      emit(DashboardError(message: e.toString()));
    }
  }

  Future<void> _onLoadMorningBusStatus(LoadMorningBusStatus event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading());
    try {
      final data = await apiService.getMorningBusStatus(event.studentId);
      emit(DashboardLoaded(data: data));
    } catch (e) {
      emit(DashboardError(message: e.toString()));
    }
  }

  Future<void> _onLoadEveningBusStatus(LoadEveningBusStatus event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading());
    try {
      final data = await apiService.getEveningBusStatus(event.studentId);
      emit(DashboardLoaded(data: data));
    } catch (e) {
      emit(DashboardError(message: e.toString()));
    }
  }
}