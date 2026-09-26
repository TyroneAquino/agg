import 'package:flutter/material.dart';
import 'package:agg/constants/app_themes.dart';
import 'package:agg/widgets/widgets.dart';
import 'package:agg/enums/enums.dart';
import 'package:agg/models/minigame.dart';
import 'package:agg/models/answer.dart';
import 'package:agg/models/anime_class.dart';
import 'package:agg/models/anime_repository.dart';
import 'package:agg/states/game_state.dart';

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

  List<String> dailyList = [];
  List<String> practiceList = [];

  @override
  void initState() {
    super.initState();
    initializeGame();
  }

  Future<void> initializeGame() async{
    try {
      final results = await Future.wait([
        AnimeRepository.getNames(),
        DailyAnswerAnime.getAnswer(),
        PracticeAnswerAnime.getAnswer()
      ]);

      final names = results[0] as List<String>;
      final dailyAnswer = results[1] as Anime;
      final practiceAnswer = results[2] as Anime;

      if (!mounted) return; 

      setState(() {
        
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

  Future<void> addGuess(String guess) async {
    final mode = currentGameMode.value;

    if (mode == GameMode.daily && widget.gameState.dailyAnimeCompleted){
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

        setState(() {
          widget.gameState.dailyAnimeGuesses.add(anime);

          widget.gameState.dailyAnimeNames.removeWhere( (name) => name.trim().toLowerCase() == normalizedGuess );

          dailyList = List.from(widget.gameState.dailyAnimeNames);

          widget.gameState.dailyAnimeAttempts++;

          if(isCorrect || widget.gameState.dailyAnimeAttempts >= 7){
            widget.gameState.dailyAnimeCompleted = true;
          }

          print('DAILY COMPLETED AFTER GUESS: ${widget.gameState.dailyAnimeCompleted}');

        }); 

      } else if (mode == GameMode.practice){
        final answer = widget.gameState.practiceAnimeAnswer;
        if(answer == null) return;

        final isCorrect = normalizedGuess == answer.name.trim().toLowerCase();

        setState(() {
          widget.gameState.practiceAnimeGuesses.add(anime);

          widget.gameState.practiceAnimeNames.removeWhere( (name) => name.trim().toLowerCase() == normalizedGuess );

          practiceList = List.from(widget.gameState.practiceAnimeNames);

          if(isCorrect){
            widget.gameState.practiceAnimeCompleted = true;
          }
        });
      }

    } catch (e){
      print('Failed to get anime guess: $e');
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
                  TopInterface(minigame: minigame,),
                  if (currentMode != GameMode.practice)...[
                    Text(getMinigame(minigame).instruction, style: AppTextTheme.bodyText),
                  ],
                  if (currentMode != GameMode.daily) ...[
                    ClueBox(minigame: minigame),
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
                    Text('Yesterday\'s answer was ...', style: AppTextTheme.bodyText),
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

/*void handleGuess(String guess) {

  if(!mounted) return;

  print('GUESS: $guess');
  print('ANSWER: ${widget.gameState.animeAnswer?.name}');

  final isCorrect =
      guess.trim().toLowerCase() == widget.gameState.animeAnswer?.name.toLowerCase();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        isCorrect ? 'Correct!' : 'Try Again',
      ),
    ),
  );
} */

}
