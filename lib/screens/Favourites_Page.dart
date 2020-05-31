import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wallp/screens/Image_Page.dart';
import 'package:wallp/Fav_Images.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class FavPage extends StatefulWidget {
  @override
  _FavPageState createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> {
  //Used to store Favourite Images
  List items = [];

  _onLongPress(context, index){
    Alert(
      context: context,
      title: "Remove?",
      desc: "Are you sure you want to remove this photo from favourites?",
      buttons: [
        DialogButton(
          child: Text(
            "Yes",
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          color: Colors.red,
          onPressed: () {
            setState(() {
              FavImages().removeFavImages(items[index]);
            });
            Navigator.pop(context);
          },
        ),
        DialogButton(
          child: Text(
            "No",
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          onPressed: () => Navigator.pop(context),
          color: Colors.green,
        )
      ],
    ).show();
  }

  @override
  void initState() {
    super.initState();
    //Used to store the favourites result
    setState(() {
      items = FavImages().getFavImages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 10.0, top: 5.0, bottom: 10.0),
            child: Text(
              'Note: Longpress on the images to remove from favourites',
              style: TextStyle(
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          (items.length == 0) ?
          Expanded(child: SvgPicture.asset('images/empty.svg')) :
          Expanded(
            child: GridView.builder(
                padding: EdgeInsets.all(10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.65,
                ),
                itemCount: items.length,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemBuilder: (context, index){
                  return Hero(
                    tag: items[index][0],
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ImagePage(imgData: items[index],),)
                        );
                      },
                      onLongPress: (){
                        _onLongPress(context, index);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: Image.network(
                          items[index][2], fit: BoxFit.cover,),
                      ),
                    ),
                  );
                }
            ),
          )
        ],
      )
    );
  }
}

