import 'package:flutter/material.dart';

/// Background hero + gradient overlay sesuai referensi Stitch
/// (linear 180deg: 25% gelap atas → 88% gelap bawah).
class OnboardingBackground extends StatelessWidget {
  const OnboardingBackground({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            errorBuilder: (_, _, _) => Container(
              color: const Color(0xFF1A1A1A),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(15, 23, 42, 0.25),
                  Color.fromRGBO(0, 0, 0, 0.05),
                  Color.fromRGBO(10, 10, 10, 0.45),
                  Color.fromRGBO(10, 10, 10, 0.88),
                ],
                stops: [0.0, 0.3, 0.65, 1.0],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
