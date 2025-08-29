// lib/features/dashboard/presentation/manager/dashboard_state.dart


import '../../domain/entities/dashboard_entity.dart';

abstract class DashboardState {
  const DashboardState();
}

// Initial state before any data is fetched.
class DashboardInitial extends DashboardState {}

// State while data is being fetched from the API.
class DashboardLoading extends DashboardState {}

// State when data has been successfully loaded.
class DashboardLoaded extends DashboardState {
  final DashboardEntity dashboardData;
  const DashboardLoaded(this.dashboardData);
}

// State when an error occurs during data fetching.
class DashboardError extends DashboardState {
  final String message;
  const DashboardError(this.message);
}