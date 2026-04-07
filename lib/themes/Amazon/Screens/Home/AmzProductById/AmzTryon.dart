import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class VirtualTryOnDialog extends StatefulWidget {
  final String dressImage;

  const VirtualTryOnDialog({super.key, required this.dressImage});

  @override
  State<VirtualTryOnDialog> createState() => _VirtualTryOnDialogState();
}

class _VirtualTryOnDialogState extends State<VirtualTryOnDialog> {
  final ImagePicker _picker = ImagePicker();

  File? userImage;
  Offset dressOffset = const Offset(100, 200);
  double dressScale = 1.0;
  double dressRotation = 0.0;

  Future<void> pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source, imageQuality: 85);
    if (picked != null) {
      setState(() {
        userImage = File(picked.path);
        dressOffset = const Offset(100, 200);
        dressScale = 1.0;
        dressRotation = 0;
      });
    }
  }

  void showPickerSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text("Take Photo"),
            onTap: () {
              Navigator.pop(context);
              pickImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text("Choose from Gallery"),
            onTap: () {
              Navigator.pop(context);
              pickImage(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Virtual Try-On"),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                // USER IMAGE
                Positioned.fill(
                  child: userImage != null
                      ? Image.file(userImage!, fit: BoxFit.cover)
                      : const Center(
                          child: Text(
                            "Upload your photo",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                ),

                // DRESS OVERLAY
                if (userImage != null)
                  Positioned(
                    left: dressOffset.dx,
                    top: dressOffset.dy,
                    child: GestureDetector(
  onScaleUpdate: (details) {
    setState(() {
      // MOVE (PAN)
      dressOffset += details.focalPointDelta;

      // SCALE
      dressScale = (dressScale * details.scale).clamp(0.5, 2.5);

      // ROTATE
      dressRotation += details.rotation;
    });
  },
  child: Transform.rotate(
    angle: dressRotation,
    child: Transform.scale(
      scale: dressScale,
      child: Image.network(
        widget.dressImage,
        width: 180,
        fit: BoxFit.contain,
      ),
    ),
  ),
),

                  ),
              ],
            ),
          ),

          // CONTROLS
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  color: Colors.white,
                  icon: const Icon(Icons.photo_camera),
                  onPressed: showPickerSheet,
                ),
                IconButton(
                  color: Colors.white,
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    setState(() {
                      dressOffset = const Offset(100, 200);
                      dressScale = 1.0;
                      dressRotation = 0;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
