/*

AUTH GATE - This will constinuously listen for auth state changes.
-----------------------------
unaunthenticated -> login screen
authenticated -> home screen

*/

import 'package:finovate_app/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../screens/home_screen.dart';
import '../utils/constants/colors.dart';
import '../utils/helpers/helper_functions.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = FinHelperFunctions.isDarkMode(context);
    // Define colors for the loading indicator
    final indicatorColor = dark ? FinColors.white : FinColors.primary;

    return StreamBuilder(
      // Listen to auth state changes
      stream: Supabase.instance.client.auth.onAuthStateChange,

      //Build appropriate page based on auth state
      builder: (context, snapshot) {
        //loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: LoadingIndicator(
                indicatorType: Indicator.ballClipRotatePulse,
                // Using ballClipRotatePulse animation
                colors: [indicatorColor],
                strokeWidth: 3,
              ),
            ),
          );
        }

        // Check if there is a valid session
        final session = snapshot.hasData ? snapshot.data!.session : null;

        if (session != null) {
          return const HomeScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
