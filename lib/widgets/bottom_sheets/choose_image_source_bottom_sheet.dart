import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:super_simple_accountant/analytics_events.dart';
import 'package:super_simple_accountant/colors.dart';

class ChooseImageSourceBottomSheet extends StatelessWidget {
  const ChooseImageSourceBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              const Text(
                'Select Source',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ImageSourceButton(
                    icon: Icons.photo_library,
                    label: 'Gallery',
                    onPressed: () {
                      FirebaseAnalytics.instance.logEvent(
                        name: AnalyticsEvents.imageSourceSelected,
                        parameters: {
                          AnalyticsParameters.imageSource:
                              AnalyticsParameters.imageSourceGallery,
                        },
                      );

                      Navigator.pop(context, ImageSource.gallery);
                    },
                  ),
                  ImageSourceButton(
                    icon: Icons.camera_alt,
                    label: 'Camera',
                    onPressed: () {
                      FirebaseAnalytics.instance.logEvent(
                        name: AnalyticsEvents.imageSourceSelected,
                        parameters: {
                          AnalyticsParameters.imageSource:
                              AnalyticsParameters.imageSourceCamera,
                        },
                      );

                      Navigator.pop(context, ImageSource.camera);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}

class ImageSourceButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const ImageSourceButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
    );
  }
}
