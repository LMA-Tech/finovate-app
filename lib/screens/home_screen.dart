import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/session_manager.dart';

part 'home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  createState() => _HomeScreen();
}

class _HomeScreen extends HomeController {
  @override
  Widget build(BuildContext context) {
    final sessionManager = Get.find<SessionManager>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () async {
              // Show confirmation dialog
              final shouldLogout = await Get.dialog<bool>(
                AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(result: false),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () => Get.back(result: true),
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );

              if (shouldLogout == true) {
                await sessionManager.signOut();
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Obx(() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.home, size: 100, color: Colors.blue),
            const SizedBox(height: 20),
            const Text(
              'Welcome to Finovate!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'User: ${sessionManager.currentUser.value?.email ?? "Unknown"}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                await sessionManager.signOut();
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
            ),
          ],
        ),
      )),
    );
  }
}