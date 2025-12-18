import 'package:flutter/material.dart';

class ConvexConcaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    const radius = 28.0; // Rayon des coins arrondis

    // Commencer en bas à gauche après le coin arrondi
    path.moveTo(radius, 0);
    var deltaWidth = 5;
    // Ligne du bas jusqu'au point avant la découpe
    path.lineTo(size.width + deltaWidth, 0);

    const cutoutRadius = 20; // Rayon de la découpe convexe

    // Courbe convexe à droite (en haut)
    var delta = 4.0;

    path.quadraticBezierTo(
      size.width + deltaWidth - cutoutRadius,
      0,
      size.width + deltaWidth - cutoutRadius,
      size.height / 2 - delta,
    );

    path.lineTo(
        size.width + deltaWidth - cutoutRadius, size.height / 2 + delta);

    // Courbe convexe à droite (en haut)
    path.quadraticBezierTo(
      size.width + deltaWidth - cutoutRadius,
      size.height,
      size.width + deltaWidth,
      size.height,
    );

    // Ligne du bas
    path.lineTo(radius, size.height);

    // Coin arrondi en bas à gauche
    path.quadraticBezierTo(
      0,
      size.height,
      0,
      size.height - radius,
    );

    // Ligne gauche
    path.lineTo(0, radius);

    // Coin arrondi en haut à gauche
    path.quadraticBezierTo(
      0,
      0,
      radius,
      0,
    );

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
