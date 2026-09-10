import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/bottom_sheet_wrapper.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/secondary_button.dart';
import '../data/mancala_engine.dart';
import 'widgets/mancala_board.dart';
import 'widgets/mancala_scoreboard.dart';
import 'widgets/mancala_result_dialog.dart';

/// Màn hình chơi Minigame Cờ Ô Ăn Quan (Mancala Việt Nam)
class MancalaGameScreen extends StatefulWidget {
  const MancalaGameScreen({super.key});

  @override
  State<MancalaGameScreen> createState() => _MancalaGameScreenState();
}

class _MancalaGameScreenState extends State<MancalaGameScreen> {
  final MancalaEngine _engine = MancalaEngine();
  int? _selectedPit;
  bool _isMoving = false;

  @override
  void initState() {
    super.initState();
  }

  /// Chọn một ô dân của người chơi
  void _handlePitTap(int pitIndex) {
    if (_engine.currentTurn != GameTurn.player || _isMoving) return;
    if (_engine.isLegalMove(pitIndex, GameTurn.player)) {
      setState(() {
        _selectedPit = pitIndex;
        _engine.statusMessage = 'Đã chọn ô ${pitIndex + 1}. Hãy chọn hướng rải quân (Trái / Phải)!';
      });
    }
  }

  /// Rải quân theo hướng đã chọn
  Future<void> _handleDirectionSelect(MoveDirection direction) async {
    if (_selectedPit == null || _isMoving) return;

    final int pit = _selectedPit!;
    setState(() {
      _isMoving = true;
      _selectedPit = null;
      _engine.statusMessage = 'Đang rải sỏi...';
    });

    // Thực hiện nước đi qua game engine
    await Future.delayed(const Duration(milliseconds: 300));
    _engine.executeMove(pit, direction);

    if (mounted) {
      setState(() {
        _isMoving = false;
      });

      // Kiểm tra kết thúc game
      if (_engine.resultState != GameResultState.ongoing) {
        _showGameOverDialog();
        return;
      }

      // Nếu chuyển sang lượt AI, kích hoạt máy suy nghĩ và đi
      if (_engine.currentTurn == GameTurn.ai) {
        _triggerAiMove();
      }
    }
  }

  /// AI (Trạng Tí) tự động tính toán và đi quân
  Future<void> _triggerAiMove() async {
    setState(() {
      _engine.statusMessage = 'Trạng Tí đang suy nghĩ tính toán nước đi...';
    });

    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted || _engine.resultState != GameResultState.ongoing) return;

