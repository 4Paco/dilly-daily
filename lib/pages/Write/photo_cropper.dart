import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

class CropperBody extends StatelessWidget {
  final CroppedFile? croppedFile;
  final VoidCallback onUploadFromGallery;
  final VoidCallback onUploadFromCamera;

  const CropperBody({
    super.key,
    required this.croppedFile,
    required this.onUploadFromGallery,
    required this.onUploadFromCamera,
  });

  @override
  Widget build(BuildContext context) {
    if (croppedFile != null) {
      return _uploaderCard(context);
    } else {
      return _uploaderCard(context);
    }
  }

  Widget _uploaderCard(BuildContext context) {
    ColorScheme themeScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: SizedBox(
        width: kIsWeb ? 380.0 : 160.0,
        height: kIsWeb ? 300.0 : 270,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: croppedFile == null
                    ? Center(
                        child: Icon(
                          Icons.image,
                          color: Theme.of(context).disabledColor,
                          size: 40.0,
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          height: 800,
                          child: FittedBox(
                            fit: BoxFit.fill,
                            clipBehavior: Clip.hardEdge,
                            child: kIsWeb
                                ? Image.network(croppedFile!.path)
                                : Image.file(File(croppedFile!.path)),
                          ),
                        ),
                      ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                  child: ElevatedButton(
                    onPressed: onUploadFromGallery,
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(themeScheme.primary),
                      foregroundColor:
                          MaterialStateProperty.all(themeScheme.onPrimary),
                    ),
                    child: const Icon(Icons.photo),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                  child: ElevatedButton(
                    onPressed: onUploadFromCamera,
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(themeScheme.primary),
                      foregroundColor:
                          MaterialStateProperty.all(themeScheme.onPrimary),
                    ),
                    child: const Icon(Icons.camera_alt),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (2, 3);

  @override
  String get name => 'Change Orientation';
}
