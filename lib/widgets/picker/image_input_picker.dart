import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickAnImage extends StatefulWidget {
  final Function(File image) pickedImageFn;

  PickAnImage({this.pickedImageFn});
  @override
  _PickAnImageState createState() => _PickAnImageState();
}

class _PickAnImageState extends State<PickAnImage> {
  File chosenImage;
  pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.getImage(
        source: ImageSource.camera, imageQuality: 50, maxWidth: 150);
    final PickedImage = File(picked.path);

    setState(() {
      chosenImage = PickedImage;
    });
    widget.pickedImageFn(chosenImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage: chosenImage != null ? FileImage(chosenImage) : null,
        ),
        FlatButton.icon(
            onPressed: pickImage,
            icon: Icon(Icons.image),
            label: Text('add image`')),
      ],
    );
  }
}
