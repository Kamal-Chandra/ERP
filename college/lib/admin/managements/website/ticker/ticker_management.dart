import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'ticker_controller.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:college/utils/constants/sizes.dart';
import 'package:college/utils/constants/colors.dart';

class TickerManagement extends StatelessWidget {
  final TickerController tickerController = Get.put(TickerController());
  TickerManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tickers', style: TextStyle(color: TColors.primary)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: IconButton(
              onPressed: () => tickerController.fetchTickers(),
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
                if (tickerController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else if (tickerController.tickers.isEmpty) {
                  return const Center(child: Text('No tickers have been published.'));
                } else {
                  return ListView.builder(
                    itemCount: tickerController.tickers.length,
                    itemBuilder: (context, index) {
                      final ticker = tickerController.tickers[index];
                      String formattedDate = DateFormat('dd/MM/yyyy').format(ticker.datePosted);
                      String formattedTime = DateFormat('HH:mm').format(ticker.datePosted);
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
                                  Text(ticker.message, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                                  IconButton(
                                    icon: const Icon(Iconsax.trash, color: Colors.redAccent),
                                    onPressed: () async {
                                      bool success = await tickerController.deleteTicker(ticker.tickerId);
                                      if (success) {
                                        Get.snackbar('Success', 'Ticker deleted successfully');
                                      } else {
                                        Get.snackbar('Error', 'Failed to delete ticker');
                                      }
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: TSizes.sm),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text('$formattedDate\t\t\t$formattedTime', style: const TextStyle(fontSize: 12, color: Colors.black)),
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
        onPressed: () => _showAddTickerPopup(context),
        backgroundColor: TColors.primary,
        child: const Icon(Iconsax.add),
      ),
    );
  }

  void _showAddTickerPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final messageController = TextEditingController();

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          title: const Center(
            child: Text(
              'Publish New Ticker',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: messageController,
                decoration: const InputDecoration(labelText: 'Ticker Message'),
                maxLines: 3,
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
                await tickerController.addTicker(message: messageController.text);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}