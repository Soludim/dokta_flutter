import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  final Function setImage;

  const ImageInput(this.setImage, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  late File _imageFile;

  void _getImage(BuildContext context, ImageSource source) {
    ImagePicker.pickImage(source: source, maxWidth: 400.0).then((File image) {
      retrieveLostData();
      setState(() {
        _imageFile = image;
      });
      widget.setImage(image);
      Navigator.pop(context);
    }).catchError((onError) {
      print(onError);
      retrieveLostData();
      Navigator.pop(context);
    });
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await ImagePicker.retrieveLostData();
    if (response == null) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _imageFile = response.file;
      });
    }
  }

  void _openImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 150.0,
            padding: const EdgeInsets.all(10.0),
            child: Column(children: [
              const Text(
                'Pick an Image',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10.0,
              ),
              FlatButton(
                textColor: Theme.of(context).primaryColor,
                child: const Text('Use Camera'),
                onPressed: () {
                  _getImage(context, ImageSource.camera);
                },
              ),
              FlatButton(
                textColor: Theme.of(context).primaryColor,
                child: const Text('Use Gallery'),
                onPressed: () {
                  _getImage(context, ImageSource.gallery);
                },
              )
            ]),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // Widget previewImage = const Text('Please select an image.');
    // previewImage = Card(
    //   elevation: 10.0,
    //   child: Image.file(
    //     _imageFile,
    //     fit: BoxFit.cover,
    //     height: 300.0,
    //     width: MediaQuery.of(context).size.width,
    //     alignment: Alignment.topCenter,
    //   ),
    // );

    return IconButton(
        onPressed: () {
          _openImagePicker(context);
        },
        icon: const Icon(Icons.camera_alt));
  }
}
