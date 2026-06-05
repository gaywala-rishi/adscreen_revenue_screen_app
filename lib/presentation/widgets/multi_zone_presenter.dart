import 'package:flutter/material.dart';
import '../../domain/models/layout_config.dart';
import 'zone_player_frame.dart';

class MultiZonePresenter extends StatelessWidget {
  final LayoutConfig layout;
  final bool isMuted;
  
  const MultiZonePresenter({
    super.key, 
    required this.layout,
    this.isMuted = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;

        return Stack(
          children: layout.regions.map((region) {
            return Positioned(
              left: region.x * screenWidth,
              top: region.y * screenHeight,
              width: region.width * screenWidth,
              height: region.height * screenHeight,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white10, width: 0.5),
                ),
                child: ZonePlayerFrame(
                  regionId: region.id,
                  isMuted: isMuted || !region.hasAudio,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
