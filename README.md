# Tollywood Quiz - starter milestone

This patch contains a working Flutter Web starter with:
- Responsive dark cinematic home screen
- Six Telugu cinema quiz categories
- Easy / Medium / Hard timer settings (20 / 15 / 10 seconds)
- Multiple-choice quiz flow, timer, feedback and scoring
- Results screen
- Session leaderboard and editable display name

## Install into your existing Flutter project

1. Make a backup copy of your current `lib` folder.
2. Extract this ZIP directly into the root of your existing `tollywood_quiz` project, for example `C:\Users\nitee\Downloads\tollywood_quiz`.
3. Allow Windows to merge folders and replace the matching files.
4. Open a terminal in the project folder and run:

   ```powershell
   flutter pub get
   flutter run -d chrome
   ```

No additional Dart packages are required for this milestone.

## Current limitations to address in the next milestone

- Leaderboard scores and player name are held in memory for the current browser session; persistence and an online shared leaderboard need a backend.
- Difficulty currently changes the time limit. Difficulty-specific question pools will be added next.
- The included question bank is a starter set and should be expanded and reviewed before final submission.
