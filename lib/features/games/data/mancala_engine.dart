import 'dart:math';

/// Chiều rải quân trên bàn cờ Ô Ăn Quan
enum MoveDirection {
  right, // Thuận chiều kim đồng hồ (sang phải ở hàng dưới)
  left,  // Ngược chiều kim đồng hồ (sang trái ở hàng dưới)
}

/// Lượt chơi
enum GameTurn {
  player, // Bạn
  ai,     // Máy (Trạng Tí)
}

/// Trạng thái kết thúc game
enum GameResultState {
  ongoing,   // Đang diễn ra
  playerWon, // Bạn thắng
  aiWon,     // Máy thắng
  draw,      // Hòa
}

/// Game Engine quản lý toàn bộ bàn cờ Ô Ăn Quan
class MancalaEngine {
  /// Bàn cờ gồm 12 ô:
  /// - 0..4: 5 ô dân của Người chơi (Hàng dưới: trái -> phải)
  /// - 5: Ô Quan bên phải (Quan Phải)
  /// - 6..10: 5 ô dân của Máy/AI (Hàng trên: phải -> trái)
  /// - 11: Ô Quan bên trái (Quan Trái)
  List<int> pits;

  int playerScore;
  int aiScore;
  GameTurn currentTurn;
  GameResultState resultState;
  String statusMessage;

  // Lịch sử bước rải gần nhất để hiển thị hoạt ảnh
  List<String> moveHistory = [];

  MancalaEngine({
    List<int>? pits,
    this.playerScore = 0,
    this.aiScore = 0,
    this.currentTurn = GameTurn.player,
    this.resultState = GameResultState.ongoing,
    this.statusMessage = 'Lượt của bạn. Hãy chọn một ô dân để đi quân!',
  }) : pits = pits ?? [5, 5, 5, 5, 5, 10, 5, 5, 5, 5, 5, 10];

  /// Đặt lại bàn cờ về trạng thái ban đầu
  void reset() {
    pits = [5, 5, 5, 5, 5, 10, 5, 5, 5, 5, 5, 10];
    playerScore = 0;
    aiScore = 0;
    currentTurn = GameTurn.player;
    resultState = GameResultState.ongoing;
    statusMessage = 'Lượt của bạn. Hãy chọn một ô dân để đi quân!';
    moveHistory.clear();
  }

  /// Kiểm tra ô có phải là Ô Quan hay không (ô 5 và ô 11)
  static bool isQuanPit(int index) => index == 5 || index == 11;

  /// Kiểm tra ô có thuộc về người chơi hay không (ô 0 đến 4)
  static bool isPlayerPit(int index) => index >= 0 && index <= 4;

  /// Kiểm tra ô có thuộc về AI hay không (ô 6 đến 10)
  static bool isAiPit(int index) => index >= 6 && index <= 10;

  /// Tìm ô tiếp theo theo hướng đi
  static int getNextIndex(int current, MoveDirection direction) {
    if (direction == MoveDirection.right) {
      return (current + 1) % 12;
    } else {
      return (current - 1 + 12) % 12;
    }
  }

  /// Kiểm tra nước đi có hợp lệ không
  bool isLegalMove(int pitIndex, GameTurn turn) {
    if (resultState != GameResultState.ongoing) return false;
    if (isQuanPit(pitIndex)) return false;
    if (turn == GameTurn.player && !isPlayerPit(pitIndex)) return false;
    if (turn == GameTurn.ai && !isAiPit(pitIndex)) return false;
    return pits[pitIndex] > 0;
  }

  /// Kiểm tra và xử lý trường hợp một bên hết quân ở các ô dân
  void checkAndBorrowSeeds() {
    // Kiểm tra hàng người chơi
    final bool playerEmpty = [0, 1, 2, 3, 4].every((i) => pits[i] == 0);
    if (playerEmpty && resultState == GameResultState.ongoing) {
      if (playerScore >= 5) {
        playerScore -= 5;
        for (int i = 0; i <= 4; i++) {
          pits[i] = 1;
        }
        statusMessage = 'Bạn đã rải 5 hạt từ kho điểm vào các ô dân!';
      } else {
        // Không đủ quân để rải, ván cờ kết thúc sớm
        endGame();
      }
    }

    // Kiểm tra hàng AI
    final bool aiEmpty = [6, 7, 8, 9, 10].every((i) => pits[i] == 0);
    if (aiEmpty && resultState == GameResultState.ongoing) {
      if (aiScore >= 5) {
        aiScore -= 5;
        for (int i = 6; i <= 10; i++) {
          pits[i] = 1;
        }
        statusMessage = 'Đối thủ đã rải 5 hạt từ kho điểm vào các ô dân!';
      } else {
        endGame();
      }
    }
  }

