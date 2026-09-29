class PlayerStats{
  int puzzlesPlayed;
  int puzzlesSolved;
  int totalGuesses;
  int oneShots;
  int currentStreak;
  int longestStreak;
  String? lastRecordedPuzzle;

  PlayerStats({
    this.puzzlesPlayed = 0,
    this.puzzlesSolved = 0,
    this.totalGuesses = 0,
    this.oneShots = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastRecordedPuzzle
  });

  double get winRate => puzzlesPlayed == 0 ? 0 : puzzlesSolved/puzzlesPlayed * 100;

  double get averageGuess => totalGuesses == 0 ? 0 : totalGuesses/puzzlesSolved;

  Map<String, dynamic> toJson() => {  
    'puzzlesPlayed':puzzlesPlayed,
    'puzzlesSolved':puzzlesSolved,
    'totalGuesses':totalGuesses,
    'oneShots':oneShots,
    'currentStreak':currentStreak,
    'longestStreak':longestStreak,
    'lastRecordedPuzzle': lastRecordedPuzzle,
  };

  factory PlayerStats.fromJson(Map<String, dynamic>? json){
    return PlayerStats(
      puzzlesPlayed: json?['puzzlesPlayed'] ?? 0,
      puzzlesSolved: json?['puzzlesSolved'] ?? 0,
      totalGuesses: json?['totalGuesses'] ?? 0,
      oneShots: json?['oneShots'] ?? 0,
      currentStreak: json?['currentStreak'] ?? 0,
      longestStreak: json?['longestStreak'] ?? 0,
      lastRecordedPuzzle: json?['lastRecordedPuzzle'],
    );
  }

}