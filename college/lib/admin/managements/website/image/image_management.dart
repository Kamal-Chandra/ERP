import 'package:college/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'image_controller.dart';
import 'package:flutter/material.dart';
import 'package:college/utils/constants/colors.dart';

class ImageManagement extends StatelessWidget {
  final ImageController imageController = Get.put(ImageController());

  ImageManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Images', style: TextStyle(color: TColors.primary)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: IconButton(
              onPressed: () => imageController.fetchImages(),
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
                if (imageController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else if (imageController.images.isEmpty) {
                  return const Center(child: Text('No images have been published.'));
                } else {
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 1
                    ),
                    itemCount: imageController.images.length,
                    itemBuilder: (context, index) {
                      final image = imageController.images[index];
                      return Card(
                        color: Colors.transparent,
                        child: Stack(
                          children:[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(TSizes.md),
                              child: Image.network(
                                image.url,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                            Positioned(
                              top: 8.0,
                              right: 8.0,
                              child: IconButton(
                                icon: const Icon(Iconsax.trash, color: Colors.redAccent),
                                onPressed: () async {
                                  bool success = await imageController.deleteImage(image.id);
                                  if (success) {
                                    Get.snackbar('Success', 'Image deleted successfully');
                                  } else {
                                    Get.snackbar('Error', 'Failed to delete image');
                                  }
                                },
                              ),
                            ),
                          ]
                        )
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
        onPressed: () => _showAddImagePopup(context),
        backgroundColor: TColors.primary,
        child: const Icon(Iconsax.add),
      ),
    );
  }

  void _showAddImagePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final urlController = TextEditingController();

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          title: const Center(
            child: Text(
              'Add New Image',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: urlController,
                decoration: const InputDecoration(labelText: 'Image URL'),
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
                bool success = await imageController.addImage(urlController.text);
                if (success) {
                  Get.snackbar('Success', 'Image added successfully');
                } else {
                  Get.snackbar('Error', 'Failed to add image');
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