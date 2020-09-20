import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:SBT/screens/admin/add_gallery.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../my_colors.dart';

class AdditionalImageProcess extends StatelessWidget {
  var val;
  var document;
  AdditionalImageProcess({this.val, this.document});
  @override
  Widget build(BuildContext context) {
    return ImageCapture(
      collection: val,
      document: document,
    );
  }
}

class ImageCapture extends StatefulWidget {
  var collection;
  var document;
  ImageCapture({this.collection, this.document});
  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  File _imageFile;
  Future<void> _pickImage(ImageSource source) async {
    File selectedImage = await ImagePicker.pickImage(source: source);
    setState(() {
      _imageFile = selectedImage;
    });
  }

  Future<void> _cropImage() async {
    File croppedImage = await ImageCropper.cropImage(
        sourcePath: _imageFile.path,
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ),
        androidUiSettings: AndroidUiSettings(
            lockAspectRatio: false,
            initAspectRatio: CropAspectRatioPreset.original,
            toolbarColor: MyColors.STATUS_BAR,
            toolbarWidgetColor: Colors.white,
            toolbarTitle: "Crop Image"));
    setState(() {
      _imageFile = croppedImage ?? _imageFile;
    });
  }

  void _clear() {
    setState(() {
      _imageFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    _showSnackBar() {
      final snackBar = SnackBar(
        content: Text('Image Uploaded Successfully'),
        duration: Duration(seconds: 3),
        backgroundColor: MyColors.TEXT_FIELD_BCK,
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }

    Future uploadFile(val, file) async {
      String filename = p.basename(_imageFile.path);
      var storageRef = FirebaseStorage.instance
          .ref()
          .child(widget.collection)
          .child('Additional Images').child(widget.document)
          .child(p.basename(filename));
      StorageUploadTask uploadTask = storageRef.putFile(_imageFile);
      bool taskCompleted = uploadTask.isCanceled;
      print("task Completed :: $taskCompleted");
      if (taskCompleted != true) {
        _showSnackBar();
        _clear();
      }
      var downloadURL =
          await (await uploadTask.onComplete).ref.getDownloadURL();
      var imageURL = downloadURL.toString();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => AddGallery(
                imageURL: imageURL,
                collection: widget.collection,
            document: widget.document,
              )));
      print(imageURL);
      return "";
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: MyColors.APP_BCK,
        title: Text('Image Process'),
      ),
      bottomNavigationBar: BottomAppBar(
        color: MyColors.APP_BCK,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.camera),
              iconSize: 40,
              onPressed: () => _pickImage(ImageSource.camera),
            ),
            IconButton(
              icon: Icon(Icons.photo_library),
              iconSize: 40,
              onPressed: () => _pickImage(ImageSource.gallery),
            ),
            IconButton(
              icon: Icon(Icons.file_upload),
              iconSize: 40,
              onPressed: _imageFile != null
                  ? () {
                      uploadFile(widget.collection, _imageFile);
                    }
                  : null,
            )
          ],
        ),
      ),
      body: ListView(
        children: [
          if (_imageFile != null) ...[
            Image.file(_imageFile),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.crop),
                  onPressed: _cropImage,
                  color: MyColors.APP_BCK,
                  iconSize: 35,
                ),
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: _clear,
                  color: MyColors.APP_BCK,
                  iconSize: 35,
                )
              ],
            )
          ]
        ],
      ),
    );
  }
}
