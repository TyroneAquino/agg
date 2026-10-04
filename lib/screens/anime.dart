import 'package:agg/models/player_stats.dart';
import 'package:flutter/material.dart';
import 'package:agg/constants/app_themes.dart';
import 'package:agg/widgets/widgets.dart';
import 'package:agg/enums/enums.dart';
import 'package:agg/models/minigame.dart';
import 'package:agg/repositories/answer.dart';
import 'package:agg/models/anime_class.dart';
import 'package:agg/repositories/anime_repository.dart';
import 'package:agg/states/game_state.dart';
import 'package:agg/repositories/stats_repository.dart';

class AnimeScreen extends StatefulWidget {
  final GameState gameState;
  
  const AnimeScreen({
    super.key,
    required this.gameState
  });

  @override
  State<AnimeScreen> createState() => _AnimeScreenState();
}

class _AnimeScreenState extends State<AnimeScreen>{
  final MinigameType minigame = MinigameType.anime;

  final ScrollController _scrollController = ScrollController();

  bool isLoading = true;

  List<String> animeNames = [];
  List<String> dailyList = [];
  List<String> practiceList = [];

  PlayerStats? stats;
  String? yesterdayAnswer;

  @override
  void initState() {
    super.initState();
    initializeGame();
  }

  Future<void> initializeGame() async{
    try {
      final results = await Future.wait([
        AnimeRepository.getNames(),
        DailyAnswerRepository.getAnimeAnswer(),
        PracticeAnswer.getAnimeAnswer(),
        DailyAnswerRepository.getYesterdayAnimeAnswer()
      ]);

      final names = results[0] as List<String>;
      final dailyAnswer = results[1] as Anime;
      final practiceAnswer = results[2] as Anime;
      final yesterday = results[3] as Anime;

      final allStats = await StatsRepository.loadAll();
      final animeStats = allStats[StatsRepository.animeDaily]!;

      if (!mounted) return; 

      setState(() {
        animeNames = List.from(names);
        //inititalized the shared choices only once
        if(!widget.gameState.animeNamesInitialized){
          widget.gameState.dailyAnimeNames = List.from(names);
          widget.gameState.practiceAnimeNames = List.from(names);
          widget.gameState.animeNamesInitialized = true;
        }

        //restore the remaining choices
        dailyList = List.from(widget.gameState.dailyAnimeNames); 
        practiceList = List.from(widget.gameState.practiceAnimeNames); 

        // Keep the answer if it was already loaded.
        widget.gameState.dailyAnimeAnswer ??= dailyAnswer;
        widget.gameState.practiceAnimeAnswer ??= practiceAnswer;

        widget.gameState.animeStats = animeStats;
        stats = animeStats;

        yesterdayAnswer = yesterday.name;

        isLoading = false;
      });

      //checking

      print('DAILY LIST: ${dailyList.length}');
      print('ANSWER: ${dailyAnswer.name}');
      print('ANSWER: ${practiceAnswer.name}');
    
    }catch(e){
      print('Failed to initialize anime game: $e');

      if (!mounted) return; 

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> showCompletionDialog(DialogType dialogType, {Future<void> Function()? playAgain}) async {
    if(!mounted) return;

    await showDialog<void>(
      context: context, 
      barrierDismissible: false,
      builder: (context) => DialogBox(title: dialogType, stats: stats ?? widget.gameState.animeStats, gameState: widget.gameState, minigame: minigame, playAgain: playAgain,),
    );
  }

  Future<void> resetPractice() async {
    final newAnswer = await PracticeAnswer.getAnimeAnswer();

    if(!mounted) return;

    setState(() {
      widget.gameState.practiceAnimeGuesses.clear();
      widget.gameState.practiceAnimeAttempts = 0;
      widget.gameState.practiceAnimeCompleted = false;

      widget.gameState.practiceAnimeNames = List.from(animeNames); 
      practiceList = List.from(animeNames);

      widget.gameState.practiceAnimeAnswer = newAnswer;
    });
  }

  Future<void> addGuess(String guess) async {
    final mode = currentGameMode.value;

    if (mode == GameMode.daily && widget.gameState.dailyAnimeCompleted){
      debugPrint('Daily anime game already completed.');
      return;
    }

    if (mode == GameMode.practice && widget.gameState.practiceAnimeCompleted){
      return;
    }

    try{
      final anime = await AnimeRepository.getAnime(guess);

      if (!mounted) return; 

      final normalizedGuess = guess.trim().toLowerCase();

      if (mode == GameMode.daily){
        final answer = widget.gameState.dailyAnimeAnswer;
        if(answer == null) return;

        final isCorrect = normalizedGuess == answer.name.trim().toLowerCase();
        final nextAttempt = widget.gameState.dailyAnimeAttempts + 1;
        final isGameOver = isCorrect || nextAttempt >= 7;

        setState(() {
          widget.gameState.dailyAnimeGuesses.add(anime);

          widget.gameState.dailyAnimeNames.removeWhere( (name) => name.trim().toLowerCase() == normalizedGuess );

          dailyList = List.from(widget.gameState.dailyAnimeNames);

          widget.gameState.dailyAnimeAttempts = nextAttempt;  

          if(isGameOver){
            widget.gameState.dailyAnimeCompleted = true;
          }
        });

          debugPrint('========== DAILY ANIME GUESS ==========');
          debugPrint('Guess: ${anime.name}');
          debugPrint('Answer: ${answer.name}');
          debugPrint('Correct: $isCorrect');
          debugPrint('Attempt: $nextAttempt');
          debugPrint('Game over: $isGameOver');
          debugPrint('Daily completed: ${widget.gameState.dailyAnimeCompleted}',);

        if(!isGameOver) return;

        final puzzleDate = DateTime.now().toIso8601String().substring(0, 10);
        final puzzleKey = 'anime-$puzzleDate';

        debugPrint('Recording Daily stats: $puzzleKey');
        
        try{
          final PlayerStats updatedStats = await StatsRepository.recordResult(minigame: minigame, won: isCorrect, guesses: nextAttempt, puzzleKey: puzzleKey);
          debugPrint('Daily anime stats recorded successfully.');

          if(!mounted) return;  

          setState(() {
            stats = updatedStats;
            widget.gameState.animeStats = updatedStats;
          });
        } catch (e, stackTrace){
          debugPrint('FAILED to record Daily anime stats: $e');
          debugPrint('$stackTrace');
        }

        if(!mounted) return;  

        await showCompletionDialog(isCorrect ? DialogType.victory : DialogType.lose);
          
      } else if (mode == GameMode.practice){
        final answer = widget.gameState.practiceAnimeAnswer;
        if(answer == null) return;

        final isCorrect = normalizedGuess == answer.name.trim().toLowerCase();

        setState(() {
          widget.gameState.practiceAnimeGuesses.add(anime);

          widget.gameState.practiceAnimeNames.removeWhere( (name) => name.trim().toLowerCase() == normalizedGuess );

          practiceList = List.from(widget.gameState.practiceAnimeNames);

          widget.gameState.practiceAnimeAttempts++;

          if(isCorrect){
            widget.gameState.practiceAnimeCompleted = true;
          }
        });

        if(isCorrect){
          await showCompletionDialog(DialogType.practice, playAgain: resetPractice);
        }
      }

    } catch (e, stackTrace){
      debugPrint('Soundtrack initialization failed: $e');
      debugPrint('$stackTrace');

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    } 
  }
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        toolbarHeight: 96,
        title: Text('A.GG', style: AppTextTheme.screenLogo),  
        backgroundColor: AppColors.background,
        iconTheme: IconThemeData(color: AppColors.body),
        actions: [
          IconButton(
            onPressed: (){
              showDialog(
                context: context,
                builder: (context) {
                  return DialogBox(title:DialogType.settings);
                },
              );
            },
            icon: Icon(appIcons['settings'], size: 48, color: AppColors.subBorder,)
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(AppSpacing.bs),

        child: isLoading 
        ? const Center(
          child: CircularProgressIndicator(),
        )
        :SingleChildScrollView(
          child: ValueListenableBuilder<GameMode>(
            valueListenable: currentGameMode,
            builder: (context, currentMode, child){

              final names = currentMode == GameMode.daily ? dailyList : practiceList;
              final isCompleted = currentMode == GameMode.daily ? widget.gameState.dailyAnimeCompleted : widget.gameState.practiceAnimeCompleted;

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children:[

                  //Top Interface
                  TopInterface(minigame: minigame, stats: widget.gameState.animeStats!),
                  if (currentMode != GameMode.practice)...[
                    if(widget.gameState.dailyAnimeAttempts == 0)Text(getMinigame(minigame).instruction, style: AppTextTheme.bodyText),
                  ],
                  if (currentMode != GameMode.daily) ...[
                    ClueBox(
                      minigame: minigame, 
                      firstClue: widget.gameState.practiceAnimeAnswer?.status ?? '', 
                      secondClue: widget.gameState.practiceAnimeAnswer?.synopsis ?? '',
                      attempt: widget.gameState.practiceAnimeAttempts,
                    ),
                  ],

                  SizedBox(height: AppSpacing.xl),

                  //row of guesses for daily mode
                  if(currentMode == GameMode.daily)
                    if (widget.gameState.dailyAnimeGuesses.isNotEmpty) ...[  
                      Scrollbar(
                        controller: _scrollController,
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          controller: _scrollController,
                          child: Padding(
                            padding: EdgeInsets.only(bottom:36),
                            child: Column(
                              spacing: AppSpacing.bs,
                              children: [
                                ...widget.gameState.dailyAnimeGuesses.map(
                                  (anime) => GuessRowAnime(guess: anime, answer: widget.gameState.dailyAnimeAnswer!),
                                ),
                              ],
                            ),
                          ),    
                        ),
                      ),
                    ],

                  //row of guesses for practice mode
                  if(currentMode == GameMode.practice)
                    if (widget.gameState.practiceAnimeGuesses.isNotEmpty) ...[  
                      Scrollbar(
                        controller: _scrollController,
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          controller: _scrollController,
                          child: Padding(
                            padding: EdgeInsets.only(bottom:36),
                            child: Column(
                              spacing: AppSpacing.bs,
                              children: [
                                ...widget.gameState.practiceAnimeGuesses.map(
                                  (anime) => GuessRowAnime(guess: anime, answer: widget.gameState.practiceAnimeAnswer!),
                                ),
                              ],
                            ),
                          ),    
                        ),
                      ),
                    ],
  
                  //TExtbox
                  if(!isCompleted)
                    Textbox(minigame: minigame, names:names, onSubmit: addGuess),

                  SizedBox(height: AppSpacing.xl),

                  //Clue Indicator
                  ClueIndicator(minigame: minigame),
                  if (currentMode != GameMode.practice)...[
                    SizedBox(height:AppSpacing.xl),
                    Text('Yesterday\'s anime was ${yesterdayAnswer ?? '...'}', style: AppTextTheme.bodyText, textAlign: TextAlign.center),
                  ],

                  SizedBox(height:AppSpacing.xl),
                  MinigameButton(minigame: MinigameType.character, gameState: widget.gameState),
                ]
              );
            }
          ),
        ),
      ),
    );
  }

}
