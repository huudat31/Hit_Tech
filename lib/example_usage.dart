import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'features/training_flow/training_flow.dart';

class ExampleUsage extends StatelessWidget {
  const ExampleUsage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Training Flow Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: 'Roboto',
          ),
          home: const TrainingFlowPage(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

// Example of how to navigate to training flow from another screen
class NavigateToTrainingFlowExample extends StatelessWidget {
  const NavigateToTrainingFlowExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TrainingFlowPage(),
              ),
            );
          },
          child: const Text('Bắt đầu thiết lập tập luyện'),
        ),
      ),
    );
  }
}
