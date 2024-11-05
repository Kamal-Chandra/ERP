import 'package:college/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'slider_controller.dart';
import 'package:flutter/material.dart';
import 'package:college/utils/constants/colors.dart';

class SliderManagement extends StatelessWidget {
  final SliderController sliderController = Get.put(SliderController());

  SliderManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sliders', style: TextStyle(color: TColors.primary)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: IconButton(
              onPressed: () => sliderController.fetchSliders(),
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
                if (sliderController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else if (sliderController.sliders.isEmpty) {
                  return const Center(child: Text('No sliders have been published.'));
                } else {
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 1,
                    ),
                    itemCount: sliderController.sliders.length,
                    itemBuilder: (context, index) {
                      final slider = sliderController.sliders[index];
                      return Card(
                        color: Colors.transparent,
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(TSizes.md),
                                  child: Image.network(
                                    slider.url,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 350,
                                  ),
                                ),
                                Positioned(
                                  top: 8.0,
                                  right: 8.0,
                                  child: IconButton(
                                    icon: const Icon(Iconsax.trash, color: Colors.redAccent),
                                    onPressed: () async {
                                      bool success = await sliderController.deleteSlider(slider.id);
                                      if (success) {
                                        Get.snackbar('Success', 'Slider deleted successfully');
                                      } else {
                                        Get.snackbar('Error', 'Failed to delete slider');
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: TSizes.sm),
                            Text(slider.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                          ],
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
        onPressed: () => _showAddSliderPopup(context),
        backgroundColor: TColors.primary,
        child: const Icon(Iconsax.add),
      ),
    );
  }

  void _showAddSliderPopup(BuildContext context) {
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
              'Add New Slider',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Slider Title'),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: urlController,
                    decoration: const InputDecoration(labelText: 'Image URL'),
                  ),
                ],
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
                bool success = await sliderController.addSlider(titleController.text, urlController.text);
                if (success) {
                  Get.snackbar('Success', 'Slider added successfully');
                } else {
                  Get.snackbar('Error', 'Failed to add slider');
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
