import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_first_app/providers/city_provider.dart';
import 'package:provider/provider.dart';

class ActivityFormImagePicker extends StatefulWidget {
  final Function updateUrl;
  ActivityFormImagePicker({this.updateUrl});

  @override
  _ActivityFormImagePickerState createState() =>
      _ActivityFormImagePickerState();
}

class _ActivityFormImagePickerState extends State<ActivityFormImagePicker> {
  File _deviceImage;
  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    final PickedFile pickedFile = await imagePicker.getImage(source: source);
    _deviceImage = File(pickedFile.path);
    if (_deviceImage != null) {
      final url =
          await Provider.of<CityProvider>(context, listen: false).uploadImage(_deviceImage);
      widget.updateUrl(url);
      setState(() {});
      print('image ok');
    } else {
      print('no image');
    }
    try {} catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                icon: Icon(Icons.photo),
                label: Text('Galerie'),
                style: TextButton.styleFrom(
                  primary: Colors.grey[600],
                ),
                onPressed: () => _pickImage(ImageSource.gallery),
              ),
              TextButton.icon(
                icon: Icon(Icons.camera),
                label: Text('Caméra'),
                style: TextButton.styleFrom(
                  primary: Colors.grey[600],
                ),
                onPressed: () => _pickImage(ImageSource.camera),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            child: _deviceImage != null
                ? Image.file(_deviceImage)
                : Text('Auncune image'),
          )
        ],
      ),
    );
  }
}
