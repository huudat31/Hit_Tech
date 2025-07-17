import 'package:flutter/material.dart';
import 'package:hit_tech/services/shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isChecking = true; // Thêm biến trạng thái

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    await Future.delayed(Duration(seconds: 2));

    final isLoggedIn = await SharedPreferencesService.isLoggedIn();

    setState(() {
      _isChecking = false; // Ẩn indicator trước khi chuyển trang
    });

    // Thêm delay nhỏ để đảm bảo UI kịp cập nhật
    await Future.delayed(Duration(milliseconds: 100));

    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2454F8),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(Icons.person, size: 60, color: Color(0xFF2454F8)),
            ),
            SizedBox(height: 32),
            Text(
              'Welcome',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            if (_isChecking) // Chỉ hiển thị indicator khi đang kiểm tra
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
          ],
        ),
      ),
    );
  }
}
