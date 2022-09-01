

import 'dart:typed_data';

import 'package:crop_image/crop_image.dart';
import 'package:default_proyect/router/routes.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as imagePackage;


import 'package:image_picker/image_picker.dart';

class DefaultView extends StatefulWidget {
  const DefaultView({ Key? key }) : super(key: key);

  @override
  State<DefaultView> createState() => _DefaultViewState();
}

class _DefaultViewState extends State<DefaultView> {


  final controller = CropController(
    aspectRatio: 16.0 / 9.0,
    defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9),
  );

  Uint8List? bytes;
  Widget? child;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: IconButton(
        onPressed: () => Navigator.pushReplacementNamed(context, Flurorouter.cropRoute), 
        icon: Icon(Icons.crop)
      ),
    ),
    body: Center(
      child: bytes == null || child == null ? Text('elige un archivo!') : child,
      // child: bytes == null ? Text('Elige un archivo!') : Padding(
      //   padding: const EdgeInsets.all(6.0),
      //   child: CropImage(
      //     controller: controller,
      //     image: Image.asset('imagendeprueba.png'),
      //   ),
      // ),
    ),
    // body: Center(
    //   child: Padding(
    //     padding: const EdgeInsets.all(6.0),
    //     child: CropImage(
    //       controller: controller,
    //       image: Image.asset('imagendeprueba.png'),
    //     ),
    //   ),
    // ),
    bottomNavigationBar: _buildButtons(),
  );

  Widget _buildButtons() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          controller.aspectRatio = 1.0;
          controller.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
        },
      ),
      IconButton(
        icon: const Icon(Icons.aspect_ratio),
        onPressed: _aspectRatios,
      ),
      IconButton(
        icon: const Icon(Icons.image),
        onPressed: () async {
          // var picked = await FilePicker.platform.pickFiles();
          // if (picked != null) {
          //   bytes = picked.files.first.bytes;
          //   setState(() {
              
          //   });
          // }
          final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
          // final pickedFile = await FilePickerWeb.platform.pickFiles();
          if (pickedFile != null)  {
            bytes = await pickedFile.readAsBytes();
            // final image = imagePackage.decodeJpg(bytes!);
            print('----');
            // print(image);
            // final miniatura = imagePackage.copyResize(image!);

            // setState(() {});
          }
        },
      ),
      TextButton(
        onPressed: _finished,
        child: const Text('Done'),
      ),
    ],
  );

  Future<void> _aspectRatios() async {
    final value = await showDialog<double>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Select aspect ratio'),
          children: [
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 1.0),
              child: const Text('square'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 2.0),
              child: const Text('2:1'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 4.0 / 3.0),
              child: const Text('4:3'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 16.0 / 9.0),
              child: const Text('16:9'),
            ),
          ],
        );
      },
    );
    if (value != null) {
      controller.aspectRatio = value;
      controller.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
    }
  }

  Future<void> _finished() async {
    final image = await controller.croppedImage();
    // print(image);
    // ui.Image image2 = await controller.croppedBitmap();
    // final data = await image2.toByteData(format: ui.ImageByteFormat.png);
    // final bytes2 = image
    // File file = new File(bytes!, 'probando.png');
    print(image);
    
    await showDialog<bool>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          contentPadding: const EdgeInsets.all(6.0),
          titlePadding: const EdgeInsets.all(8.0),
          title: const Text('Cropped image'),
          children: [
            Text('relative: ${controller.crop}'),
            Text('pixels: ${controller.cropSize}'),
            const SizedBox(height: 5),
            image,
            // Image.memory(bytes2, width: 200,),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

Future<PlatformFile?> pickFileDiferentt(FileType type,
    {List<String>? allowedExtensions}) async {
  final FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: type,
    allowedExtensions: allowedExtensions,
  );
  final PlatformFile? file = result?.files.first;
  if (file == null) {
    return null;
  }
  return file;
}
