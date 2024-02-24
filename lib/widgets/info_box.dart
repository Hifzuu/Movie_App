import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoBox extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final Color? iconColor;

  const InfoBox({
    required this.label,
    required this.value,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      ),
      child: Row(
        children: [
          if (icon != null)
            Icon(
              icon,
              color: iconColor,
            ),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.aBeeZee(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.aBeeZee(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DurationInfoBox extends StatelessWidget {
  final String label;
  final int durationInMinutes;
  final IconData icon;
  final Color iconColor;

  const DurationInfoBox({
    required this.label,
    required this.durationInMinutes,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    int hours = durationInMinutes ~/ 60;
    int minutes = durationInMinutes % 60;

    return InfoBox(
      label: label,
      value: '${hours}h ${minutes}min',
      icon: icon,
      iconColor: iconColor,
    );
  }
}
