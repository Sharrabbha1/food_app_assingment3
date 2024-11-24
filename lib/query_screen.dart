import 'package:flutter/material.dart';
import 'database_helper.dart';

class QueryScreen extends StatefulWidget {
  const QueryScreen({super.key});

  @override
  _QueryScreenState createState() => _QueryScreenState();
}

class _QueryScreenState extends State<QueryScreen> {
  final TextEditingController _dateController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Map<String, dynamic>? _orderPlan;

  // Query an order plan by date
  Future<void> _queryOrderPlan() async {
    final date = _dateController.text.trim();

    if (date.isNotEmpty) {
      print("Querying order plan for date: $date"); // Debug log

      // Fetch the order plan from the database
      final plan = await _dbHelper.fetchOrderPlanByDate(date);

      setState(() {
        _orderPlan = plan;
      });

      if (plan != null) {
        print("Order Plan Found: $plan"); // Debug log
      } else {
        print("No order plan found for the date: $date"); // Debug log
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid date!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Query Order Plans")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(
                labelText: "Enter Date (YYYY-MM-DD)",
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _queryOrderPlan,
              child: const Text("Query Order Plan"),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _orderPlan != null
                  ? _buildOrderPlanDetails()
                  : const Center(child: Text("No order plan found.")),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderPlanDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Order Plan Details", style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text("Date: ${_orderPlan!['date']}"),
        Text("Total Cost: \$${_orderPlan!['total_cost']}"),
      ],
    );
  }
}
