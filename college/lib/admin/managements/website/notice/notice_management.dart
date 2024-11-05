import 'package:college/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'notice_controller.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:college/utils/constants/colors.dart';

class NoticeManagement extends StatelessWidget {
  final NoticeController websiteController = Get.put(NoticeController());
  NoticeManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notices', style: TextStyle(color: TColors.primary)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: IconButton(onPressed: ()=>websiteController.fetchNotices(), icon: const Icon(Iconsax.refresh, color: Colors.white)),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16.0),
            Expanded(
              child: Obx(() {
                if (websiteController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else if (websiteController.notices.isEmpty) {
                  return const Center(child: Text('No notices have been published.'));
                } else {
                  return ListView.builder(
                    itemCount: websiteController.notices.length,
                    itemBuilder: (context, index) {
                      final notice = websiteController.notices[index];
                      String formattedDate = DateFormat('dd/MM/yyyy').format(notice.date);
                      String formattedTime = DateFormat('HH:mm').format(notice.date);
                      Color cardColor = _getColorByPriority(notice.priority);
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        color: cardColor.withOpacity(0.7),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(notice.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                                  IconButton(
                                    icon: const Icon(Iconsax.trash, color: Colors.redAccent),
                                    onPressed: () async {
                                      bool success = await websiteController.deleteNotice(notice.noticeId);
                                      if (success) {
                                        Get.snackbar('Success', 'Notice deleted successfully');
                                      } else {
                                        Get.snackbar('Error', 'Failed to delete notice');
                                      }
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: TSizes.sm),
                              Text(notice.noticeText, style: const TextStyle(fontSize: 14, color: Colors.black)),
                              const SizedBox(height: TSizes.sm),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  if (notice.attachments.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: GestureDetector(
                                        onTap: () => launchUrlString(notice.attachments),
                                        child: const Text('View Attachment', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black)),
                                      ),
                                    ),
                                  if (notice.attachments.isEmpty)
                                    const SizedBox(width: TSizes.sm),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(notice.noticeType, style: const TextStyle(fontSize: 12, color: Colors.black)),
                                      const SizedBox(width: 8.0),
                                      Text('$formattedDate $formattedTime', style: const TextStyle(fontSize: 12, color: Colors.black)),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              }),
            ),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddNoticePopup(context),
        backgroundColor: TColors.primary,
        child: const Icon(Iconsax.add),
      ),
    );
  }
  Color _getColorByPriority(String priority) {
    switch (priority) {
      case 'High':
        return Colors.lightBlueAccent.withOpacity(0.2);
      default:
        return const Color(0xFFADD8E6);
    }
  }
  void _showAddNoticePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final titleController = TextEditingController();
        final textController = TextEditingController();
        final attachmentController = TextEditingController();
        String selectedType = 'General';
        String selectedPriority = 'Medium';

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          title: const Center(
            child: Text(
              'Publish New Notice',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
                    const SizedBox(height: 12.0),
                    TextField(
                      controller: textController,
                      decoration: const InputDecoration(labelText: 'Notice Text'),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 12.0),
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      items: const [
                        DropdownMenuItem(value: 'Event', child: Text('Event')),
                        DropdownMenuItem(value: 'Exam', child: Text('Exam')),
                        DropdownMenuItem(value: 'General', child: Text('General')),
                        DropdownMenuItem(value: 'Fee', child: Text('Fee')),
                      ],
                      onChanged: (value) {
                        selectedType = value!;
                      },
                      decoration: const InputDecoration(labelText: 'Notice Type'),
                    ),
                    const SizedBox(height: 12.0),
                    DropdownButtonFormField<String>(
                      value: selectedPriority,
                      items: const [
                        DropdownMenuItem(value: 'High', child: Text('High')),
                        DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                      ],
                      onChanged: (value) {
                        selectedPriority = value!;
                      },
                      decoration: const InputDecoration(labelText: 'Priority'),
                    ),
                    const SizedBox(height: 12.0),
                    TextField(
                      controller: attachmentController,
                      decoration: const InputDecoration(labelText: 'Attachment URL (optional)'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                websiteController.addNotice(
                  title: titleController.text,
                  noticeText: textController.text,
                  type: selectedType,
                  priority: selectedPriority,
                  attachmentUrl: attachmentController.text,
                );
                Get.back();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}