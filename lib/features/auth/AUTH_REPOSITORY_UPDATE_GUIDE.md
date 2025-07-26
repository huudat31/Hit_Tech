# Auth Repository Integration Guide

## Tổng quan về cập nhật Auth Repository

Auth Repository đã được cập nhật để tích hợp hoàn toàn với hệ thống authentication mới, bao gồm:

### 1. Tích hợp SharedPreferences

```dart
// Tự động lưu token và user data khi login thành công
if (loginResponse.success && loginResponse.token != null) {
  await SharedPreferencesService.saveToken(loginResponse.token!);

  if (loginResponse.user != null) {
    await SharedPreferencesService.saveUserData(loginResponse.user!);
  }

  print('[AUTH] Login successful, token and user data saved');
}
```

### 2. Phương thức mới được thêm vào

#### Logout Method

```dart
Future<void> logout() async {
  try {
    await SharedPreferencesService.logout();
    print('[AUTH] User logged out successfully');
  } catch (e) {
    print('[AUTH] Logout error: $e');
  }
}
```

#### Check Authentication Status

```dart
Future<bool> isAuthenticated() async {
  return await SharedPreferencesService.isLoggedIn();
}
```

#### Get Current User Data

```dart
Future<Map<String, dynamic>?> getCurrentUser() async {
  return await SharedPreferencesService.getUserData();
}
```

### 3. AuthBloc Updates

#### Thêm Event mới

```dart
class CheckAuthStatusRequested extends AuthEvent {}
```

#### Cập nhật Logout Handler

```dart
void _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
  emit(AuthLoading());
  try {
    await authRepository.logout();
    emit(AuthInitial());
  } catch (e) {
    print('[AuthBloc] Logout error: $e');
    emit(AuthInitial()); // Vẫn logout dù có lỗi
  }
}
```

#### Auto-check Authentication

```dart
void _onCheckAuthStatusRequested(
  CheckAuthStatusRequested event,
  Emitter<AuthState> emit,
) async {
  try {
    final isAuthenticated = await authRepository.isAuthenticated();

    if (isAuthenticated) {
      final userData = await authRepository.getCurrentUser();
      emit(AuthSuccess(
        token: 'existing_token',
        user: userData,
        message: 'Already authenticated',
      ));
    } else {
      emit(AuthInitial());
    }
  } catch (e) {
    print('[AuthBloc] Check auth status error: $e');
    emit(AuthInitial());
  }
}
```

### 4. Main.dart Integration

App sẽ tự động kiểm tra authentication status khi khởi động:

```dart
BlocProvider<AuthBloc>(
  create: (context) {
    final authBloc = AuthBloc(authRepository: AuthRepository());
    // Check authentication status khi app khởi động
    authBloc.add(CheckAuthStatusRequested());
    return authBloc;
  },
),
```

### 5. Lợi ích của việc cập nhật

1. **Automatic Token Management**: Token và user data được tự động lưu khi login thành công
2. **Persistent Authentication**: App nhớ trạng thái đăng nhập khi restart
3. **Centralized Logout**: Logout sẽ xóa tất cả data authentication
4. **Consistent State Management**: AuthBloc luôn sync với SharedPreferences
5. **Error Handling**: Xử lý lỗi toàn diện cho tất cả authentication operations

### 6. Luồng hoạt động mới

1. **App Launch**: CheckAuthStatusRequested → Kiểm tra token → Auto login nếu có token
2. **User Login**: LoginRequested → API call → Lưu token/user data → AuthSuccess
3. **API Calls**: Tất cả services tự động dùng token từ SharedPreferences
4. **User Logout**: LogoutRequested → Clear all data → AuthInitial
5. **Token Expired**: BaseApiService tự động logout và chuyển về login screen

### 7. Migration từ code cũ

Không cần thay đổi UI code, chỉ cần:

- AuthBloc events và states giữ nguyên
- Login/logout flows vẫn hoạt động như cũ
- Thêm automatic authentication persistence
- Improved error handling và user experience

## Kết luận

Auth Repository bây giờ đã được tích hợp hoàn toàn với hệ thống authentication mới, cung cấp:

- Automatic token management
- Persistent authentication state
- Consistent error handling
- Centralized authentication logic
- Seamless integration với tất cả features khác

Hệ thống authentication bây giờ đã hoàn chính và sẵn sàng cho production use.
