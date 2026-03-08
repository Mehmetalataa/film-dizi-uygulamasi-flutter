import 'package:film_dizi_uygulamasi/constants/constants.dart';
import 'package:film_dizi_uygulamasi/models/models.dart';
import 'package:film_dizi_uygulamasi/services/services.dart';
import 'package:film_dizi_uygulamasi/views/movie_detail_view.dart';
import 'package:film_dizi_uygulamasi/widgets/movie_card.dart';
import 'package:flutter/material.dart';

class AppViews extends StatefulWidget {
  const AppViews({super.key});

  @override
  State<AppViews> createState() => _AppViewsState();
}

class _AppViewsState extends State<AppViews> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  List<AppModel> _allMovies = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _fetchNextPage(); // İlk veriyi çek

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_isLoading) {
        _fetchNextPage(); // Sayfa sonuna gelince yeni veri çek
      }
    });
  }

  // Popüler filmleri getiren fonksiyon
  Future<void> _fetchNextPage() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final newMovies = await AppServices().fetchdata(page: _currentPage);
      setState(() {
        _allMovies.addAll(newMovies);
        _currentPage++;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      print('Veri çekme hatası: $e');
    }
  }

  // Arama işlemini yürüten fonksiyon
  void _onSearch(String query) async {
    if (query.isEmpty) return;
    setState(() => _isLoading = true);

    try {
      final results = await AppServices().searchMovies(query); //
      print("Arama Terimi: $query - Bulunan Film Sayısı: ${results.length}");
      setState(() {
        _allMovies = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      print('Arama hatası: $e');
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Netflix Siyahı
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  // AppBar Tasarımı
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      centerTitle: true,
      title: _isSearching
          ? TextField(
              controller: _searchController,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Film Ara...",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
              onSubmitted: (value) => _onSearch(value),
            )
          : const Text(
              'Movie App',
              style: TextStyle(
                color: Color(0xFFE50914),
                fontWeight: FontWeight.bold,
              ),
            ),
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              if (_isSearching) {
                _isSearching = false;
                _searchController.clear();
                _allMovies.clear();
                _currentPage = 1;
                _fetchNextPage(); // Arama kapatılınca başa dön
              } else {
                _isSearching = true;
              }
            });
          },
          icon: Icon(
            _isSearching ? Icons.close : Icons.search,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  // Liste Gövdesi
  Widget _buildBody() {
    if (_allMovies.isEmpty && _isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFE50914)),
      );
    }
    if (!_isLoading && _allMovies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.movie_filter_outlined, color: Colors.grey, size: 80),
            SizedBox(height: 16),
            Text(
              _isSearching
                  ? "Aradığınız kriterlere uygun film bulunamadı."
                  : "Filmler yüklenemedi. Lütfen internet bağlantınızı kontrol ediniz",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            if(_isSearching) TextButton(onPressed: () {
              setState(() {
                _isSearching = false ; 
                _searchController.clear(); 
                _fetchNextPage(); 
              });
            }, child: Text("Populer Filmlere Dön" , style:TextStyle(color:Color(0xFFE50914))))
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: _allMovies.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < _allMovies.length) {
          final movieData = _allMovies[index];
          return MovieCard(
            movie: movieData,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetailView(datas: movieData), //
                ),
              );
            },
          );
        } else {
          return const Padding(
            padding: EdgeInsets.all(15),
            child: Center(
              child: CircularProgressIndicator(color: Color(0xFFE50914)),
            ),
          );
        }
      },
    );
  }
}
