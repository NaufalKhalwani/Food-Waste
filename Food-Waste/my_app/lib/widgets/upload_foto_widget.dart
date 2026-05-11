import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadFotoWidget extends StatefulWidget {
  const UploadFotoWidget({super.key});

  @override
  State<UploadFotoWidget> createState() => _UploadFotoWidgetState();
}

class _UploadFotoWidgetState extends State<UploadFotoWidget> {
  File? imageFile;

  Future<void> pickImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(
      source: source,
      imageQuality: 80,
    );

    if (picked != null) {
      setState(() {
        imageFile = File(picked.path);
      });
    }
  }

  void showImageSourceOption() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10),

              Text(
                "Pilih Sumber Foto",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),

              SizedBox(height: 10),

              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text("Kamera"),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.camera);
                },
              ),

              ListTile(
                leading: Icon(Icons.photo),
                title: Text("Galeri"),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.gallery);
                },
              ),

              SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Foto Makanan",
            style: TextTheme.of(
              context,
            ).bodyLarge!.copyWith(fontWeight: FontWeight.w700),
          ),

          SizedBox(height: 12),

          GestureDetector(
            onTap: showImageSourceOption,
            child: Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade400),
              ),

              child: imageFile == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.blue[700],
                          child: Icon(Icons.camera_alt, color: Colors.white),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Unggah Foto Makanan",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Pastikan foto terlihat jelas dan menarik (Maks. 5MB)",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  : Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(
                            imageFile!,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),

                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                imageFile = null;
                              });
                            },
                            child: CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors.black54,
                              child: Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
