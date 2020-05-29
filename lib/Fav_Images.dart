
class FavImages{
  static List _favImages = [];
  //Used to store the unique ID of each photo for making sure that there are no duplicates
  static List _favImagesID = [];

  bool addFavImages(List imgData){
    //Check if the ID is already in _favImagesID, if so don't add in _favImages
    if (_favImagesID.contains(imgData[0]) == true){
        return false;
    } else {
      _favImages.add(imgData);
      _favImagesID.add(imgData[0]);
      return true;
    }

  }

  List getFavImages(){
    return _favImages;
  }

  void removeFavImages(List imgData){
    _favImages.remove(imgData);
    _favImagesID.remove(imgData[0]);
  }
}