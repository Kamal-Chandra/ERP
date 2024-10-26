import 'package:get/get.dart';
import 'fee_controller.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:college/utils/constants/sizes.dart';
import 'package:college/utils/constants/colors.dart';

class FeeManagement extends StatelessWidget {
  final FeeController feeController = Get.put(FeeController());
  FeeManagement({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text('Fee Management', style: TextStyle(color: TColors.primary)), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Field
            TextField(
              onChanged: (query) => feeController.searchStudents(query),
              decoration: InputDecoration(
                labelText: 'Search Students',
                labelStyle: const TextStyle(color: Colors.white),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                suffixIcon: IconButton(
                  icon: const Icon(Iconsax.search_normal, color: Colors.white),
                  onPressed: () {},
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Statistics Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() {
                  if (feeController.isLoading.value) return const SizedBox();
                  return Wrap(
                    spacing: 16.0,
                    runSpacing: 16.0,
                    children: [
                      // Card for Total Students
                      Card(
                        elevation: 2,
                        color: TColors.primary.withOpacity(0.1),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                'Total Students',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: TColors.primary),
                              ),
                              Text(
                                '${feeController.totalCount.value}',
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Card for Students with Fees Paid
                      Card(
                        elevation: 2,
                        color: Colors.green.withOpacity(0.1),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                'Students with Fees Paid',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.green),
                              ),
                              Text(
                                '${feeController.paidCount.value}',
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Card for Students with Fees Unpaid
                      Card(
                        elevation: 2,
                        color: Colors.red.withOpacity(0.1),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                'Students with Fees Unpaid',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.red),
                              ),
                              Text(
                                '${feeController.unpaidCount.value}',
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),

            const SizedBox(height: 20),
            // Students List
            Expanded(
              child: Obx(() {
                if (feeController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (feeController.students.isEmpty) {
                  return const Center(child: Text('No students found.'));
                }
                return ListView.builder(
                  itemCount: feeController.students.length,
                  itemBuilder: (context, index) {
                    final student = feeController.students[index];
                    Color cardColor = student['status'] == 'paid' ? Colors.greenAccent : Colors.redAccent;

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      color: cardColor,
                      child: ListTile(
                        title: Text(
                          '${student['firstName']} ${student['lastName']}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.black),
                        ),
                        subtitle: Text(
                          'ID: ${student['id']}\nStatus: ${student['status'] == 'paid'? 'Paid': 'Unpaid'}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Iconsax.tick_circle, color: TColors.primary),
                          onPressed: () => _showTransactionDialog(context, student['id']),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: TColors.primary,
        child: const Icon(Iconsax.add, color: Colors.white),
        onPressed: () => _showIntroduceFeeDialog(context, feeController),
      ),
    );
  }

  void _showIntroduceFeeDialog(BuildContext context, FeeController feeController) {
    final TextEditingController feeTypeController = TextEditingController();
    final TextEditingController amountController = TextEditingController();
    final TextEditingController dueDateController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Introduce Fee'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: feeTypeController, decoration: const InputDecoration(hintText: 'Fee Type')),
              const SizedBox(height: TSizes.sm),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(hintText: 'Amount'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: TSizes.sm),
              TextField(controller: dueDateController, decoration: const InputDecoration(hintText: 'Due Date (DD-MM-YYYY)')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                if (feeTypeController.text.isNotEmpty && amountController.text.isNotEmpty && dueDateController.text.isNotEmpty) {
                    if (_isValidDateFormat(dueDateController.text)) {
                    String formattedDate = _convertDateFormat(dueDateController.text);
                    feeController.introduceFee(feeTypeController.text, double.parse(amountController.text), formattedDate);
                    Get.back();
                  } else {
                    Get.snackbar('Error', 'Please enter a valid date in DD-MM-YYYY format.');
                  }
                } else {
                  Get.snackbar('Error', 'All fields are required.');
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  bool _isValidDateFormat(String date) {
    RegExp regExp = RegExp(r'^\d{2}-\d{2}-\d{4}$');
    return regExp.hasMatch(date);
  }

  String _convertDateFormat(String date) {
    List<String> parts = date.split('-');
    if (parts.length == 3) {
      return '${parts[2]}-${parts[1]}-${parts[0]}';
    }
    return date;
  }

  void _showTransactionDialog(BuildContext context, int studentId) {
    final FeeController feeController = Get.find();
    feeController.fetchUnpaidFees(studentId);
    final TextEditingController transactionIdController = TextEditingController();
    final TextEditingController feeTypeController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Transaction Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(() {
                if (feeController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (feeController.unpaidFees.isEmpty) {
                  return const Text('No unpaid fees found.');
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Unpaid Fees', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    ... feeController.unpaidFees.asMap().entries.map((entry) {
                      int index = entry.key;
                      String feeType = entry.value;
                      return Text('${index+1}. $feeType');
                    }),
                  ],
                );
              }),
              const SizedBox(height: 16),
              TextField(
                controller: transactionIdController,
                decoration: const InputDecoration(hintText: 'Transaction ID'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: feeTypeController,
                decoration: const InputDecoration(hintText: 'Fee Type'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                if (transactionIdController.text.isNotEmpty && feeTypeController.text.isNotEmpty) {
                  feeController.updateFeeStatus(studentId, transactionIdController.text, feeTypeController.text);
                  Get.back();
                } else {
                  Get.snackbar('Error', 'Both fields are required.');
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}