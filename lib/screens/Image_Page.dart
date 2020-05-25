import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:flutter/services.dart';

class ImagePage extends StatelessWidget {

  final List imgData;

  ImagePage({@required this.imgData});

  void downloadImage() async {
    try {
      // Saved with this method.
      var imageId = await ImageDownloader.downloadImage(imgData[3]);
      if (imageId == null) {
        return;
      }

      // Below is a method of obtaining saved image information.
      var fileName = await ImageDownloader.findName(imageId);
      var path = await ImageDownloader.findPath(imageId);
      var size = await ImageDownloader.findByteSize(imageId);
      var mimeType = await ImageDownloader.findMimeType(imageId);
    } on PlatformException catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(imgData[1]),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){
                        downloadImage();
                      },
                      child: Icon(LineAwesomeIcons.cloud_download, size: 30,)),
                    GestureDetector(child: Icon(LineAwesomeIcons.heart, size: 30,)),
                    GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                          },
                        child: Icon(LineAwesomeIcons.arrow_left, size: 30,))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
