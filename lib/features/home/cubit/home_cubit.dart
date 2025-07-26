import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../service/home_service.dart';
import '../../../services/shared_preferences/shared_preferences.dart';

/// Home Cubit với authentication handling
class HomeCubit extends Cubit<HomeState> {
  final HomeService _homeService;

  HomeCubit(this._homeService) : super(HomeInitial());

  /// Load dashboard data với token authentication
  Future<void> loadDashboard() async {
    try {
      emit(HomeLoading());

      // Check authentication trước khi gọi API
      final isLoggedIn = await SharedPreferencesService.isLoggedIn();
      if (!isLoggedIn) {
        emit(HomeError('Người dùng chưa đăng nhập'));
        return;
      }

      // Lấy thông tin user hiện tại
      final userData = await SharedPreferencesService.getUserData();
      print('[HOME] Current user: ${userData?['username'] ?? 'Unknown'}');

      // Gọi API để lấy dashboard data
      final dashboardData = await _homeService.getDashboardData();
      final statsData = await _homeService.getUserStats();
      final recentActivities = await _homeService.getRecentActivities();

      emit(
        HomeLoaded(
          dashboardData: dashboardData,
          userStats: statsData,
          recentActivities: recentActivities,
          currentUser: userData,
        ),
      );
    } catch (e) {
      print('[HOME] Error loading dashboard: $e');
      emit(HomeError(e.toString()));
    }
  }

  /// Refresh dashboard data
  Future<void> refreshDashboard() async {
    // Không emit loading state để tránh flickering
    try {
      final dashboardData = await _homeService.getDashboardData();
      final statsData = await _homeService.getUserStats();
      final recentActivities = await _homeService.getRecentActivities();
      final userData = await SharedPreferencesService.getUserData();

      emit(
        HomeLoaded(
          dashboardData: dashboardData,
          userStats: statsData,
          recentActivities: recentActivities,
          currentUser: userData,
        ),
      );
    } catch (e) {
      print('[HOME] Error refreshing dashboard: $e');
      emit(HomeError(e.toString()));
    }
  }

  /// Sync user data
  Future<void> syncData() async {
    try {
      emit(HomeSyncing());

      final response = await _homeService.syncUserData();

      if (response.isSuccess) {
        // Reload dashboard after sync
        await loadDashboard();
      } else {
        emit(HomeError(response.message ?? 'Sync failed'));
      }
    } catch (e) {
      print('[HOME] Error syncing data: $e');
      emit(HomeError(e.toString()));
    }
  }

  /// Check authentication status
  Future<bool> checkAuthStatus() async {
    try {
      return await SharedPreferencesService.isLoggedIn();
    } catch (e) {
      print('[HOME] Error checking auth status: $e');
      return false;
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      await SharedPreferencesService.logout();
      emit(HomeInitial());
    } catch (e) {
      print('[HOME] Error during logout: $e');
      emit(HomeError('Logout failed: $e'));
    }
  }

  /// Get current user info
  Map<String, dynamic>? get currentUser {
    final currentState = state;
    if (currentState is HomeLoaded) {
      return currentState.currentUser;
    }
    return null;
  }
}

/// Home States
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSyncing extends HomeState {}

class HomeLoaded extends HomeState {
  final Map<String, dynamic> dashboardData;
  final Map<String, dynamic> userStats;
  final List<Map<String, dynamic>> recentActivities;
  final Map<String, dynamic>? currentUser;

  const HomeLoaded({
    required this.dashboardData,
    required this.userStats,
    required this.recentActivities,
    this.currentUser,
  });

  @override
  List<Object?> get props => [
    dashboardData,
    userStats,
    recentActivities,
    currentUser,
  ];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}
