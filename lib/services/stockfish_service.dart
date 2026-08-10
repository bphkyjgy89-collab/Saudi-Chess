import 'dart:async';
import 'package:stockfish/stockfish.dart';

/// طبقة تغلف محرك Stockfish وتسهل التعامل معه:
/// - تبدأ المحرك وتنتظر يصير جاهز
/// - تضبط مستوى الصعوبة (Skill Level)
/// - تعطيك أفضل نقلة (UCI, مثال: "e2e4" أو "e7e8q" للترقية)
class StockfishService {
  Stockfish? _stockfish;
  StreamSubscription<String>? _outputSub;

  bool get isReady => _stockfish?.state.value == StockfishState.ready;

  /// يبدأ المحرك ويرجع لما يصير جاهز لاستقبال الأوامر
  Future<void> init() async {
    _stockfish = Stockfish();

    // ننتظر لين تتغير الحالة إلى ready
    if (_stockfish!.state.value != StockfishState.ready) {
      final completer = Completer<void>();
      void listener() {
        if (_stockfish!.state.value == StockfishState.ready) {
          completer.complete();
        }
      }

      _stockfish!.state.addListener(listener);
      await completer.future.timeout(
        const Duration(seconds: 10),
        onTimeout: () {},
      );
      _stockfish!.state.removeListener(listener);
    }
  }

  /// يضبط مستوى صعوبة المحرك (0 أسهل - 20 أقوى)
  void setSkillLevel(int level) {
    _sendCommand('setoption name Skill Level value $level');
  }

  /// يطلب من المحرك أفضل نقلة بناءً على وضع اللوحة الحالي (FEN)
  /// ويرجع النقلة بصيغة UCI مثل "e2e4"
  Future<String?> getBestMove(String fen, {int moveTimeMs = 800}) async {
    final sf = _stockfish;
    if (sf == null || sf.state.value != StockfishState.ready) return null;

    final completer = Completer<String?>();

    _outputSub?.cancel();
    _outputSub = sf.stdout.listen((line) {
      if (line.startsWith('bestmove')) {
        final parts = line.split(' ');
        final move = parts.length > 1 ? parts[1] : null;
        if (!completer.isCompleted) {
          completer.complete(move == '(none)' ? null : move);
        }
      }
    });

    _sendCommand('position fen $fen');
    _sendCommand('go movetime $moveTimeMs');

    return completer.future.timeout(
      Duration(milliseconds: moveTimeMs + 5000),
      onTimeout: () => null,
    );
  }

  void _sendCommand(String command) {
    final sf = _stockfish;
    if (sf == null) return;
    sf.stdin = command;
  }

  void dispose() {
    _outputSub?.cancel();
    _stockfish?.dispose();
    _stockfish = null;
  }
}
