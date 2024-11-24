import 'package:flutter/material.dart';
import 'food_selection_screen.dart';
import 'query_screen.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key}); // No const here to avoid any conflict

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Food Ordering App"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FoodSelectionScreen(), // Removed 'const'
                  ),
                );
              },
              child: const Text("Manage Food Items"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QueryScreen(), // Removed 'const'
                  ),
                );
              },
              child: const Text("Query Order Plans"),
            ),
          ],
        ),
      ),
    );
  }
}