    final aiMove = _engine.getBestAiMove();
    if (aiMove != null) {
      final int pit = aiMove['pit'] as int;
      final MoveDirection dir = aiMove['direction'] as MoveDirection;

      setState(() {
        _selectedPit = pit;
        _isMoving = true;
      });

      await Future.delayed(const Duration(milliseconds: 400));
      if (!mounted) return;

      _engine.executeMove(pit, dir);

      setState(() {
        _isMoving = false;
        _selectedPit = null;
      });

      if (_engine.resultState != GameResultState.ongoing) {
        _showGameOverDialog();
      }
    } else {
      // AI không còn nước đi
      if (_engine.resultState != GameResultState.ongoing) {
        _showGameOverDialog();
      }
    }
  }

  /// Hiển thị hộp thoại kết quả
  void _showGameOverDialog() {
    MancalaResultDialog.show(
      context,
      playerScore: _engine.playerScore,
      aiScore: _engine.aiScore,
      resultState: _engine.resultState,
      onPlayAgain: () {
        setState(() {
          _engine.reset();
          _selectedPit = null;
          _isMoving = false;
        });
      },
      onExit: () => Navigator.pop(context),
    );
  }

  /// Mở BottomSheet hướng dẫn luật chơi Ô Ăn Quan
  void _showRulesSheet() {
    BottomSheetWrapper.show(
      context,
      title: 'Luật Chơi Cờ Ô Ăn Quan',
      subtitle: 'Trò chơi trí tuệ cung đình & dân gian Việt Nam',
      bottomAction: PrimaryButton(
        label: 'Đã hiểu luật, chơi ngay!',
        isFullWidth: true,
        icon: const Icon(Icons.check_circle_outline_rounded, color: Colors.white, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '1. Bàn cờ & Quân sỏi:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary),
          ),
          SizedBox(height: 4),
          Text(
            '• Gồm 10 ô Dân (mỗi bên 5 ô, ban đầu chứa 5 hạt) và 2 ô Quan lớn ở hai đầu (Quan Đông và Quan Tây, mỗi ô trị giá 10 điểm).',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
          ),
          SizedBox(height: 12),
          Text(
            '2. Cách rải quân:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary),
          ),
          SizedBox(height: 4),
          Text(
            '• Chọn một ô dân của mình có hạt, chọn chiều rải (Trái hoặc Phải). Bốc hết hạt trong ô và rải lần lượt từng hạt vào các ô liên tiếp.',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
          ),
          SizedBox(height: 12),
          Text(
            '3. Nối mạch & Ăn quân:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary),
          ),
          SizedBox(height: 4),
          Text(
            '• Nếu ô tiếp sau có hạt (khác ô Quan): Bốc tiếp rải tiếp (nối mạch).\n'
            '• Nếu ô tiếp sau là ô trống và ô kế tiếp nữa có hạt: Ăn toàn bộ số hạt ở ô đó!\n'
            '• Nếu ô tiếp sau là ô Quan có hạt hoặc gặp 2 ô trống: Hết lượt, chuyển cho đối thủ.',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
          ),
          SizedBox(height: 12),
          Text(
            '4. Kết thúc ván đấu:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary),
          ),
          SizedBox(height: 4),
          Text(
            '• Khi cả hai ô Quan bị ăn hết, ván cờ kết thúc. Bên nào ăn được nhiều hạt hơn sẽ giành chiến thắng!',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Thanh AppBar đỉnh
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CỜ Ô ĂN QUAN',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          'Đấu trí dân gian Việt Nam',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Nút xem hướng dẫn luật chơi
                  IconButton(
                    icon: const Icon(Icons.help_outline_rounded, color: AppColors.primary),
                    tooltip: 'Xem luật chơi',
                    onPressed: _showRulesSheet,
                  ),
                  // Nút chơi lại / đặt lại bàn cờ
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded, color: AppColors.textSecondary),
                    tooltip: 'Chơi ván mới',
                    onPressed: () {
                      setState(() {
                        _engine.reset();
                        _selectedPit = null;
                        _isMoving = false;
                      });
                    },
                  ),
                ],
              ),
            ),

            const Divider(height: 1, color: Color(0xFFE2DDD2)),

            // 2. Nội dung ván cờ cuộn linh hoạt
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Column(
                  children: [
                    // Bảng điểm & chỉ số lượt chơi
                    MancalaScoreboard(
                      playerScore: _engine.playerScore,
                      aiScore: _engine.aiScore,
                      currentTurn: _engine.currentTurn,
                      statusMessage: _engine.statusMessage,
                    ),

                    const SizedBox(height: 24),

                    // Bàn cờ Ô Ăn Quan 3D
                    MancalaBoard(
                      pits: _engine.pits,
                      selectedPit: _selectedPit,
                      isPlayerTurn: _engine.currentTurn == GameTurn.player,
                      isMoving: _isMoving,
                      onPitTap: _handlePitTap,
                      onDirectionSelect: _handleDirectionSelect,
                    ),

                    const SizedBox(height: 30),

                    // Hàng nút tiện ích bên dưới
                    Row(
                      children: [
                        Expanded(
                          child: SecondaryButton(
                            label: 'Luật Chơi',
                            height: 48,
                            icon: const Icon(Icons.menu_book_rounded, color: AppColors.primaryDark, size: 18),
                            onPressed: _showRulesSheet,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: PrimaryButton(
                            label: 'Tổng Kết Ván',
                            height: 48,
                            icon: const Icon(Icons.flag_rounded, color: Colors.white, size: 18),
                            onPressed: () {
                              _engine.endGame();
                              _showGameOverDialog();
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
