class ApiConfig {
  // Base URL - thay đổi URL này theo API thực tế của bạn
  static const String baseUrl = 'https://your-api-domain.com/api';
  
  // Endpoints
  static const String trainingStepEndpoint = '/training-step';
  static const String saveTrainingPlanEndpoint = '/training-plan';
  
  // Timeout settings
  static const Duration connectionTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
  
  // Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}

// Example API request/response format for documentation
/*
REQUEST FORMAT:
POST /api/training-step
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

RESPONSE FORMAT:
{
  "currentStep": "level",
  "selectedValue": ["Gain weight"],
  "selectedValues": {
    "goals": ["Lose weight", "Gain weight", "Build muscle", "Stay healthy"],
    "level": ["BEGINNER", "INTERMEDIATE", "ADVANCED"],
    "duration": ["15 - 30 phút", "30 - 45 phút", "45 - 60 phút", "Trên 60 phút"],
    "type": ["Yoga", "Calisthenic", "Gym", "Cardio"],
    "frequency": ["1 - 2 buổi / tuần", "3 - 4 buổi / tuần", "4 - 5 buổi / tuần", "5+ buổi / tuần"],
    "location": ["HOME", "GYM", "OUTSIDE", "ANYWHERE"],
    "equipment": ["No equipment", "Gym equipment", "Dumbbells", "Resistance bands", "Yoga mat"]
  }
}
*/
