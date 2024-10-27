import 'package:get/get.dart';
import 'hostel_controller.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:college/utils/constants/colors.dart';
import 'package:college/utils/constants/sizes.dart';

class HostelManagement extends StatelessWidget {
  final HostelController hostelController = Get.put(HostelController());
  HostelManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hostel Management', style: TextStyle(color: TColors.primary)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Field
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (query) => hostelController.searchStudents(query),
                    decoration: InputDecoration(
                      labelText: 'Search',
                      labelStyle: const TextStyle(color: Colors.white),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                      suffixIcon: IconButton(
                        icon: const Icon(Iconsax.search_normal, color: Colors.white),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: TSizes.md),
                IconButton(
                  icon: const Icon(Iconsax.refresh, color: Colors.white),
                  onPressed: () {
                    hostelController.fetchStudents();
                    hostelController.fetchHostelStatistics();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Statistics Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() {
                  if (hostelController.isLoading.value) return const SizedBox();
                  return Wrap(
                    spacing: 16.0,
                    runSpacing: 16.0,
                    children: [
                      _buildStatisticCard(context, 'Total Students', hostelController.totalCount.value, TColors.primary),
                      _buildStatisticCard(context, 'Hostellers', hostelController.hostellersCount.value, Colors.lightBlueAccent),
                      _buildStatisticCard(context, 'Day Scholars', hostelController.dayScholarsCount.value, Colors.yellowAccent),
                    ],
                  );
                }),
              ],
            ),
            const SizedBox(height: 20),

            // Students List
            Expanded(
              child: Obx(() {
                if (hostelController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (hostelController.students.isEmpty) {
                  return const Center(child: Text('No students found.'));
                }
                return ListView.builder(
                  itemCount: hostelController.students.length,
                  itemBuilder: (context, index) {
                    final student = hostelController.students[index];
                    Color cardColor = student['allocation_status'] == 'allocated'
                        ? Colors.lightBlueAccent
                        : Colors.yellowAccent;

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      color: cardColor,
                      child: ListTile(
                        title: Text(
                          '${student['firstName']} ${student['lastName']}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.black),
                        ),
                        subtitle: Text(
                          'ID: ${student['id']}\nRoom: ${student['room_number'] ?? 'Not Allocated'}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Iconsax.add, color: TColors.primary),
                          onPressed: () => _showAllocateRoomDialog(context, student['id']),
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
    );
  }

  Widget _buildStatisticCard(BuildContext context, String title, int count, Color color) {
    return Card(
      elevation: 2,
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: color),
            ),
            Text(
              '$count',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }

  void _showAllocateRoomDialog(BuildContext context, int studentId) {
    final TextEditingController roomNumberController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Allocate Room'),
          content: TextField(
            controller: roomNumberController,
            decoration: const InputDecoration(hintText: 'Room Number'),
          ),
          actions: [
            TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                if (roomNumberController.text.isNotEmpty) {
                  hostelController.allocateRoom(studentId, roomNumberController.text);
                  Get.back();
                } else {
                  Get.snackbar('Error', 'Room number is required.');
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