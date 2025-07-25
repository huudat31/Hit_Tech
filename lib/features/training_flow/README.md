# Training Flow Feature

Đây là một feature Flutter được xây dựng theo kiến trúc feature-first với Cubit pattern để quản lý luồng thiết lập chương trình tập luyện.

## Cấu trúc thư mục

```
lib/features/training_flow/
├── config/
│   └── api_config.dart           # Cấu hình API
├── cubit/
│   ├── training_flow_cubit.dart  # Business logic
│   └── training_flow_state.dart  # State definitions
├── model/
│   └── training_step_model.dart  # Data models
├── service/
│   └── training_flow_service.dart # API service với Dio
├── view/
│   ├── training_flow_page.dart   # Main page và base widgets
│   ├── goals_step_widget.dart    # Bước chọn mục tiêu
│   ├── level_step_widget.dart    # Bước chọn trình độ
│   ├── duration_step_widget.dart # Bước chọn thời gian
│   ├── type_step_widget.dart     # Bước chọn loại hình
│   ├── frequency_step_widget.dart # Bước chọน tần suất
│   ├── location_step_widget.dart # Bước chọn địa điểm
│   └── equipment_step_widget.dart # Bước chọn thiết bị
└── training_flow.dart            # Barrel export file
```

## Các tính năng chính

### 1. Quản lý trạng thái với Cubit

- `TrainingFlowCubit` quản lý toàn bộ flow
- Lưu trữ selections của user qua các bước
- Gọi API để lấy dữ liệu cho từng bước

### 2. API Integration với Dio

- Service class sử dụng Dio để call API
- Error handling đầy đủ
- Logging cho debugging
- Timeout configuration

### 3. UI Components

- Base widget cho các bước chung
- Specialized widgets cho từng bước cụ thể
- Progress indicator
- Loading states
- Error handling

## Cách sử dụng

### 1. Cấu hình API

Cập nhật `ApiConfig` với URL thực tế của API:

```dart
// lib/features/training_flow/config/api_config.dart
class ApiConfig {
  static const String baseUrl = 'https://your-actual-api.com/api';
  // ...
}
```

### 2. Navigation

```dart
import 'package:your_app/features/training_flow/training_flow.dart';

// Navigate to training flow
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const TrainingFlowPage(),
  ),
);
```

### 3. Sử dụng độc lập

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_app/features/training_flow/training_flow.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TrainingFlowCubit(
        trainingFlowService: TrainingFlowService(),
      ),
      child: TrainingFlowPage(),
    );
  }
}
```

## API Format

### Request Format

```json
{
  "currentStep": "goals",
  "selectedValue": ["Gain weight"],
  "selectedValues": {
    "goals": ["Gain weight"],
    "level": ["BEGINNER"],
    "duration": ["30 phút"],
    "type": ["Gym"],
    "frequency": ["4 - 5 buổi / tuần"],
    "location": ["HOME", "GYM"],
    "equipment": ["Gym equipment"]
  }
}
```

### Response Format

```json
{
  "currentStep": "level",
  "selectedValue": ["Gain weight"],
  "selectedValues": {
    "goals": ["Lose weight", "Gain weight", "Build muscle", "Stay healthy"],
    "level": ["BEGINNER", "INTERMEDIATE", "ADVANCED"],
    "duration": [
      "15 - 30 phút",
      "30 - 45 phút",
      "45 - 60 phút",
      "Trên 60 phút"
    ],
    "type": ["Yoga", "Calisthenic", "Gym", "Cardio"],
    "frequency": [
      "1 - 2 buổi / tuần",
      "3 - 4 buổi / tuần",
      "4 - 5 buổi / tuần",
      "5+ buổi / tuần"
    ],
    "location": ["HOME", "GYM", "OUTSIDE", "ANYWHERE"],
    "equipment": [
      "No equipment",
      "Gym equipment",
      "Dumbbells",
      "Resistance bands",
      "Yoga mat"
    ]
  }
}
```

## Luồng hoạt động

1. **Khởi tạo**: `initializeTrainingFlow()` - Gọi API với step đầu tiên
2. **Chọn giá trị**: User chọn options, lưu vào temporary state
3. **Tiếp tục**: `selectAndProceed()` - Lưu selection và gọi API cho bước tiếp theo
4. **Lặp lại**: Cho đến khi hoàn thành tất cả các bước
5. **Hoàn thành**: Lưu toàn bộ cấu hình training

## Dependencies

```yaml
dependencies:
  flutter_bloc: ^9.1.1
  dio: ^5.8.0+1
  equatable: ^2.0.5
  flutter_screenutil: ^5.9.3
```

## Customization

### Thêm bước mới

1. Tạo widget mới extend từ `BaseStepWidget`
2. Cập nhật `_buildStepContent()` trong `TrainingFlowView`
3. Cập nhật progress calculation trong `_getProgressValue()`

### Thay đổi UI

- Customize colors trong từng step widget
- Thay đổi layout trong `BaseStepWidget`
- Update assets paths theo project

### Error Handling

- Customize error messages trong service
- Thay đổi error UI trong `_buildErrorWidget()`

## Testing

Bạn có thể test từng component:

- Unit test cho Cubit
- Widget test cho UI components
- Integration test cho API calls

## Notes

- Tất cả selections được lưu trong memory (Map)
- API được gọi mỗi khi chuyển bước
- Images assets cần được thêm vào `pubspec.yaml`
- Support cả single và multiple selection
- Responsive design với ScreenUtil
