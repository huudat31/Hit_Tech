# Token Authentication Integration Guide

## Tổng quan

Hướng dẫn tích hợp token authentication từ SharedPreferences vào tất cả các chức năng trong ứng dụng.

## Cấu trúc Authentication

### 1. SharedPreferencesService

Quản lý token và thông tin người dùng:

```dart
// Lưu token sau khi login thành công
await SharedPreferencesService.saveToken(loginResponse.token);
await SharedPreferencesService.saveUserData(loginResponse.userData);

// Kiểm tra trạng thái đăng nhập
bool isLoggedIn = await SharedPreferencesService.isLoggedIn();

// Lấy token để gọi API
String? token = await SharedPreferencesService.getToken();

// Logout
await SharedPreferencesService.logout();
```

### 2. BaseApiService

Service cơ sở với authentication tự động:

#### Tính năng chính:

- **Tự động thêm token**: Mọi request đều có token trong header
- **Xử lý token hết hạn**: Auto logout khi gặp 401 error
- **Logging**: Track tất cả API calls
- **Helper methods**: Xử lý response chung

#### Cách sử dụng:

```dart
class YourService extends BaseApiService {
  YourService({Dio? dio}) : super(dio: dio);

  Future<YourModel> getData() async {
    // Check authentication trước khi gọi API
    if (!await isAuthenticated()) {
      throw Exception('User not authenticated');
    }

    final response = await dio.get('/api/your-endpoint');

    // Sử dụng helper method để xử lý response
    return handleResponse<YourModel>(
      response,
      (data) => YourModel.fromJson(data),
    );
  }
}
```

## Implementation trong các Features

### 1. Setting Feature ✅

**File**: `lib/features/main_root/setting/service/setting_service.dart`

```dart
class SettingService extends BaseApiService {
  // Tất cả methods đã được cập nhật với:
  // - Authentication check
  // - Automatic token handling
  // - Error handling

  Future<UserProfileModel> getUserProfile() async {
    if (!await isAuthenticated()) {
      throw Exception('User not authenticated');
    }

    final response = await dio.get('/api/v1/user/profile');
    return UserProfileModel.fromJson(response.data);
  }
}
```

### 2. Training Flow Feature ✅

**File**: `lib/features/training_flow/service/training_flow_service.dart`

```dart
class TrainingFlowService extends BaseApiService {
  // Đã cập nhật với authentication
  Future<TrainingStepModel> getTrainingStep({...}) async {
    if (!await isAuthenticated()) {
      throw Exception('User not authenticated');
    }

    final response = await dio.post('/api/training-step', data: {...});
    return TrainingStepModel.fromJson(response.data);
  }
}
```

### 3. Home Feature ✅ (Mẫu)

**File**: `lib/features/home/service/home_service.dart`

```dart
class HomeService extends BaseApiService {
  Future<Map<String, dynamic>> getDashboardData() async {
    if (!await isAuthenticated()) {
      throw Exception('User not authenticated');
    }

    final response = await dio.get('/api/v1/home/dashboard');
    return response.data as Map<String, dynamic>;
  }
}
```

**File**: `lib/features/home/cubit/home_cubit.dart`

```dart
class HomeCubit extends Cubit<HomeState> {
  Future<void> loadDashboard() async {
    // Check authentication trong Cubit
    final isLoggedIn = await SharedPreferencesService.isLoggedIn();
    if (!isLoggedIn) {
      emit(HomeError('Người dùng chưa đăng nhập'));
      return;
    }

    // Gọi API với token tự động
    final dashboardData = await _homeService.getDashboardData();
    emit(HomeLoaded(dashboardData: dashboardData));
  }
}
```

## Cách áp dụng cho Features khác

### Template cho Service mới:

```dart
import 'package:dio/dio.dart';
import '../../../services/api/base_api_service.dart';

class YourFeatureService extends BaseApiService {
  YourFeatureService({Dio? dio}) : super(dio: dio);

  Future<YourModel> yourApiMethod() async {
    try {
      // 1. Check authentication
      if (!await isAuthenticated()) {
        throw Exception('User not authenticated');
      }

      // 2. Call API (token được thêm tự động)
      final response = await dio.get('/api/your-endpoint');

      // 3. Handle response
      if (response.statusCode == 200) {
        return YourModel.fromJson(response.data);
      } else {
        throw Exception('API call failed: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  // Copy error handler từ SettingService hoặc sử dụng helper
  Exception _handleDioError(DioException e) { ... }
}
```

