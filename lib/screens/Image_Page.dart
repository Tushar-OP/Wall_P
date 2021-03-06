import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:flutter/services.dart';
import 'package:wallp/Fav_Images.dart';
import 'package:like_button/like_button.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:share/share.dart';

class ImagePage extends StatelessWidget {
  final List imgData;
  bool isExist;

  ImagePage({@required this.imgData});

  Future<bool> downloadImage(bool isLiked) async {
    try {
      // Saved with this method.
      var imageId = await ImageDownloader.downloadImage(
        imgData[3],
        destination: AndroidDestinationType.directoryPictures,
      );
      if (imageId == null) {
        print(null);
        return !isLiked;
      }

      // Below is a method of obtaining saved image information.
      var fileName = await ImageDownloader.findName(imageId);
      var path = await ImageDownloader.findPath(imageId);
      var size = await ImageDownloader.findByteSize(imageId);
      var mimeType = await ImageDownloader.findMimeType(imageId);

      toast('Downloaded!');
    } on PlatformException catch (error) {
      toast("Sorry, couldn't download");
      print(error);
    }

    return !isLiked;
  }

  Future<bool> addToFav(bool isLiked) async {
    isExist = FavImages().addFavImages(imgData);
    //Check the returned result so that appropriate toast notification can be given.
    if (isExist == true){
      toast('Added to Favs!');
    }else{
      toast('Already in Favs!');
    }
    return !isLiked;
  }

  Future<bool> toShare(bool isLiked) async {
    Share.share('Check out this wallpaper:\n${imgData[4]}\nFouud it on Wall:P');
    return !isLiked;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Hero(
          tag: imgData[0],
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imgData[1]),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 50.0, right: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 20.0,
                        child: LikeButton(
                          likeBuilder: (bool isLiked) {
                            return Icon(
                              Icons.share,
                              color: isLiked
                                  ? Color.fromRGBO(108, 99, 255, 1)
                                  : Colors.grey,
                              size: 30,
                            );
                          },
                          onTap: toShare,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      LikeButton(
                        likeBuilder: (bool isLiked) {
                          return Icon(
                            Icons.cloud_download,
                            color: isLiked
                                ? Color.fromRGBO(108, 99, 255, 1)
                                : Colors.grey,
                            size: 30,
                          );
                        },
                        onTap: downloadImage,
                      ),
                      LikeButton(
                        likeBuilder: (bool isLiked) {
                          return Icon(
                            Icons.favorite,
                            color: isLiked
                                ? Color.fromRGBO(108, 99, 255, 1)
                                : Colors.grey,
                            size: 30,
                          );
                        },
                        onTap: addToFav,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          LineAwesomeIcons.arrow_left,
                          size: 30,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

