import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/models/game_item_model.dart';

/// Widget hiển thị trò chơi dạng App Icon trên màn hình chính (Dạng Grid 4 cột)
class GameAppIconTile extends StatelessWidget {
  final GameItemModel game;
  final VoidCallback onTap;

  const GameAppIconTile({
    super.key,
    required this.game,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      splashColor: game.gradientColors.first.withValues(alpha: 0.15),
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. App Icon Box (Squircle bo góc chuẩn di động)
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: game.gradientColors,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: game.gradientColors.first.withValues(alpha: 0.35),
                      blurRadius: 10,
                      spreadRadius: 0.5,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.35),
                    width: 1.2,
                  ),
                ),
                child: Center(
                  child: Icon(
                    game.icon,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),

              // 2. Huy hiệu góc trên bên phải (HOT, 1v1, MỚI...)
              if (game.badge != null)
                Positioned(
                  top: -4,
                  right: -4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                    decoration: BoxDecoration(
                      color: game.isPlayable
                          ? const Color(0xFFD32F2F)
                          : const Color(0xFF455A64),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white, width: 1),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 3,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Text(
                      game.badge!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),

              // 3. Chấm xanh cho các game đã có thể chơi ngay
              if (game.isPlayable)
                Positioned(
                  bottom: -2,
                  right: -2,
                  child: Container(
                    width: 13,
                    height: 13,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00E676),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.black87,
                        size: 8,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 6),

          // 2. Tên trò chơi bên dưới icon (Font rõ ràng, tối đa 2 dòng)
          SizedBox(
            width: 72,
            child: Text(
              game.shortName,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.roboto(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF263238),
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
