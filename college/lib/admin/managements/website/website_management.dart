import 'package:college/admin/managements/website/notice/notice_management.dart';
import 'package:college/admin/managements/website/video/video_management.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'slider/slider_management.dart';
import 'ticker/ticker_management.dart';

class WebsiteController extends GetxController {
  var currentView = 'Notices'.obs;
  void setCurrentView(String view) {
    currentView.value = view;
  }
}

class WebsiteManagement extends StatelessWidget {
  const WebsiteManagement({super.key});

  @override
  Widget build(BuildContext context) {
    final WebsiteController websiteController = Get.put(WebsiteController());
    return Scaffold(
      appBar: AppBar(
        actions: [
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {websiteController.setCurrentView('Notices');},
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  ),
                  child: const Text('Notices'),
                ),
                ElevatedButton(
                  onPressed: () {websiteController.setCurrentView('Tickers');},
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  ),
                  child: const Text('Tickers'),
                ),
                ElevatedButton(
                  onPressed: () {websiteController.setCurrentView('Sliders');},
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  ),
                  child: const Text('Sliders'),
                ),
                ElevatedButton(
                  onPressed: () {websiteController.setCurrentView('Images');},
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  ),
                  child: const Text('Images'),
                ),
                ElevatedButton(
                  onPressed: () {websiteController.setCurrentView('Videos');},
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  ),
                  child: const Text('Videos'),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Obx(() {
        switch (websiteController.currentView.value) {
          case 'Notices':
            return NoticeManagement();
          case 'Tickers':
            return TickerManagement();
          case 'Sliders':
            return SliderManagement();
          case 'Images':
            // return ImageManagement();
          case 'Videos':
            return VideoManagement();
          default:
            return const Center(child: Text('Website Management'));
        }
      }),
    );
  }
}