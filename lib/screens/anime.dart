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

  bool guessed = false;
  bool isLoading = true;

  List<String> animeNames = [];
  List<String> dailyList = [];

  @override
  void initState() {
    super.initState();
    print('AnimeScreen initState: ${identityHashCode(this)}');
    initializeGame();
  }

  Future<void> initializeGame() async{
    try {
      final results = await Future.wait([
        AnimeRepository.getNames(),
        DailyAnswerAnime.getAnswer()
      ]);

      final names = results[0] as List<String>;
      final answer = results[1] as Anime;

      if (!mounted) return; 

      setState(() {
        
        //inititalized the shared choices only once
        if(!widget.gameState.animeNamesInitialized){
          widget.gameState.dailyAnimeNames = List.from(names);
          widget.gameState.animeNamesInitialized = true;
        }

        //restore the remaining choices
        dailyList = List.from(widget.gameState.dailyAnimeNames); 

        // Keep the answer if it was already loaded.
        widget.gameState.animeAnswer ??= answer;

        isLoading = false;
      });

      //checking
      print('ANIME NAMES: ${animeNames.length}'); 
      print('DAILY LIST: ${dailyList.length}');
      print('ANSWER: ${answer.name}');
    
    }catch(e){
      print('Failed to initialize anime game: $e');

      if (!mounted) return; 

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> addGuess(String guess) async {
    try{
      final anime = await AnimeRepository.getAnime(guess);

      if (!mounted) return; 

    setState(() {
      widget.gameState.animeGuesses.add(anime);

      widget.gameState.dailyAnimeNames.removeWhere( (name) => name.trim().toLowerCase() == guess.trim().toLowerCase() );

      dailyList = List.from(widget.gameState.dailyAnimeNames);
    });

    if (!mounted) return; 

    //handleGuess(guess);

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

                  //row of guesses
                  if (widget.gameState.animeGuesses.isNotEmpty) ...[  
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
                              ...widget.gameState.animeGuesses.map(
                                (anime) => GuessRowAnime(guess: anime, answer: widget.gameState.animeAnswer!),
                              ),
                            ],
                          ),
                        ),    
                      ),
                    ),
                  ],

                  //TExtbox
                  Textbox(minigame: minigame, names:dailyList, onSubmit: addGuess),

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
