import 'package:film_dizi_uygulamasi/constants/constants.dart';
import 'package:film_dizi_uygulamasi/models/models.dart';
import 'package:film_dizi_uygulamasi/services/favorite_service.dart';
import 'package:film_dizi_uygulamasi/services/services.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetailView extends StatelessWidget {
  final AppModel datas;
  const MovieDetailView({super.key, required this.datas});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              final String appLink = "https://mehmetalata.com.tr";
              Share.share(
                'Bu film seninle paylaşmak istedim : ${datas.originalTitle}\n\n'
                'Detaylar için tıkla: $appLink',
                subject: datas.originalTitle,
              );
            },
            icon: Icon(Icons.share, color: Colors.white),
          ),
         FavoriteButton(movieId: datas.id),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.network(
                  '${AppConstants.imageBaseUrl}${datas.posterPath}',
                  width: double.infinity,
                  height: 450,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => SizedBox(
                    height: 450,
                    child: Icon(
                      Icons.broken_image,
                      color: Colors.grey,
                      size: 100,
                    ),
                  ),
                ),
                Positioned(
                  top: 50,
                  left: 15,
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.5),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsetsGeometry.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    datas.originalTitle,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 20),
                      SizedBox(width: 5),
                      Text(
                        "${datas.voteAverage.toStringAsFixed(1)} Puan",
                        style: TextStyle(
                          color: Color(0xFF46D369),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 20),
                      Text(
                        datas.releaseDate.split('-')[0],
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        String? trailerKey = await AppServices().fetchTrailer(
                          datas.id,
                        );
                        if (trailerKey != null) {
                          final Uri url = Uri.parse(
                            'https://www.youtube.com/watch?v=$trailerKey',
                          );
                          if (!await launchUrl(
                            url,
                            mode: LaunchMode.externalApplication,
                          )) {
                            throw Exception('Fragman açılamadı: $url');
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Bu film için fragman bulunamadı."),
                            ),
                          );
                        }
                      },
                      icon: Icon(
                        Icons.play_arrow,
                        color: Colors.black,
                        size: 30,
                      ),
                      label: Text(
                        'Fragman İzle',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(5),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    "Özet",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    datas.overview,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FavoriteButton extends StatefulWidget {
  final int movieId;
  const FavoriteButton({super.key, required this.movieId});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool isFav = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus(); 
  }

  void _loadFavoriteStatus() async {
    bool result = await FavoriteService.isFavorite(widget.movieId);
    if (mounted) {
      setState(() {
        isFav = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFav ? Icons.favorite : Icons.favorite_border,
        color: isFav ? Colors.red : Colors.white,
      ),
      onPressed: () async {
        await FavoriteService.toggleFavorite(widget.movieId);
        setState(() {
          isFav = !isFav; // Rengi anında değiştir
        });
        
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isFav ? "Favorilere eklendi" : "Favorilerden çıkarıldı"),
            backgroundColor: isFav ? Colors.green : Colors.redAccent,
            duration: const Duration(milliseconds: 700),
          ),
        );
      },
    );
  }
}
