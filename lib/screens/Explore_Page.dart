import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wallp/Networking.dart';
import 'package:wallp/screens/Image_Page.dart';

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  //Used to pass the page number for fetching the images
  int pageNumber = 1;
  //Used to store the result from Networking.dart
  List items = [];
  
  //ScrollController
  ScrollController _controller = ScrollController();

  void getLatestImages(int pageNumber) async {
    try{
      var data = await Images().getLatestImages(pageNumber);
      setState(() {
        items = data;
      });
    } catch(e) {
      print(e);
    }
  }

  void loadMore() async {
    try{
      pageNumber = pageNumber + 1;
      var data = await Images().getLatestImages(pageNumber);
      setState(() {
        items.addAll(data);
      });
    } catch(e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getLatestImages(pageNumber);
    _controller.addListener(() {
      if (_controller.offset >= _controller.position.maxScrollExtent &&
          !_controller.position.outOfRange){
        loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GridView.builder(
        controller: _controller,
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.65,
        ),
        itemCount: items.length+1,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemBuilder: (context, index){
          if (index == items.length){
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(),
                ),
                SizedBox(height: 10,),
                Text(
                  'More Coming Up',
                ),
              ],
            );
          } else {
            return GestureDetector(
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ImagePage(imgData: items[index],),)
                );
              },
              child: ClipRRect(borderRadius: BorderRadius.all(Radius.circular(20)),
                child: Image.network(
                  items[index][2], fit: BoxFit.cover,),
              ),
            );
          }
        },
      ),
    );
  }
}
