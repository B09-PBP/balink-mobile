import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';

class VehicleCarousel extends StatelessWidget {
  final List<String> featuredImages;

  const VehicleCarousel({
    Key? key,
    required this.featuredImages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200, // Berikan tinggi eksplisit di sini
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          final imageUrl = featuredImages[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.broken_image,
                      size: 100,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
          );
        },
        itemCount: featuredImages.length,
        viewportFraction: 0.8,
        scale: 0.9,
        autoplay: true,
        autoplayDelay: 3000,
        pagination: const SwiperPagination(
          alignment: Alignment.bottomCenter,
          builder: SwiperPagination.dots,
        ),
      ),
    );
  }
}
