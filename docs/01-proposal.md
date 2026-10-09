# Proposal

Paste in the proposal you submitted, and replace it with the final version when
the project is done. You do not need to keep it in sync week to week: nobody
reads this folder until you hand the project in.

Keep these headings so a reader can scan it:

## The problem, in one sentence
Many puzzles games are available but few are focused on testing player's knowledge about anime.

## Who it is for
A.GG is an anime focused game for people who enjoy anime and solving daily puzzles.

## Core features
- Three minigames.
    * Anime minigame: Guessing the secret anime with the help of previous guesses.
    * Character minigame: Guessing the secret character with the help of previous guesses.
    * Soundtrack minigame: Guessing the anime where the soundtrack is from.
- Daily mode and practice mode for all minigames.
- Player stats that records total puzzles solved, win rate, average guesses, current and longest streak.
- Device switching to save progress.

## Out of scope, and why
- **Original Anime Soundtracks:** The application does not use the original soundtracks recording. Instead, the Soundtrack minigame uses instrumental covers due to copyright concerns

## Data the app remembers, and where it is saved
- **Anime, Character, and Soundtrack Data:** Stored in Supabase, including the information used for guesses and clues.
- **Daily Puzzle Answers:** Stored in Supabase and retrieve according to the date.
- **Game Progress:** The app maintains game state during gameplay, including guesses, attempts, and completion status. Daily mode saves guesses, attempts and completion status upon reload.
- **Player Statistics:** Stored in the player_stats in Supabase, including total puzzles solved, win rate, average guesses, current and longest streak.

## Risks
- **Database Availability:** The game depends entirely on Supabase to retrieve game data, answers, and player statistics. Database or network issues can affect gameplay.
- **Limited Content:** The current database holds 55 anime records, 65 character records, 15 soundtrack records but only one are being used, limiting the guessing options. 
- **Copyright Concerns:** Instrumental covers are used in the Soundtrack minigame instead of original anime soundtrack recordings. Covers may still be subject to copyright.
- **Data Security:** Player statistics and progress stored in Supabase must be protected by approriate permissions and policies. 

## Changes since the last version
- **(09/23/2026):** User interface is created.
- **(09/27/2026):** Anime and Character minigame implemented but not completed. Can store running game records.
- **(10/04/2026):** Added Soundtrack minigame.
- **(10/07/2026):** Added device switching.  
- **(10/09/2026):** Full working game.  