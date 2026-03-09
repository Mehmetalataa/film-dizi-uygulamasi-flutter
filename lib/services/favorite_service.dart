
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {
  static const String _key = "favori_filmler"; 
  static Future<void> toggleFavorite(int movieId) async{
    final prefs = await SharedPreferences.getInstance();
    List<String > favorites = prefs.getStringList(_key) ?? []; 
    String id = movieId.toString(); 

    if(favorites.contains(id)){
      favorites.remove(id); 
    }else{
      favorites.add(id); 
    }
    await prefs.setStringList(_key, favorites); 
  }

  static Future<bool> isFavorite(int movieId) async{
    final prefs = await SharedPreferences.getInstance(); 
    List<String> favorites = prefs.getStringList(_key) ?? []; 
    return favorites.contains(movieId.toString()); 
  }
}