import 'package:flutter/material.dart';

// IMPORT PROVIDERS
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

// IMPORT SCREENS
import 'login_screen.dart';
import 'homepage/navigation_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _future();
  }

  Future<void> _future() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.loadFromPrefs();

    await Future.delayed(const Duration(seconds: 2));

    if (userProvider.getUser != null) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const NavigationScreen()),
        );
      }
    } else {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'My Watch List',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(height: 48),
            CircularProgressIndicator.adaptive(),
          ],
        ),
      ),
    );
  }
}
