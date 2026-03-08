# Film Dizi Uygulaması

Bu uygulama, TMDB API kullanarak popüler filmleri listeleyen, arama yapılmasına olanak sağlayan ve filmlerin fragmanlarını YouTube üzerinden oynatabilen basit bir Flutter projesidir.

## Özellikler

* **Popüler Filmler:** Ana sayfada en çok izlenen filmlerin listelenmesi.
* **Sonsuz Kaydırma:** Liste sonuna gelindiğinde otomatik olarak yeni filmlerin yüklenmesi.
* **Film Arama:** Film adına göre dinamik arama yapabilme.
* **Film Detayları:** Filmin özeti, puanı ve çıkış tarihi gibi bilgiler.
* **Fragman İzleme:** Film detay sayfasından YouTube fragmanlarına erişim.

## Kullanılan Teknolojiler

* Flutter & Dart
* HTTP (Veri çekme işlemleri için)
* YouTube Player Flutter (Fragman oynatma için)
* TMDB API (Film verileri için)

## Kurulum

1. Bu projeyi klonlayın.
2. `lib/constants/` klasörü altındaki `constants_example.dart` dosyasının adını `constants.dart` yapın.
3. TMDB üzerinden aldığınız kendi API anahtarınızı ilgili alana yapıştırın.
4. Terminale `flutter pub get` yazarak paketleri indirin.
5. Uygulamayı çalıştırın.