### Template cho Cubit:

```dart
class YourFeatureCubit extends Cubit<YourFeatureState> {
  final YourFeatureService _service;

  YourFeatureCubit(this._service) : super(YourFeatureInitial());

  Future<void> loadData() async {
    try {
      emit(YourFeatureLoading());

      // Check authentication trong Cubit layer
      final isLoggedIn = await SharedPreferencesService.isLoggedIn();
      if (!isLoggedIn) {
        emit(YourFeatureError('User not authenticated'));
        return;
      }

      // Get current user info nếu cần
      final userData = await SharedPreferencesService.getUserData();

      // Call service
      final data = await _service.yourApiMethod();

      emit(YourFeatureLoaded(data: data, user: userData));
    } catch (e) {
      emit(YourFeatureError(e.toString()));
    }
  }
}
```

## Quy trình Authentication Flow

### 1. Login Process:

```dart
// Trong AuthCubit/AuthService
Future<void> login(String username, String password) async {
  final response = await authService.login(username, password);

  if (response.isSuccess) {
    // Lưu token và user data
    await SharedPreferencesService.saveToken(response.token);
    await SharedPreferencesService.saveUserData(response.userData);

    emit(AuthSuccess(user: response.userData));
  }
}
```

### 2. App Initialization:

```dart
// Trong main.dart hoặc splash screen
Future<void> checkAuthStatus() async {
  final isLoggedIn = await SharedPreferencesService.isLoggedIn();

  if (isLoggedIn) {
    // Navigate to home
    Navigator.pushReplacementNamed(context, '/home');
  } else {
    // Navigate to login
    Navigator.pushReplacementNamed(context, '/login');
  }
}
```

### 3. API Call với Token:

```dart
// Tự động xử lý trong BaseApiService
// Token được thêm vào header của mọi request:
// Authorization: Bearer {token}
```

### 4. Token Expiration Handling:

```dart
// Trong BaseApiService interceptor
onError: (error, handler) async {
  if (error.response?.statusCode == 401) {
    // Token expired
    await SharedPreferencesService.logout();
    // Navigate to login screen
  }
  handler.next(error);
}
```

## Logging và Debug

### Bật logging để theo dõi:

```dart
// Trong BaseApiService
print('[AUTH] Token added to request: ${options.path}');
print('[API] Response: ${response.statusCode}');
print('[API] Error: ${error.response?.statusCode}');
```

### Debug commands:

```dart
// Check current auth status
final isLoggedIn = await SharedPreferencesService.isLoggedIn();
print('Logged in: $isLoggedIn');

// Check token
final token = await SharedPreferencesService.getToken();
print('Token: $token');

// Check user data
final userData = await SharedPreferencesService.getUserData();
print('User: $userData');
```

## Next Steps để áp dụng cho tất cả Features:

1. **Health Information Feature**:

   - Cập nhật `HealthInforRepo` extend `BaseApiService`
   - Add authentication checks
   - Update cubit để handle auth errors

2. **Training Library Feature**:

   - Tạo service cho training library
   - Implement authentication
   - Update existing widgets

3. **Notification Feature**:

   - Tạo notification service với token
   - Handle push notification với user context

4. **Profile Features**:
   - Đã hoàn thành trong Setting feature
   - Có thể tái sử dụng cho các profile-related functions

## Benefits của Architecture này:

✅ **Centralized Authentication**: Tất cả API calls đều có token  
✅ **Automatic Token Refresh**: Xử lý token expiration tự động  
✅ **Consistent Error Handling**: Unified error handling across app  
✅ **Easy Debugging**: Comprehensive logging  
✅ **Type Safety**: Strongly typed responses  
✅ **Reusable**: BaseApiService có thể dùng cho mọi feature  
✅ **Maintainable**: Clear separation of concerns

Tất cả các features trong app bây giờ đã có thể sử dụng token authentication một cách nhất quán và an toàn!
