# Badge: Builds with Flutter and AI

## The three sections of `AI-USAGE.md`

### 1. How I used AI (35 points)

At least six entries. One per real use. Each entry says:

- July 30, 2026 ChatGPT
- I asked for a theme for a anime-based guessing game with three minigames.
- One of the suggestion is a arcade style theme with 15 colors and 2 fonts.
- I kept the two fonts it gave and for the colors I kept 7, changed 3, remove 2, and added 4,
- **[a link to the commit where that work landed](https://github.com/TyroneAquino/agg/commit/dbca5580a8f094c896a67029fa7406e77ab21105)**

- September 20, 2026 ChatGPT
- I how to use Google Fonts on flutter.
- It gave me the steps needed to get Google fonts and syntax on how to use it.
- I followed the steps and added the needed fonts and their own design.
- **[a link to the commit where that work landed](https://github.com/TyroneAquino/agg/commit/dbca5580a8f094c896a67029fa7406e77ab21105)**

- September 24 2026, ChatGPT
- Textbox(minigame: minigame, controller: controller)i want to add a validator that accepts inputs from the data
- A fully working autocomplete textbox.
- I kept the entire structure but added so that the already inputted answer can't be inputted anymore.
- **[a link to the commit where that work landed](https://github.com/TyroneAquino/agg/commit/d79fb354828ad49987c573519d938e159dbd71c2)**

- September 25 2026, ChatGPT and Gemini
- I asked if I can use the dynamic type to store the records of an anime data to use this to compare them to the actual answer.
- Gemini replied that using the T for dynamic types is better and ChatGPT fixes the code.
- I did the initial code that compares string to string, int to int, etc. and ChatGPT cleans the code and I use the code to implement it into the other game.
- **[a link to the commit where that work landed](https://github.com/TyroneAquino/agg/commit/d79fb354828ad49987c573519d938e159dbd71c2)**

- September 24 2026, ChatGPT
- Why cant my terminal find supabase_url and why null is being returned by the database
- It turns out the application can reach the database but the database has no policy yet, so ChatGPT gave me a query that allows the table to be read and ChatGPT suggested to changed that attibute that can be null and to be not required.
- I kept the query and used it with the other two game databases and I changed that attribute so it can be null on for that record.
- **[a link to the commit where that work landed](https://github.com/TyroneAquino/agg/commit/d79fb354828ad49987c573519d938e159dbd71c2)**

- September 24 2026, ChatGPT
- How to connect to Supabase without hardcoding the supabase url and publishable key
- Two options using .env or Github actions.
- I used Github action and secrets.
- **[a link to the commit where that work landed](https://github.com/TyroneAquino/agg/commit/d79fb354828ad49987c573519d938e159dbd71c2)**

- September 27 2026, ChatGPT
- How to persist data across all screens.
- A new file that stores the state of each game.
- I kept the entire structure, added some data that must persist and added the soundtrack state.
- **[a link to the commit where that work landed](https://github.com/TyroneAquino/agg/commit/d79fb354828ad49987c573519d938e159dbd71c2)**

- September 28 2026, ChatGPT
- Fix the stats repository.
- It gave a full fixed and cleaner code that records and calculates the stats.
- I kept the entire code.
- **[a link to the commit where that work landed](https://github.com/TyroneAquino/agg/commit/e232008e99493e23de0d52ba735f3e9ad8b3464c)**

- September 28 2026, ChatGPT
- How to save progress by the device instead of creating an account.
- It gave a full on auth repository that connects the stats to the database.
- I kept the entire code.
- **[a link to the commit where that work landed](https://github.com/TyroneAquino/agg/commit/e232008e99493e23de0d52ba735f3e9ad8b3464c)**

- September 29 2026, ChatGPT
- How to properly initialize the game, since upon running all values are null.
- It gave a bool that is set to false and will not become true until all values are initialize properly.
- I kept the entire logic and restructure it the way I like.
- **[a link to the commit where that work landed](https://github.com/TyroneAquino/agg/commit/c387b2638184b24b96b69f4d422ca759bdf739df)**

- October 3 2026, ChatGPT  
- I want to put yesterday's answer in
- It gave two functions one for the answer repository and the minigame repository. It gets the current day and minus it by one and uses the id to get the object.
- I kept the entire structure and reuse it on the two othe minigame repository.
- **[a link to the commit where that work landed](https://github.com/TyroneAquino/agg/commit/b373ac47eac00000b09eef11681aa18b0248e425)**

- October 2, 2026
- I want to connect the slider with the volume of the soundtrack.
- It gave a simple code that connects the slider with the AudioPlayer volume.
- I kept it.
- **[a link to the commit where that work landed](https://github.com/TyroneAquino/agg/commit/b373ac47eac00000b09eef11681aa18b0248e425)**

- September 24 - October 3 2026, ChatGPT and Claude
- I asked them to fix the error in my given code.
- It gave straight fixed code and gave debugging procedure to find the actual source of the error.
- I kept the code and the debugging print to show that the actual game is working.
- **[a link to the commit where that work landed](https://github.com/TyroneAquino/agg/commit/b373ac47eac00000b09eef11681aa18b0248e425)**

- September 24 - October 3 2026, ChatGPT
- I asked if there any way to make my code and process cleaner.
- It gave suggestions and further improvements.
- I kept the code that aligns with my designed process and ignore some improvements since the game does not need them.
- **[a link to the commit where that work landed](https://github.com/TyroneAquino/agg/commit/b373ac47eac00000b09eef11681aa18b0248e425)**

- October 7 2026, ChatGPT
- I asked for a device switching system.
- It gives a code that is handled by the server not by the program and a dialog box for the interface.
- I kept the overall structure and edited some parts so that the switch will make the old device lose progress and I edited the interface so that it will fit with my design.
- **[a link to the commit where that work landed](https://github.com/TyroneAquino/agg/commit/94640db24e2a8a3f89df041f5dc561b1690ee726)**

- October 7 - October 8 2026, Claude
- I asked to debug and look for errors in my source code.
- It gave some parts that needs to be cleaned and give improvements.
- I kept the code that removes the error, took some improvements like keeping the guesses if the daily mode is complete upon relaod and ignore some improvements.
- **[a link to the commit where that work landed](https://github.com/TyroneAquino/agg/commit/94640db24e2a8a3f89df041f5dc561b1690ee726)**

### 2. Where the AI got it wrong (25 points)

Three times the AI gave you something wrong, unsafe, out of date, or just worse
than what you did instead. For each one: what it gave you, what was wrong with
it, what you did instead, and the commit link.

This section is worth real points because it is the hard part. Taking good code
is not a skill. Catching bad code is. If you write that the AI was never wrong,
this section scores zero, so do not be tempted.

- I asked for a device switch system.
- It gave me an account system instead. 
- I want A.GG to be a casual game, so users wont need to create accounts and login, if they want to switch device and save their progress, device switch is the way. 
- **[a link to the commit where that work landed](https://github.com/TyroneAquino/agg/commit/94640db24e2a8a3f89df041f5dc561b1690ee726)**

- I ran into a assertion error in which the program is returning something null, ChatGPT suggests that it was from the database. 
- It is actually from a container that I made, the container has both color and decoration which made the error.
- I removed the color and added it to the decoration instead.
- **[a link to the commit where that work landed](https://github.com/TyroneAquino/agg/commit/d79fb354828ad49987c573519d938e159dbd71c2)**

- I also run into an error wherer the Slider is not materializing, so I sent the snippet to ChatGPT, I asked if if it is an overflow error but ChatGPT suggested that it is not.
- Just to make sure it asked me to wrap it in a SizedBox and still, it starts pointing out things that might cause the error.
- Since I realized that debugging is gonna take a long time, I asked Claude the same problem and it just asked me to hot refresh the app and it worked.
- **[a link to the commit where that work landed](https://github.com/TyroneAquino/agg/commit/b373ac47eac00000b09eef11681aa18b0248e425)**


### 3. Who wrote what (30 points)

I wrote most of the enums and app themes.

- colors.dart: store colors 
- icons.dart: store icons 
- spacing.dart: store spacing 
- text.dart: store text style designs 
- [COMMIT](https://github.com/TyroneAquino/agg/commit/dbca5580a8f094c896a67029fa7406e77ab21105)

- dialog_type.dart: lists all dialog types 
- enums.dart: exports all enums 
- minigame_type.dart: lists all mingigame type 
- mode.dart: lists two modes and sets the daily mode as the default mode 
- [COMMIT](https://github.com/TyroneAquino/agg/commit/dbca5580a8f094c896a67029fa7406e77ab21105)


I wrote most of the widgets except for the textbox widget.

- clue_box.dart: I wrote the overall structure and AI enhance it to connect the volume of the soundtrack 
- clue_indicator.dart: Tells the user what each colors on the value mean for each minigame 
- guess_column.dart: Returns a container that tell the user if the guess is right or wrong for minigame soundtrack commit
- widgets.dart: Exports all widgets in one file 
- [COMMIT](https://github.com/TyroneAquino/agg/commit/b373ac47eac00000b09eef11681aa18b0248e425)

- top_interface: The top interface of each game that holds the title, overall stats, current streak, how to play, or prompt for the game 
- general_button.dart: Designs a simple text button, AI enhanced it to have a sharp look
- [COMMIT](https://github.com/TyroneAquino/agg/commit/e232008e99493e23de0d52ba735f3e9ad8b3464c)

- guess_row_character.dart: Returns a row of the inputted character's attributes with different colors as clue 
- minigame_button.dart: Returns a reusable button that vary between each minigame 
- [COMMIT](https://github.com/TyroneAquino/agg/commit/d79fb354828ad49987c573519d938e159dbd71c2)


I wrote the character and soundtrack models, althought the structure if from the anime model which is almost AI genereated.

- character screen: Used to model an anime character and use factory to initialize a character from a Json. Since all character used in the game are from the database, the returned row from a database query is a Json. 
- [COMMIT](https://github.com/TyroneAquino/agg/commit/d79fb354828ad49987c573519d938e159dbd71c2)

- soundtrack screen: Used to model an anime soundtrack and use factory to initialize to initialize a soundtrack from a Json. The same with character all soundtracks used are from the database. 
- [COMMIT](https://github.com/TyroneAquino/agg/commit/b373ac47eac00000b09eef11681aa18b0248e425)

I wrote the code in soundtrack and character screen, although the structure is from the anime screen which is almost AI generated and enhanced.
In all minigame screens, I wrote the overall structure of the widgets and wrote what the screen hides and show based on the current mode.

- character.dart: [COMMIT](https://github.com/TyroneAquino/agg/commit/94640db24e2a8a3f89df041f5dc561b1690ee726)
- soundtrack.dart: [COMMIT](https://github.com/TyroneAquino/agg/commit/94640db24e2a8a3f89df041f5dc561b1690ee726)
- anime.dart: [COMMIT](https://github.com/TyroneAquino/agg/commit/94640db24e2a8a3f89df041f5dc561b1690ee726)

What AI wrote that I understand the best. 
In anime screen AI wrote the initializaGame() function, since the game requires queries from the database to function, the initialize game made sure that all variables have data and aligns with the data that I initialize. This function has been reuse by the other two minigames.
Before initializing the game there must be six variables that must be initialize the original names, practice names, daily names, player stats, yesterday's answer and isLoading.
First, isLoading is a bool and is set to true.
Second the program calls the function runs four request at once to get the original name, the daily answer, the practice answer and yesterday's answer.
Third, since the program has four request the resulting object is an array, then the code explicitly casts each item back into its specific data type so Dart knows how to treat them.
Fourth, it fetchs the the overall stats of the player across three minigame and extracts the specific stats for the anime minigame.
Fifth, mounted check
Sixth, in the setState it checks if the game has been initialized already, if it hasnt the original name from the previous request is put into the gameState list of practice names and daily names
Seventh, since the gameState no has values, these values can now be put into the initialize value of practice names and daily names.
Eighth, then the received item in the previous request can now be put into gameState and the yesterday answer which is an Anime Object can now set its name to yesterday's answer.
Ninth, isLoading is set to false, and the screen can now load properly without any runtime errors.
[COMMIT](https://github.com/TyroneAquino/agg/commit/b373ac47eac00000b09eef11681aa18b0248e425)

