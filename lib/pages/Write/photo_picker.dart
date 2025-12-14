import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerPage extends StatefulWidget {
  const ImagePickerPage({super.key, this.title = "Image Picker"});

  final String? title;

  @override
  State<ImagePickerPage> createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  List<XFile>? _mediaFileList;

  void _setImageFileListFromFile(XFile? value) {
    _mediaFileList = value == null ? null : <XFile>[value];
  }

  dynamic _pickImageError;

  String? _retrieveDataError;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();
  final TextEditingController limitController = TextEditingController();

  Future<void> _onImageButtonPressed(
    ImageSource source, {
    required BuildContext context,
    bool allowMultiple = false,
  }) async {
    if (context.mounted) {
      if (allowMultiple) {
        await _displayPickImageDialog(context, true, (
          double? maxWidth,
          double? maxHeight,
          int? quality,
          int? limit,
        ) async {
          try {
            final List<XFile> pickedFileList = await _picker.pickMultiImage(
              maxWidth: maxWidth,
              maxHeight: maxHeight,
              imageQuality: quality,
            );
            setState(() {
              _mediaFileList = pickedFileList;
            });
          } catch (e) {
            setState(() {
              _pickImageError = e;
            });
          }
        });
      } else {
        await _displayPickImageDialog(context, false, (
          double? maxWidth,
          double? maxHeight,
          int? quality,
          int? limit,
        ) async {
          try {
            final XFile? pickedFile = await _picker.pickImage(
              source: source,
              maxWidth: maxWidth,
              maxHeight: maxHeight,
              imageQuality: quality,
            );
            setState(() {
              _setImageFileListFromFile(pickedFile);
            });
          } catch (e) {
            setState(() {
              _pickImageError = e;
            });
          }
        });
      }
    }
  }

  @override
  void dispose() {
    maxWidthController.dispose();
    maxHeightController.dispose();
    qualityController.dispose();
    super.dispose();
  }

  Widget _previewImages() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_mediaFileList != null) {
      return Column(
        children: [
          SizedBox(
            height: 100,
            width: 100,
            child: kIsWeb
                ? Image.network(_mediaFileList![0].path)
                : Image.file(
                    File(_mediaFileList![0].path),
                    errorBuilder: (
                      BuildContext context,
                      Object error,
                      StackTrace? stackTrace,
                    ) {
                      return const Center(
                        child: Text('This image type is not supported'),
                      );
                    },
                  ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    _onImageButtonPressed(ImageSource.gallery,
                        context: context);
                  },
                  child: Icon(Icons.photo),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _onImageButtonPressed(ImageSource.camera, context: context);
                },
                child: const Icon(Icons.camera_alt),
              ),
            ],
          )
        ],
      );
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return Column(
        children: [
          const Text(
            'You have not yet picked an image.',
            textAlign: TextAlign.center,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    _onImageButtonPressed(ImageSource.gallery,
                        context: context);
                  },
                  child: Icon(Icons.photo),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _onImageButtonPressed(ImageSource.camera, context: context);
                },
                child: const Icon(Icons.camera_alt),
              ),
            ],
          )
        ],
      );
    }
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        if (response.files == null) {
          _setImageFileListFromFile(response.file);
        } else {
          _mediaFileList = response.files;
        }
      });
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title!)),
      body: !kIsWeb && defaultTargetPlatform == TargetPlatform.android
          ? FutureBuilder<void>(
              future: retrieveLostData(),
              builder: (
                BuildContext context,
                AsyncSnapshot<void> snapshot,
              ) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const Text(
                      'You have not yet picked an image.',
                      textAlign: TextAlign.center,
                    );
                  case ConnectionState.done:
                    return _previewImages();
                  case ConnectionState.active:
                    if (snapshot.hasError) {
                      return Text(
                        'Pick image/video error: ${snapshot.error}}',
                        textAlign: TextAlign.center,
                      );
                    } else {
                      return const Text(
                        'You have not yet picked an image.',
                        textAlign: TextAlign.center,
                      );
                    }
                }
              },
            )
          : _previewImages(),
    );
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Future<void> _displayPickImageDialog(
    BuildContext context,
    bool isMulti,
    OnPickImageCallback onPick,
  ) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add optional parameters'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: maxWidthController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  hintText: 'Enter maxWidth if desired',
                ),
              ),
              TextField(
                controller: maxHeightController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  hintText: 'Enter maxHeight if desired',
                ),
              ),
              TextField(
                controller: qualityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Enter quality if desired',
                ),
              ),
              if (isMulti)
                TextField(
                  controller: limitController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Enter limit if desired',
                  ),
                ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('PICK'),
              onPressed: () {
                final double? width = maxWidthController.text.isNotEmpty
                    ? double.parse(maxWidthController.text)
                    : null;
                final double? height = maxHeightController.text.isNotEmpty
                    ? double.parse(maxHeightController.text)
                    : null;
                final int? quality = qualityController.text.isNotEmpty
                    ? int.parse(qualityController.text)
                    : null;
                final int? limit = limitController.text.isNotEmpty
                    ? int.parse(limitController.text)
                    : null;
                onPick(width, height, quality, limit);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

typedef OnPickImageCallback = void Function(
  double? maxWidth,
  double? maxHeight,
  int? quality,
  int? limit,
);
