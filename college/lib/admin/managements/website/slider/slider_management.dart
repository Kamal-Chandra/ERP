import 'dart:typed_data';
import 'package:get/get.dart';
import 'slider_controller.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:college/utils/constants/sizes.dart';
import 'package:college/utils/constants/colors.dart';

class SliderManagement extends StatelessWidget {
  SliderManagement({super.key});
  final SliderController controller = Get.put(SliderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sliders', style: TextStyle(color: TColors.primary)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: IconButton(onPressed: () {}, icon: const Icon(Iconsax.refresh, color: Colors.white)),
          )
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.sliders.isEmpty) {
          return const Center(child: Text('No sliders available.'));
        } else {
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.0,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: controller.sliders.length,
            itemBuilder: (context, index) {
              final slider = controller.sliders[index];
              return GestureDetector(
                onTap: () {},
                child: Card(
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.memory(
                          slider.imageData,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          slider.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddSliderDialog(context);
        },
        backgroundColor: TColors.primary,
        child: const Icon(Iconsax.add),
      ),
    );
  }

  void _showAddSliderDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    Uint8List? imageData;

    Future<void> pickImage() async {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        imageData = await pickedFile.readAsBytes();
        (context as Element).markNeedsBuild();
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Slider Image'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: TSizes.sm),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: pickImage,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Select Image'),
                ),
              ),
              const SizedBox(height: TSizes.sm),
              if (imageData != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Image.memory(imageData!, height: 100, fit: BoxFit.cover),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
                  Get.snackbar('Error', 'Title and description cannot be empty');
                  return;
                }
                if (imageData != null) {
                  controller
                      .addSlider(
                        title: titleController.text,
                        description: descriptionController.text,
                        imageData: imageData!,
                      )
                      .then((success) {
                    if (success) {
                      Get.back();
                    }
                  });
                } else {
                  Get.snackbar('Error', 'Please select an image.');
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}