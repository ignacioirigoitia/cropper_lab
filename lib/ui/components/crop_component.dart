

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';


class CropComponent extends StatefulWidget {
  const CropComponent({ Key? key }) : super(key: key);

  @override
  State<CropComponent> createState() => _CropComponentState();
}

enum PageDisplayStyle {
  desktop,
  mobile,
}

class _CropComponentState extends State<CropComponent> {

  String? _uploadedBlobUrl;
  String? _croppedBlobUrl;

  double height = 300;
  double width = 300;

  @override
  Widget build(BuildContext context) {
    if (_croppedBlobUrl != null || _uploadedBlobUrl != null) {
      return _imageCard();
    } else {
      return _uploaderCard();
    }
  }

  Widget _imageCard() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 1.0), //(x,y)
                blurRadius: 6.0,
              ),
            ],
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 300,
                child: Card(
                  elevation: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: _image(),
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              _menu(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _image() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    if (_croppedBlobUrl != null) {
      return ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 0.8 * screenWidth,
            maxHeight: 0.7 * screenHeight,
          ),
          child: Image.network(_croppedBlobUrl!));
    } else if (_uploadedBlobUrl != null) {
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 0.8 * screenWidth,
          maxHeight: 0.7 * screenHeight,
        ),
        child: Image.network(_uploadedBlobUrl!),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _menu() {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              onPressed: () {
                width = 300;
                height = 300;
                setState(() {});
                _cropImage();
              },
              backgroundColor: Colors.grey.shade500,
              tooltip: 'Square',
              child: const Icon(Icons.square_outlined),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: FloatingActionButton(
                onPressed: () {
                  height = 300;
                  width = 450;
                  setState(() {});
                  _cropImage();
                },
                backgroundColor: Colors.grey.shade500,
                tooltip: 'Rectangle 3x2',
                child: const Icon(Icons.rectangle_outlined),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              onPressed: () {
                _clear();
              },
              backgroundColor: Colors.redAccent,
              tooltip: 'Delete',
              child: const Icon(Icons.delete),
            ),
          ],
        ),
      ],
    );
  }

  Widget _uploaderCard() {
    return Center(
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: SizedBox(
          width: 380.0,
          height: 300.0,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image,
                      color: Theme.of(context).highlightColor,
                      size: 80.0,
                    ),
                    const SizedBox(height: 24.0),
                    Text(
                      'Upload an image to start',
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                            color: Theme.of(context).highlightColor,
                          ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  _uploadImage();
                },
                child: const Text('Upload'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _cropImage() async {
    if (_uploadedBlobUrl != null) {
      WebUiSettings settings;
      
      settings = WebUiSettings(
        context: context,
        presentStyle: CropperPresentStyle.dialog,
        boundary: CroppieBoundary(
          width: width.toInt(),
          height: height.toInt(),
        ),
        viewPort: CroppieViewPort(
          width: (width - 20).toInt(),
          height: (height - 20).toInt(),
          type: 'square'
        ),
        enableExif: true,
        enableZoom: true,
        showZoomer: true,
      );
     
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _uploadedBlobUrl!,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [settings],
      );
      if (croppedFile != null) {
        setState(() {
          _croppedBlobUrl = croppedFile.path;
        });
      }
    }
  }

  Future<void> _uploadImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    // final pickedFile = await FilePickerWeb.platform.pickFiles();
    if (pickedFile != null) {
      final blobUrl = pickedFile.path;
      debugPrint('picked blob: $blobUrl');
      setState(() {
        _uploadedBlobUrl = blobUrl;
      });
    }
  }

  void _clear() {
    setState(() {
      _uploadedBlobUrl = null;
      _croppedBlobUrl = null;
    });
  }
}