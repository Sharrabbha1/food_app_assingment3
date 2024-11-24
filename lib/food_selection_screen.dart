import 'package:flutter/material.dart';
import 'database_helper.dart';

class FoodSelectionScreen extends StatefulWidget {
  const FoodSelectionScreen({super.key});

  @override
  _FoodSelectionScreenState createState() => _FoodSelectionScreenState();
}

class _FoodSelectionScreenState extends State<FoodSelectionScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  List<Map<String, dynamic>> _foodItems = [];

  @override
  void initState() {
    super.initState();
    _fetchFoodItems();
  }

  Future<void> _fetchFoodItems() async {
    final items = await _dbHelper.fetchAllFoodItems();
    setState(() {
      _foodItems = items;
    });
    print("Fetched food items: $items"); // Debug log
  }

  Future<void> _addFoodItem() async {
    final name = _nameController.text.trim();
    final cost = double.tryParse(_costController.text.trim()) ?? 0.0;

    if (name.isNotEmpty && cost > 0) {
      print("Adding Food Item: Name = $name, Cost = $cost"); // Debug log

      // Insert into database
      await _dbHelper.insertFoodItem({'name': name, 'cost': cost});

      // Clear input fields
      _nameController.clear();
      _costController.clear();

      // Refresh the list
      _fetchFoodItems();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Food item added successfully!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter valid food name and cost!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Food Items")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Food Name"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _costController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Food Cost"),
            ),
          ),
          ElevatedButton(
            onPressed: _addFoodItem,
            child: const Text("Add Food Item"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _foodItems.length,
              itemBuilder: (context, index) {
                final item = _foodItems[index];
                return ListTile(
                  title: Text(item['name']),
                  subtitle: Text("\$${item['cost']}"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
