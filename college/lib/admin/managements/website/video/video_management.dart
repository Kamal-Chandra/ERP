import 'package:college/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'video_controller.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:college/utils/constants/colors.dart';

class VideoManagement extends StatelessWidget {
  final VideoController videoController = Get.put(VideoController());

  VideoManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Videos', style: TextStyle(color: TColors.primary)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: IconButton(
              onPressed: () => videoController.fetchVideos(),
              icon: const Icon(Iconsax.refresh, color: Colors.white),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16.0),
            Expanded(
              child: Obx(() {
                if (videoController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else if (videoController.videos.isEmpty) {
                  return const Center(child: Text('No videos have been published.'));
                } else {
                  return ListView.builder(
                    itemCount: videoController.videos.length,
                    itemBuilder: (context, index) {
                      final video = videoController.videos[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        color: const Color(0xFFADD8E6).withOpacity(0.7),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    video.title,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Iconsax.trash, color: Colors.redAccent),
                                    onPressed: () async {
                                      bool success = await videoController.deleteVideo(video.id);
                                      if (success) {
                                        Get.snackbar('Success', 'Video deleted successfully');
                                      } else {
                                        Get.snackbar('Error', 'Failed to delete video');
                                      }
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: TSizes.sm),
                              if (video.url.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: GestureDetector(
                                    onTap: () async {
                                      final String url = video.url.startsWith('http://') || video.url.startsWith('https://')
                                        ? video.url
                                        : 'https://${video.url}';
                                      if (await canLaunchUrlString(url)) {
                                        await launchUrlString(url);
                                      } else {
                                        Get.snackbar('Error', 'Could not launch URL');
                                      }
                                    },
                                    child: const Text(
                                      'Watch Video',
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
                                    ),
                                  ),
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
        onPressed: () => _showAddVideoPopup(context),
        backgroundColor: TColors.primary,
        child: const Icon(Iconsax.add),
      ),
    );
  }

  void _showAddVideoPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final titleController = TextEditingController();
        final urlController = TextEditingController();

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          title: const Center(
            child: Text(
              'Publish New Video',
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
                      controller: urlController,
                      decoration: const InputDecoration(labelText: 'Video URL'),
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
                Get.back();
                bool success = await videoController.addVideo(
                  title: titleController.text,
                  url: urlController.text,
                );
                if (success) {
                  Get.snackbar('Success', 'Video added successfully');
                } else {
                  Get.snackbar('Error', 'Failed to add video');
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