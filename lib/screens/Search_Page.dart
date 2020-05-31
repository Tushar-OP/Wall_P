import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:wallp/Networking.dart';
import 'package:wallp/screens/Image_Page.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  //Used to pass the page number for fetching the images
  int pageNumber = 1;
  //Used to store the result from Networking.dart
  List items = [];

  //Searched term
  String toSearch;

  //ScrollController
  ScrollController _controller = ScrollController();

  void getSearchImages(int pageNumber, String query) async {
    try{
      var data = await Images().getSearchImages(pageNumber, query);
      setState(() {
        items = data;
      });
    } catch(e) {
      print(e);
    }
  }

  void loadMore(String query) async {
    try{
      pageNumber = pageNumber + 1;
      var data = await Images().getSearchImages(pageNumber, query);
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
    getSearchImages(pageNumber, toSearch);
    _controller.addListener(() {
      if (_controller.offset >= _controller.position.maxScrollExtent &&
          !_controller.position.outOfRange){
        loadMore(toSearch);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        // Used to hide the keyboard when pressed anywhere on the screen outside TextField
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: Theme(
                data:  Theme.of(context).copyWith(primaryColor: Color.fromRGBO(108, 99, 255, 1)),
                child: TextField(
                  cursorColor: Color.fromRGBO(108, 99, 255, 1),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    suffixIcon: Icon(Icons.search),
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      borderSide: BorderSide(width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      borderSide: BorderSide(color: Color.fromRGBO(108, 99, 255, 1), width: 2),
                    ),
                  ),
                  onSubmitted: (value){
                    setState(() {
                      toSearch = value;
                      getSearchImages(pageNumber, toSearch);
                    });
                  },
                ),
              ),
            ),
            // If nothing is searched, then display Svg else the results will be shown
            (toSearch == null || toSearch.isEmpty) ?
            Expanded(
              child: SvgPicture.asset('images/empty.svg'),
            ) :
            Expanded(
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
                    return Hero(
                      tag: items[index][0],
                      child: GestureDetector(
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
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
