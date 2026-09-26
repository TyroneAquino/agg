import 'package:agg/models/character_class.dart';
import 'package:flutter/material.dart';
import 'package:agg/constants/app_themes.dart';
import 'package:agg/widgets/widgets.dart';
import 'package:agg/enums/enums.dart';
import 'package:agg/models/minigame.dart';
import 'package:agg/models/answer.dart';
import 'package:agg/models/character_repository.dart';
import 'package:agg/states/game_state.dart';

class CharacterScreen extends StatefulWidget {
  final GameState gameState;

  const CharacterScreen({
    super.key,
    required this.gameState
  });

  @override
  State<CharacterScreen> createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen>{
  final MinigameType minigame = MinigameType.character;

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
        CharacterRepository.getNames(),
        DailyAnswerCharacter.getAnswer(),
        PracticeAnswerCharacter.getAnswer()
      ]);

      final names = results[0] as List<String>;
      final dailyAnswer = results[1] as Character;
      final practiceAnswer = results[2] as Character;

      if (!mounted) return; 

      setState(() {
        
        //inititalized the shared choices only once
        if(!widget.gameState.characterNamesInitialized){
          widget.gameState.dailyCharacterNames = List.from(names);
          widget.gameState.practiceCharacterNames = List.from(names);
          widget.gameState.characterNamesInitialized = true;
        }

        //restore the remaining choices
        dailyList = List.from(widget.gameState.dailyCharacterNames); 
        practiceList =  List.from(widget.gameState.practiceCharacterNames); 

        // Keep the answer if it was already loaded.
        widget.gameState.dailyCharacterAnswer ??= dailyAnswer;
        widget.gameState.practiceCharacterAnswer ??= practiceAnswer;

        isLoading = false;
      });

      //checking
      print('DAILY LIST: ${dailyList.length}');
      print('ANSWER: ${dailyAnswer.name}');
      print('ANSWER: ${practiceAnswer.name}');
    
    }catch(e){
      print('Failed to initialize character game: $e');

      if (!mounted) return; 

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> addGuess(String guess) async {
    final mode = currentGameMode.value;

    if (mode == GameMode.daily && widget.gameState.dailyCharacterCompleted){
      return;
    }

    if (mode == GameMode.practice && widget.gameState.practiceCharacterCompleted){
      return;
    }

    try{
      final character = await CharacterRepository.getCharacter(guess);

      if (!mounted) return; 

      final normalizedGuess = guess.trim().toLowerCase();

      if (mode == GameMode.daily){
        final answer = widget.gameState.dailyCharacterAnswer;
        if(answer == null) return;

        final isCorrect = normalizedGuess == answer.name.trim().toLowerCase();

        setState(() {
          widget.gameState.dailyCharacterGuesses.add(character);

          widget.gameState.dailyCharacterNames.removeWhere( (name) => name.trim().toLowerCase() == guess.trim().toLowerCase() );

          dailyList = List.from(widget.gameState.dailyCharacterNames);

          widget.gameState.dailyCharacterAttempts++;

          if(isCorrect || widget.gameState.dailyCharacterAttempts >= 7){
            widget.gameState.dailyCharacterCompleted = true;
          }

        });
      
      } else if (mode == GameMode.practice){
        final answer = widget.gameState.practiceCharacterAnswer;
        if(answer == null) return;

        final isCorrect = normalizedGuess == answer.name.trim().toLowerCase();

        setState(() {
          widget.gameState.practiceCharacterGuesses.add(character);

          widget.gameState.practiceCharacterNames.removeWhere( (name) => name.trim().toLowerCase() == guess.trim().toLowerCase() );

          practiceList = List.from(widget.gameState.practiceCharacterNames);

          if(isCorrect){
            widget.gameState.practiceCharacterCompleted = true;
          }

        });

      }

    } catch (e){
      print('Failed to get character guess: $e');
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
            icon: Icon(appIcons['settings'], size: 48, color: AppColors.subBorder)
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
              final isCompleted = currentMode == GameMode.daily ? widget.gameState.dailyCharacterCompleted : widget.gameState.practiceCharacterCompleted;

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children:[

                  //Top Interface
                  TopInterface(minigame: minigame),
                  if (currentMode != GameMode.practice)...[
                    Text(getMinigame(minigame).instruction, style: AppTextTheme.bodyText),
                  ],
                  if (currentMode != GameMode.daily) ...[
                    ClueBox(minigame: minigame),
                  ], 

                  SizedBox(height: AppSpacing.xl),

                  //row of guesses for daily
                  if(currentMode == GameMode.daily)
                    if (widget.gameState.dailyCharacterGuesses.isNotEmpty) ...[  
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
                                ...widget.gameState.dailyCharacterGuesses.map(
                                  (character) => GuessRowCharacter(guess: character, answer: widget.gameState.dailyCharacterAnswer!),
                                ),
                              ],
                            ),
                          ),    
                        ),
                      ),
                    ],

                  //row of guesses for practice
                  if(currentMode == GameMode.practice)
                    if (widget.gameState.practiceCharacterGuesses.isNotEmpty) ...[  
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
                                ...widget.gameState.practiceCharacterGuesses.map(
                                  (character) => GuessRowCharacter(guess: character, answer: widget.gameState.practiceCharacterAnswer!),
                                ),
                              ],
                            ),
                          ),    
                        ),
                      ),
                    ],

                  //Textbox
                  if(!isCompleted)
                    Textbox(minigame: minigame, names:names, onSubmit: addGuess),

                  SizedBox(height: AppSpacing.xl),

                  ClueIndicator(minigame: minigame),
                  if (currentMode != GameMode.practice)...[
                    SizedBox(height:AppSpacing.xl),
                    Text('Yesterday\'s answer was ...', style: AppTextTheme.bodyText),
                  ],
                  SizedBox(height:AppSpacing.xl),
                  MinigameButton(minigame: MinigameType.soundtrack, gameState: widget.gameState),
                ],
              );
            }
          )
        ),
      ),
    );
  }

/* void handleGuess(String guess) {
  print('GUESS: $guess');
  print('ANSWER: ${widget.gameState.characterAnswer?.name}');

  final isCorrect =
      guess.trim().toLowerCase() == widget.gameState.characterAnswer?.name.toLowerCase();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        isCorrect ? 'Correct!' : 'Try Again',
      ),
    ),
  );
} */
}