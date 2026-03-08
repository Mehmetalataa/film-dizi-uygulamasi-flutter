class AppModel {
  final String originalTitle;
  final String posterPath;
  final String releaseDate;
  final double voteAverage;
  final String overview;
  final int id;

  AppModel({
    required this.originalTitle,
    required this.posterPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.overview,
    required this.id,
  });

  factory AppModel.fromJson(Map<String, dynamic> json) {
    return AppModel(
      originalTitle: json['original_title']?.toString() ?? "İsimsiz Film",
      posterPath: json['poster_path']?.toString() ?? "",
      releaseDate: json['release_date']?.toString() ?? "Bilinmiyor",
      voteAverage: (json['vote_average'] ?? 0.0).toDouble(),
      overview: json['overview']?.toString() ?? "Özet bulunamadı.",
      id: json['id'] ?? 0,
    );
  }
}