  /// Thực hiện một nước đi hoàn chỉnh
  Map<String, dynamic> executeMove(int startPit, MoveDirection direction) {
    if (!isLegalMove(startPit, currentTurn)) {
      return {'success': false, 'pointsGained': 0};
    }

    int hand = pits[startPit];
    pits[startPit] = 0;
    int curr = startPit;
    int pointsGained = 0;
    final List<Map<String, dynamic>> stepLogs = [];

    // Giai đoạn rải quân
    while (true) {
      // 1. Rải hết số hạt trên tay
      while (hand > 0) {
        curr = getNextIndex(curr, direction);
        pits[curr]++;
        hand--;
        stepLogs.add({'type': 'sow', 'pit': curr, 'count': pits[curr]});
      }

      // 2. Xét ô liền kề tiếp theo
      final int next1 = getNextIndex(curr, direction);

      // Trường hợp A: Ô kế tiếp có hạt và KHÔNG PHẢI là ô Quan -> Bốc tiếp rải tiếp (Nối mạch)
      if (!isQuanPit(next1) && pits[next1] > 0) {
        hand = pits[next1];
        pits[next1] = 0;
        curr = next1;
        stepLogs.add({'type': 'pickup', 'pit': next1, 'hand': hand});
        continue;
      }

      // Trường hợp B: Ô kế tiếp là ô trống -> Xét ăn quân
      if (pits[next1] == 0) {
        int emptyCheck = next1;
        bool eatenAny = false;

        while (true) {
          final int targetPit = getNextIndex(emptyCheck, direction);
          // Nếu ô sau ô trống có hạt (kể cả ô quan) -> ĂN!
          if (pits[targetPit] > 0) {
            final int eatenStones = pits[targetPit];
            pits[targetPit] = 0;
            pointsGained += eatenStones;
            eatenAny = true;
            stepLogs.add({'type': 'eat', 'pit': targetPit, 'points': eatenStones});

            // Kiểm tra ăn bật / ăn kép: Nếu ô tiếp sau lại trống
            final int nextEmpty = getNextIndex(targetPit, direction);
            if (pits[nextEmpty] == 0) {
              emptyCheck = nextEmpty;
              continue;
            } else {
              break; // Ô tiếp sau có hạt, không ăn được nữa
            }
          } else {
            // Ô sau ô trống cũng trống (2 ô trống liên tiếp) -> Chết lượt
            break;
          }
        }

        if (eatenAny) {
          break; // Đã ăn xong, kết thúc lượt đi
        }
      }

      // Trường hợp C: Ô kế tiếp là ô Quan có hạt, hoặc không ăn được nữa -> Hết lượt
      break;
    }

    // Cộng điểm cho bên vừa đi
    if (currentTurn == GameTurn.player) {
      playerScore += pointsGained;
      if (pointsGained > 0) {
        statusMessage = 'Tuyệt vời! Bạn đã ăn được $pointsGained hạt!';
      } else {
        statusMessage = 'Đã hoàn thành lượt đi. Đến lượt đối thủ!';
      }
      currentTurn = GameTurn.ai;
    } else {
      aiScore += pointsGained;
      if (pointsGained > 0) {
        statusMessage = 'Đối thủ đã ăn được $pointsGained hạt!';
      } else {
        statusMessage = 'Đối thủ đã đi xong. Đến lượt của bạn!';
      }
      currentTurn = GameTurn.player;
    }

    // Kiểm tra hết quan -> Kết thúc trò chơi
    if (pits[5] == 0 && pits[11] == 0) {
      endGame();
    } else {
      // Kiểm tra có bên nào cần rải lại 5 hạt không
      checkAndBorrowSeeds();
    }

    return {
      'success': true,
      'pointsGained': pointsGained,
      'steps': stepLogs,
    };
  }

  /// Tính toán nước đi thông minh nhất cho AI (Trạng Tí)
  Map<String, dynamic>? getBestAiMove() {
    if (currentTurn != GameTurn.ai || resultState != GameResultState.ongoing) {
      return null;
    }

    final List<int> validPits = [];
    for (int i = 6; i <= 10; i++) {
      if (pits[i] > 0) validPits.add(i);
    }

    if (validPits.isEmpty) {
      checkAndBorrowSeeds();
      return null;
    }

    int bestPit = validPits.first;
    MoveDirection bestDir = MoveDirection.right;
    int maxPoints = -1;

    // Duyệt qua tất cả các lựa chọn để tìm nước đi ăn nhiều điểm nhất
    for (final pit in validPits) {
      for (final dir in [MoveDirection.right, MoveDirection.left]) {
        // Clone trạng thái để mô phỏng
        final cloneEngine = MancalaEngine(
          pits: List<int>.from(pits),
          playerScore: playerScore,
          aiScore: aiScore,
          currentTurn: GameTurn.ai,
        );
        final result = cloneEngine.executeMove(pit, dir);
        final points = result['pointsGained'] as int? ?? 0;

        if (points > maxPoints) {
          maxPoints = points;
          bestPit = pit;
          bestDir = dir;
        }
      }
    }

    // Nếu không ăn được điểm nào thì chọn ngẫu nhiên một ô hợp lệ
    if (maxPoints == 0) {
      bestPit = validPits[Random().nextInt(validPits.length)];
      bestDir = Random().nextBool() ? MoveDirection.right : MoveDirection.left;
    }

    return {
      'pit': bestPit,
      'direction': bestDir,
    };
  }

  /// Kết thúc ván cờ và thu nốt các hạt dân còn lại
  void endGame() {
    // Người chơi thu toàn bộ hạt còn lại ở hàng của mình
    for (int i = 0; i <= 4; i++) {
      playerScore += pits[i];
      pits[i] = 0;
    }

    // AI thu toàn bộ hạt còn lại ở hàng của mình
    for (int i = 6; i <= 10; i++) {
      aiScore += pits[i];
      pits[i] = 0;
    }

    // Xác định kết quả
    if (playerScore > aiScore) {
      resultState = GameResultState.playerWon;
      statusMessage = 'ĐẠI THẮNG! Bạn đã giành chiến thắng thuyết phục!';
    } else if (aiScore > playerScore) {
      resultState = GameResultState.aiWon;
      statusMessage = 'ĐỐI THỦ THẮNG! Chúc bạn may mắn ở ván đấu sau!';
    } else {
      resultState = GameResultState.draw;
      statusMessage = 'HÒA CỜ! Một ván cờ ngang tài ngang sức!';
    }
  }
}
