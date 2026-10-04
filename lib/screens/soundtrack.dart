import 'package:flutter/material.dart';
import 'package:agg/constants/app_themes.dart';
import 'package:agg/widgets/widgets.dart';
import 'package:agg/enums/enums.dart';
import 'package:agg/states/game_state.dart';
import 'package:agg/repositories/answer.dart';
import 'package:agg/models/soundtrack_class.dart';
import 'package:agg/repositories/soundtrack_repository.dart';
import 'package:agg/models/player_stats.dart';
import 'package:agg/repositories/stats_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class SoundtrackScreen extends StatefulWidget {

  final GameState gameState;
  const SoundtrackScreen({
    super.key, 
    required this.gameState
  });

  @override
  State<SoundtrackScreen> createState() => _SoundtrackScreenState();
}

class _SoundtrackScreenState extends State<SoundtrackScreen>{
  final MinigameType minigame = MinigameType.soundtrack;

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
    try{
      final results = await Future.wait([
        SoundtrackRepository.getNames(),
        DailyAnswerRepository.getSoundtrackAnswer(),
        PracticeAnswer.getSoundtrackAnswer(),
        DailyAnswerRepository.getYesterdaySoundtrackAnswer(),
      ]);

      debugPrint('REPOSITORY NAMES: ${results.length}');
      debugPrint('REPOSITORY SAMPLE: ${results.take(5).toList()}');

      final names = results[0] as List<String>;
      debugPrint('REPOSITORY NAMES COUNT: ${names.length}');
      debugPrint('REPOSITORY SAMPLE: ${names.take(5).toList()}');
      Set<String> uniqueNames = names.toSet(); 
      final finalNames = uniqueNames.toList();
      debugPrint('UNIQUE NAMES COUNT: ${finalNames.length}');
      final dailyAnswer = results[1] as Soundtrack;
      final practiceAnswer = results[2] as Soundtrack;
      debugPrint('Daily Answer: ${dailyAnswer.anime}');
      debugPrint('Practice Answer: ${practiceAnswer.anime}');
      final user = Supabase.instance.client.auth.currentUser;
      final yesterday = results[3] as Soundtrack;

      debugPrint('CURRENT USER: ${user?.id}');
      debugPrint('CURRENT SESSION: ${Supabase.instance.client.auth.currentSession != null}');
      final allStats = await StatsRepository.loadAll();
      final soundtrackStats = allStats[StatsRepository.soundtrackDaily]!;
      
      if (!mounted) return; 

      setState(() {
        animeNames = List<String>.from(finalNames);

        debugPrint('REPOSITORY NAMES COUNT: ${names.length}');
        debugPrint('REPOSITORY SAMPLE: ${names.take(5).toList()}');

        debugPrint('FINAL NAMES: ${finalNames.length}');
        debugPrint('INITIALIZED FLAG: ${widget.gameState.soundtrackNamesInitialized}');
        debugPrint('SHARED DAILY BEFORE: ${widget.gameState.dailySoundtrackNames.length}');
        debugPrint('SHARED PRACTICE BEFORE: ${widget.gameState.practiceSoundtrackNames.length}');

        // Initialize shared choices if they haven't been initialized
        // OR if the existing lists are unexpectedly empty.
        if (!widget.gameState.soundtrackNamesInitialized ||
            widget.gameState.dailySoundtrackNames.isEmpty ||
            widget.gameState.practiceSoundtrackNames.isEmpty) {

          widget.gameState.dailySoundtrackNames = List.from(finalNames);
          widget.gameState.practiceSoundtrackNames = List.from(finalNames);

          widget.gameState.soundtrackNamesInitialized = true;
        }

        dailyList = List.from(widget.gameState.dailySoundtrackNames);
        practiceList = List.from(widget.gameState.practiceSoundtrackNames);

        widget.gameState.dailySoundtrackAnswer ??= dailyAnswer;
        widget.gameState.practiceSoundtrackAnswer ??= practiceAnswer;

        widget.gameState.soundtrackStats = soundtrackStats;
        stats = soundtrackStats;

        yesterdayAnswer = yesterday.anime;

        isLoading = false;
      });

      setState(() {
        animeNames = List.from(finalNames);
        //inititalized the shared choices only once
        if(!widget.gameState.soundtrackNamesInitialized){
          widget.gameState.dailySoundtrackNames = List.from(finalNames);
          widget.gameState.practiceSoundtrackNames = List.from(finalNames);
          widget.gameState.soundtrackNamesInitialized = true;
        }

        //restore the remaining choices
        dailyList = List.from(widget.gameState.dailySoundtrackNames);
        practiceList = List.from(widget.gameState.practiceSoundtrackNames);

        // Keep the answer if it was already loaded.
        widget.gameState.dailySoundtrackAnswer ??= dailyAnswer;
        widget.gameState.practiceSoundtrackAnswer ??= practiceAnswer;

        widget.gameState.soundtrackStats = soundtrackStats;
        stats = soundtrackStats;

        isLoading = false;

      });

    }catch(e, stackTrace){
      debugPrint('INITIALIZATION ERROR: $e');
       debugPrint('$stackTrace');
      if (!mounted) return; 

      setState(() {
        isLoading = false;
      });
    }
    debugPrint('INITIALIZATION COMPLETE');
    debugPrint('DAILY LIST: ${dailyList.length}');
    debugPrint('PRACTICE LIST: ${practiceList.length}');
  }

  Future<void> showCompletionDialog(DialogType dialogType, {Future<void> Function()? playAgain}) async {
    if(!mounted) return;

    await showDialog<void>(
      context: context, 
      barrierDismissible: false,
      builder: (context) => DialogBox(
        title: dialogType, 
        stats: stats ?? widget.gameState.soundtrackStats, 
        gameState: widget.gameState, 
        minigame: minigame, 
        playAgain: playAgain,
        soundtrack: currentGameMode.value == GameMode.daily ? widget.gameState.dailySoundtrackAnswer : widget.gameState.practiceSoundtrackAnswer
      ),
    );
  }

  Future<void> resetPractice() async {
    final newAnswer = await PracticeAnswer.getSoundtrackAnswer();

    if(!mounted) return;

    setState(() {
      widget.gameState.practiceSoundtrackGuesses.clear();
      widget.gameState.practiceSoundtrackAttempts = 0;
      widget.gameState.practiceSoundtrackCompleted = false;

      widget.gameState.practiceSoundtrackNames = List.from(animeNames); 
      practiceList = List.from(animeNames);

      widget.gameState.practiceSoundtrackAnswer = newAnswer;
    });
  }

  Future<void> addGuess(String guess) async {
    final mode = currentGameMode.value;

    if (mode == GameMode.daily && widget.gameState.dailySoundtrackCompleted){
      debugPrint('Daily anime game already completed.');
      return;
    }

    if (mode == GameMode.practice && widget.gameState.practiceSoundtrackCompleted){
      return;
    }

    try{
      final soundtrack = await SoundtrackRepository.getSoundtrack(guess);

      if (!mounted) return; 

      final normalizedGuess = guess.trim().toLowerCase();

      if(mode == GameMode.daily){
        final answer = widget.gameState.dailySoundtrackAnswer;
        if(answer == null) return;

        final isCorrect = normalizedGuess == answer.anime.trim().toLowerCase();
        final nextAttempt = widget.gameState.dailySoundtrackAttempts + 1;
        final isGameOver = isCorrect || nextAttempt >= 7;
      

      setState(() {
        widget.gameState.dailySoundtrackGuesses.add(soundtrack);

        widget.gameState.dailySoundtrackNames.removeWhere( (name) => name.trim().toLowerCase() == normalizedGuess );

        dailyList = List.from(widget.gameState.dailySoundtrackNames);

        widget.gameState.dailySoundtrackAttempts = nextAttempt;  

        if(isGameOver){
          widget.gameState.dailySoundtrackCompleted = true;
        }
        });

        if(!isGameOver) return;

        final puzzleDate = DateTime.now().toIso8601String().substring(0, 10);
        final puzzleKey = 'soundtrack-$puzzleDate';

        try{
          final PlayerStats updatedStats = await StatsRepository.recordResult(minigame: minigame, won: isCorrect, guesses: nextAttempt, puzzleKey: puzzleKey);

          if(!mounted) return;  

          setState(() {
            stats = updatedStats;
            widget.gameState.soundtrackStats = updatedStats;
          });

        }  catch (e, stackTrace){
          debugPrint('FAILED to record Daily anime stats: $e');
          debugPrint('$stackTrace');
        }

        if(!mounted) return;  

        await showCompletionDialog(isCorrect ? DialogType.victory : DialogType.lose);

      }else if (mode == GameMode.practice){
        final answer = widget.gameState.practiceSoundtrackAnswer;
        if(answer == null) return;

        final isCorrect = normalizedGuess == answer.anime.trim().toLowerCase();

        setState(() {
          widget.gameState.practiceSoundtrackGuesses.add(soundtrack);

          widget.gameState.practiceSoundtrackNames.removeWhere( (name) => name.trim().toLowerCase() == normalizedGuess );

          practiceList = List.from(widget.gameState.practiceSoundtrackNames);

          widget.gameState.practiceSoundtrackAttempts++;

          if(isCorrect){
            widget.gameState.practiceSoundtrackCompleted = true;
          }
        });

        if(isCorrect){
          await showCompletionDialog(DialogType.practice, playAgain: resetPractice);
        }
      }
    }catch(e, stackTrace){
      debugPrint('Failed to initialize soundtrack game: $e');
      debugPrint('$stackTrace');
      if (!mounted) return;
      setState(() { isLoading = false; });
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
              final isCompleted = currentMode == GameMode.daily ? widget.gameState.dailySoundtrackCompleted : widget.gameState.practiceSoundtrackCompleted;

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [

                  TopInterface(minigame:  minigame, stats: widget.gameState.soundtrackStats!),

                  SizedBox(height: AppSpacing.xl),

                  ClueBox(
                    minigame: minigame, 
                    firstClue: widget.gameState.practiceSoundtrackAnswer?.type ?? '', 
                    secondClue: widget.gameState.practiceSoundtrackAnswer?.artist ?? '',  
                    attempt: widget.gameState.practiceSoundtrackAttempts,
                    soundtrack: currentMode == GameMode.daily ? widget.gameState.dailySoundtrackAnswer : widget.gameState.practiceSoundtrackAnswer
                  ),

                  SizedBox(height: AppSpacing.xl),

                  if(currentMode == GameMode.daily) ...[
                    if(widget.gameState.dailySoundtrackGuesses.isNotEmpty)
                      Column(
                        spacing: AppSpacing.bs,
                        children: [
                          ...widget.gameState.dailySoundtrackGuesses.map(
                            (soundtrack) => GuessColumnSoundtrack(guess: soundtrack, answer: widget.gameState.dailySoundtrackAnswer!)
                          )
                        ],
                      ),
                  ],

                  if(currentMode == GameMode.practice) ...[
                    if(widget.gameState.practiceSoundtrackGuesses.isNotEmpty)
                      Column(
                        spacing: AppSpacing.bs,
                        children: [
                          ...widget.gameState.practiceSoundtrackGuesses.map(
                            (soundtrack) => GuessColumnSoundtrack(guess: soundtrack, answer: widget.gameState.practiceSoundtrackAnswer!)
                          )
                        ],
                      ),
                  ],
                    
                  SizedBox(height: AppSpacing.md),

                  if(!isCompleted)
                    Textbox(minigame: minigame, names:names, onSubmit: addGuess),
                  
                  SizedBox(height: AppSpacing.xl),

                  ClueIndicator(minigame: minigame),
                  if (currentMode != GameMode.practice) ...[
                    SizedBox(height: AppSpacing.xl),
                    Text('Yesterday\'s soundtrack belongs to ${yesterdayAnswer ?? '...'}', style: AppTextTheme.bodyText, textAlign: TextAlign.center)
                  ],
                ],
              );
            }
          ), 
        ),
      ),
    );
  }
}