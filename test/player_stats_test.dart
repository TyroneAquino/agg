import 'package:flutter_test/flutter_test.dart';
import 'package:agg/models/player_stats.dart';

void main() {
  test('win rate is solved divided by played', () {
    final s = PlayerStats(puzzlesPlayed: 4, puzzlesSolved: 3);
    expect(s.winRate, 75);
  });

  test('average guess counts losses too', () {
    // one win in 3 guesses + one loss at 7 guesses
    final s = PlayerStats(puzzlesPlayed: 2, puzzlesSolved: 1, totalGuesses: 10);
    expect(s.averageGuess, 5);
  });

  test('empty stats do not divide by zero', () {
    final s = PlayerStats();
    expect(s.winRate, 0);
    expect(s.averageGuess, 0);
  });

  test('toJson and fromJson round-trip', () {
    final s = PlayerStats(
      puzzlesPlayed: 2,
      puzzlesSolved: 1,
      totalGuesses: 10,
      lastRecordedPuzzle: 'anime-2026-10-08',
    );
    expect(PlayerStats.fromJson(s.toJson()).toJson(), s.toJson());
  });
}