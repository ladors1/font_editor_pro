// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:font_editor_pro/screens/editor_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.palette, size: 120, color: Colors.deepPurpleAccent),
            const SizedBox(height: 20),
            const Text(
              'ویرایشگر فونت حرفه‌ای',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            const Text(
              'متن‌های خارق‌العاده برای استوری‌های خود بسازید',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 50),
            ElevatedButton.icon(
              icon: const Icon(Icons.add_circle, size: 28),
              label: const Text('شروع طراحی جدید', style: TextStyle(fontSize: 20)),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.deepPurpleAccent,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditorScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}