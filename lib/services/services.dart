import 'dart:convert';
import 'package:film_dizi_uygulamasi/constants/constants.dart';
import 'package:film_dizi_uygulamasi/models/models.dart';
import 'package:http/http.dart' as http;

class AppServices {
  Future<List<AppModel>> fetchdata({int page = 1}) async {
    print('$page. sayda için istek atılıyor');
    print('istekler atalıyor');
    final response = await http.get(
      Uri.parse(
        '${AppConstants.baseUrl}/movie/popular?api_key=${AppConstants.apiKey}&page=$page',
      ),
    );
    print('Durum Kodu ${response.statusCode}');
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data["results"];
      List<AppModel> movieList = results
          .map((e) => AppModel.fromJson(e))
          .toList();
      return movieList;
    } else {
      throw Exception('Veri Alınamadı');
    }
  }

  Future<String?> fetchTrailer(int movieId) async {
    final response = await http.get(
      Uri.parse(
        '${AppConstants.baseUrl}/movie/$movieId/videos?api_key=${AppConstants.apiKey}&language=en-US',
      ),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data["results"];
      print("Film ID: $movieId - Gelen Video Sayısı: ${results.length}");
      if (results.isEmpty) {
        print("Bu film için video bulumadı");
        return null;
      }
      for (var video in results) {
        if ((video["type"] == "Trailer" || video["type"] == "Teaser") &&
            video["site"] == "YouTube") {
          return video["key"];
        }
      }
    }
    return null;
  }


  Future<List<AppModel>> searchMovies(String query) async {
    final response = await http.get(
      Uri.parse(
        '${AppConstants.baseUrl}/search/movie?api_key=${AppConstants.apiKey}&query=$query&language=tr-TR',
      ),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data["results"];

      return results.map((e) => AppModel.fromJson(e)).toList();
    }else{
      throw Exception('Arama yapılamadı , hata kodu ${response.statusCode}'); 
    }
  }
}
