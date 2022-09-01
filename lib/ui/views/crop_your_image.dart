
import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:default_proyect/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';




class CropYourImageTest extends StatefulWidget {
  const CropYourImageTest({ Key? key }) : super(key: key);

  @override
  State<CropYourImageTest> createState() => _CropYourImageTestState();
}

class _CropYourImageTestState extends State<CropYourImageTest> {


  final List<CropController> _controllers = [];

  final _croppedDataList = [];

  final isCrop = [];

  var _isProcessing = false;
  set isProcessing(bool value) {
    setState(() {
      _isProcessing = value;
    });
  }

  Uint8List? _croppedData;
  set croppedData(Uint8List? value) {
    setState(() {
      _croppedData = value;
    });
  }

  void _cropAll() {
    _isProcessing = true;
    for (final controller in _controllers) {
      controller.crop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (() => Navigator.pushReplacementNamed(context, Flurorouter.finalyRoute)), 
          icon: Icon(Icons.home)
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: _croppedDataList.length > 0 && !_isProcessing,
            child: _croppedDataList.length > 0
                ? Visibility(
                    visible: _croppedData == null,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 500,
                      child: ListView.builder(
                        itemCount: _croppedDataList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 320,
                                child: Visibility(
                                  visible: !isCrop[index],
                                  child: Crop(
                                    cornerDotBuilder: (size, cornerIndex) => SizedBox.shrink(),
                                    aspectRatio: 16 / 9,
                                    initialSize: 0.7,
                                    maskColor: Colors.white.withAlpha(100),
                                    radius: 20,
                                    controller: _controllers[index],
                                    image: _croppedDataList[index],
                                    onCropped: (data) {
                                      setState(() {
                                        _croppedDataList[index] = data;
                                        isCrop[index] = true;
                                        _isProcessing = false;
                                      });
                                    },
                                  ),
                                  replacement: !isCrop[index]
                                      ? const SizedBox.shrink()
                                      : Image.memory(_croppedDataList[index]!),
                                ),
                              ),
                              SizedBox(height: 10),
                              if (!isCrop[index]) Padding(
                                padding: const EdgeInsets.all(16),
                                child: Wrap(
                                  spacing: 16,
                                  children: const [
                                    _ShapeSelection('16 : 9', 16 / 9, Icons.crop_7_5),
                                    _ShapeSelection('8 : 5', 8 / 5, Icons.crop_16_9),
                                    _ShapeSelection('7 : 5', 7 / 5, Icons.crop_5_4),
                                    _ShapeSelection('4 : 3', 4 / 3, Icons.crop_3_2),
                                  ].map((shapeData) {
                                    return InkWell(
                                      onTap: () {
                                        _controllers[index].withCircleUi = false;
                                        _controllers[index].aspectRatio = shapeData.aspectRatio;
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          children: [
                                            Icon(shapeData.icon),
                                            const SizedBox(height: 4),
                                            Text(shapeData.label)
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList()
                                    ..add(
                                      InkWell(
                                        onTap: () => _controllers[index].withCircleUi = true,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                            children: [
                                              Icon(Icons.fiber_manual_record_outlined),
                                              const SizedBox(height: 4),
                                              Text('Circle'),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          );
                        },
                      ),
                    ),
                    replacement: _croppedData != null
                      ? SizedBox(
                          height: double.infinity,
                          width: double.infinity,
                          child: Image.memory(
                            _croppedData!,
                            fit: BoxFit.contain,
                          ),
                        )
                      : const SizedBox.shrink(),
                  )
                : const SizedBox.shrink(),
            replacement: const Center(child: CircularProgressIndicator()),
          ),
          if (_croppedDataList.isNotEmpty && !isCrop[0]) Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: _cropAll,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text('CROPasd!'),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
      bottomNavigationBar: _buildButtons(),
    );
  }

  Widget _buildButtons() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      IconButton(
        icon: const Icon(Icons.image),
        onPressed: () async {
          // final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
          final files = await ImagePicker().pickMultiImage();
          // var picked = await FilePicker.platform.pickFiles(
          //   allowMultiple: true
          // );
          // final files2 = files?.files;
          // if(pickedFile == null || files.isEmpty){
          //   return null;
          // }
          if(files == null || files.isEmpty) return;
          // if(pickedFile == null) return;
          for (var i = 0; i < files.length; i++) {
            _croppedDataList.add(await files[i].readAsBytes());
            _controllers.add(new CropController());
            isCrop.add(false);
          }
          setState(() {});
        },
      )
    ],
  );
}

class SingleCropComponent extends StatefulWidget {
  const SingleCropComponent({
    Key? key,
    required this.bytes,
  }) : super(key: key);

  final Uint8List? bytes;

  @override
  State<SingleCropComponent> createState() => _SingleCropComponentState();
}

class _SingleCropComponentState extends State<SingleCropComponent> {

  final CropController _controller = new CropController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 32),
      height: 500,
      child: Column(
          children: [
            Expanded(
              child: Crop(
                image: widget.bytes!,
                controller: _controller,
                onCropped: (image) async {
                  await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                        contentPadding: const EdgeInsets.all(6.0),
                        titlePadding: const EdgeInsets.all(8.0),
                        title: const Text('Cropped image'),
                        children: [
                          const SizedBox(height: 5),
                          Image.memory(image),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                cornerDotBuilder: (size, cornerIndex) => SizedBox.shrink(),
                aspectRatio: 16 / 9,
                initialSize: 0.7,
                baseColor: Colors.blue.shade900,
                maskColor: Colors.white.withAlpha(100),
                radius: 20,
              )
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 16,
                children: const [
                  _ShapeSelection('16 : 9', 16 / 9, Icons.crop_7_5),
                  _ShapeSelection('8 : 5', 8 / 5, Icons.crop_16_9),
                  _ShapeSelection('7 : 5', 7 / 5, Icons.crop_5_4),
                  _ShapeSelection('4 : 3', 4 / 3, Icons.crop_3_2),
                ].map((shapeData) {
                  return InkWell(
                    onTap: () {
                      _controller.withCircleUi = false;
                      _controller.aspectRatio = shapeData.aspectRatio;
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Icon(shapeData.icon),
                          const SizedBox(height: 4),
                          Text(shapeData.label)
                        ],
                      ),
                    ),
                  );
                }).toList()
                  ..add(
                    InkWell(
                      onTap: () => _controller.withCircleUi = true,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Icon(Icons.fiber_manual_record_outlined),
                            const SizedBox(height: 4),
                            Text('Circle'),
                          ],
                        ),
                      ),
                    ),
                  ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Container(
                width: 200,
                child: ElevatedButton(
                  onPressed: (() {
                    _controller.crop();
                  }), 
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cut),
                      SizedBox(width: 16),
                      Text('Recortar')
                    ],
                  ),
                )
              ),
            )
          ],
        ),
    );
  }
}

class _ShapeSelection {
  const _ShapeSelection(this.label, this.aspectRatio, this.icon);
  final String label;
  final double aspectRatio;
  final IconData icon;
}