import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';
import 'package:chess/chess.dart' as chess_lib;

import '../l10n/app_strings.dart';
import '../models/game_mode.dart';
import '../services/stockfish_service.dart';
import '../theme/app_theme.dart';
import '../widgets/game_over_dialog.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({
    super.key,
    required this.mode,
    this.difficulty,
    this.playerIsWhite = true,
  });

  final GameMode mode;
  final Difficulty? difficulty;
  final bool playerIsWhite;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final ChessBoardController _controller;
  final StockfishService _engine = StockfishService();

  bool _engineReady = false;
  bool _computerThinking = false;
  bool _gameEnded = false;

  bool get _vsComputer => widget.mode == GameMode.vsComputer;

  @override
  void initState() {
    super.initState();
    _controller = ChessBoardController();
    _controller.addListener(_onBoardChanged);

    if (_vsComputer) {
      _initEngine();
    }
  }

  Future<void> _initEngine() async {
    await _engine.init();
    if (!mounted) return;
    setState(() => _engineReady = true);
    _engine.setSkillLevel(widget.difficulty?.skillLevel ?? 8);

    // إذا اللاعب اختار أسود، الكمبيوتر (أبيض) يبدأ أول نقلة
    if (!widget.playerIsWhite) {
      _maybeTriggerEngineMove();
    }
  }

  void _onBoardChanged() {
    if (_gameEnded) return;
    _checkGameOver();
    if (_vsComputer) {
      _maybeTriggerEngineMove();
    }
  }

  bool get _isEnginesTurn {
    final turn = _controller.game.turn; // chess_lib.Color.WHITE / BLACK
    final engineIsWhite = !widget.playerIsWhite;
    return (turn == chess_lib.Color.WHITE && engineIsWhite) ||
        (turn == chess_lib.Color.BLACK && !engineIsWhite);
  }

  Future<void> _maybeTriggerEngineMove() async {
    if (!_vsComputer || !_engineReady || _gameEnded || _computerThinking) {
      return;
    }
    if (!_isEnginesTurn) return;
    if (_controller.game.game_over) return;

    setState(() => _computerThinking = true);

    final fen = _controller.game.fen;
    final moveTime = widget.difficulty?.moveTimeMs ?? 800;
    final bestMove = await _engine.getBestMove(fen, moveTimeMs: moveTime);

    if (!mounted) return;
    setState(() => _computerThinking = false);

    if (bestMove != null && bestMove.length >= 4) {
      _applyUciMove(bestMove);
    }
  }

  void _applyUciMove(String uci) {
    final from = uci.substring(0, 2);
    final to = uci.substring(2, 4);
    final promo = uci.length > 4 ? uci.substring(4, 5) : null;

    final current = _controller.game;
    current.move({
      'from': from,
      'to': to,
      if (promo != null) 'promotion': promo,
    });

    // ننشئ نسخة جديدة عشان نضمن تحديث واجهة اللوحة
    final refreshed = chess_lib.Chess();
    refreshed.load(current.fen);

    setState(() {
      _controller.game = refreshed;
    });

    _checkGameOver();
  }

  void _checkGameOver() {
    final game = _controller.game;
    if (!game.game_over || _gameEnded) return;

    _gameEnded = true;
    String title;
    String message;

    if (game.in_checkmate) {
      final winnerIsWhite = game.turn == chess_lib.Color.BLACK;
      title = AppStrings.checkmate;
      message = winnerIsWhite ? AppStrings.whiteWins : AppStrings.blackWins;
    } else if (game.in_stalemate) {
      title = AppStrings.draw;
      message = AppStrings.stalemate;
    } else {
      title = AppStrings.draw;
      message = AppStrings.draw;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      GameOverDialog.show(
        context,
        title: title,
        message: message,
        onPlayAgain: _resetGame,
      );
    });
  }

  void _resetGame() {
    setState(() {
      _controller.resetBoard();
      _gameEnded = false;
    });
    if (_vsComputer && !widget.playerIsWhite) {
      _maybeTriggerEngineMove();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onBoardChanged);
    _engine.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final boardOrientation =
        widget.playerIsWhite ? PlayerColor.white : PlayerColor.black;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _vsComputer ? AppStrings.playVsComputer : AppStrings.playVsFriend,
        ),
        actions: [
          IconButton(
            tooltip: AppStrings.newGame,
            onPressed: _resetGame,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            _StatusBar(
              vsComputer: _vsComputer,
              engineReady: _engineReady,
              thinking: _computerThinking,
              whiteTurn: _controller.game.turn == chess_lib.Color.WHITE,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ChessBoard(
                    controller: _controller,
                    boardColor: BoardColor.brown,
                    boardOrientation: boardOrientation,
                    enableUserMoves: _vsComputer ? !_computerThinking : true,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        setState(() => _controller.undoMove());
                      },
                      icon: const Icon(Icons.undo),
                      label: const Text(AppStrings.undoMove),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _resetGame,
                      icon: const Icon(Icons.refresh),
                      label: const Text(AppStrings.newGame),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBar extends StatelessWidget {
  const _StatusBar({
    required this.vsComputer,
    required this.engineReady,
    required this.thinking,
    required this.whiteTurn,
  });

  final bool vsComputer;
  final bool engineReady;
  final bool thinking;
  final bool whiteTurn;

  @override
  Widget build(BuildContext context) {
    String text;
    if (vsComputer && !engineReady) {
      text = '... جاري تجهيز المحرك';
    } else if (thinking) {
      text = AppStrings.computerThinking;
    } else {
      text = whiteTurn ? AppStrings.whiteTurn : AppStrings.blackTurn;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (thinking)
            const Padding(
              padding: EdgeInsets.only(left: 8),
              child: SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          Text(
            text,
            style: const TextStyle(
              color: AppColors.primaryGreen,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
