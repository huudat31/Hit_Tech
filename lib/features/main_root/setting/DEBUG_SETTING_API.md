# Debug Guide: Setting API Token Issue

## 🎯 Vấn đề hiện tại

Setting feature không fetch được data từ API `/api/v1/user/profile` vì authentication token.

## 🔧 Các bước đã fix

### 1. ✅ Fix BlocProvider Conflict

**Vấn đề**: Có 2 BlocProvider cho SettingCubit

- `main.dart`: `SettingService(dio: Dio())` ✅
- `setting_page.dart`: `SettingService()` ❌ (thiếu Dio)

**Fix**: Sử dụng existing BlocProvider từ main.dart

### 2. ✅ Fix Base URL

**Vấn đề**: Base URL không đúng

- Cũ: `http://localhost:8080` ❌
- Mới: `http://localhost:8000` ✅ (match với API server)

### 3. ✅ Add Debug Logging

Thêm comprehensive logging để track:

- Token availability
- Authentication status
- API request/response
- Error details

## 🧪 Test Steps

### Step 1: Kiểm tra Token

Mở app và check console logs:

```
[DEBUG] ========== TOKEN INFO ==========
[DEBUG] Is logged in: true/false
[DEBUG] Has token: true/false
[DEBUG] Token preview: Bearer eyJ...
[DEBUG] User data: {...}
```

### Step 2: Test API Connection

```
[DEBUG] Testing API connection...
[DEBUG] Has token: true
[DEBUG] API Response Status: 200
[DEBUG] API Response Data: {...}
```

### Step 3: Check Setting Load

```
[SettingCubit] Starting to load user profile...
[SettingCubit] Is authenticated: true
[SettingCubit] User profile loaded successfully: {...}
```

## 🚨 Possible Issues & Solutions

### Issue 1: "User not authenticated"

**Nguyên nhân**: Không có token hoặc token invalid
**Solutions**:

1. Đảm bảo user đã login thành công
2. Check AuthBloc state có AuthSuccess không
3. Verify token được save vào SharedPreferences

### Issue 2: "Network Error"

**Nguyên nhân**: API server không chạy hoặc base URL sai
**Solutions**:

1. Đảm bảo API server chạy trên `http://localhost:8000`
2. Test API trực tiếp bằng Postman/curl
3. Check firewall/network restrictions

### Issue 3: "401 Unauthorized"

**Nguyên nhân**: Token bị expire hoặc invalid format
**Solutions**:

1. Re-login để get new token
2. Check token format (JWT: 3 parts separated by dots)
3. Verify server token validation logic

### Issue 4: "Failed to load profile"

**Nguyên nhân**: API response format không đúng
**Solutions**:

1. Check API response structure match với UserProfileModel
2. Verify JSON parsing
3. Check server logs for errors

## 🎯 Quick Debug Commands

Để test nhanh, thêm button debug vào Setting UI:

```dart
ElevatedButton(
  onPressed: () async {
    await DebugApiHelper.testApiConnection();
    context.read<SettingCubit>().loadUserProfile();
  },
  child: Text('Debug API'),
)
```

## 📋 Checklist

- [x] Fix BlocProvider conflict
- [x] Update base URL to localhost:8000
- [x] Add comprehensive debug logging
- [x] Add authentication check before API calls
- [x] Create debug helper methods
- [ ] **TODO**: Run app and check console logs
- [ ] **TODO**: Ensure user is logged in first
- [ ] **TODO**: Verify API server is running
- [ ] **TODO**: Test setting page displays data

## 🚀 Next Steps

1. **Run the app** và check console logs
2. **Login first** nếu chưa có token
3. **Navigate to Setting page** và observe logs
4. **Report specific error messages** nếu vẫn không work

**Console logs sẽ cho biết chính xác vấn đề ở đâu!** 🔍
