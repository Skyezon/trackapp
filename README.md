# Trackapp

simple stop delivery tracker

## Requirement

- Flutter latest version (dev using 3.13.8)
- Android studio (optional for running the project easier)
- Dart latest version (dev using Dart 3.1.4, ussually bundled with flutter)
- Android 14 phone/emulator (dev using Pixel 3a API 34 extension level 7, this is actually default when installing latest android studio)

## Running the project

- ### Using Android studio
    - open the project in android studio, then get dependency <br> (in terminal run `flutter pub get`)
    - run the android emulator <br> (go to device manager, in android studio it is located to upper right of the screen, click the triangle/run icon to run the emulator)
    - run the project (click green triangle/run icon, shortcut using shift+f10 or in terminal run `flutter run`)

- ### Without android studio
    - most of the stuff is same like running in android studio, but only using terminal

## Info

every single project requirement should already been included inside

for anything configurable check `env.dart` file

anything related to time calculation e.g. timewindow is located at `stop_service.dart`

for "drag ui and reorder" feature hold the circle icon beside `stop` data until the `stop` item is lifted and drag accordingly

to check on what data is hardcoded/inside check `database.dart` function `seedDatabase`
<br>
there are only 3 delivery number inside : `A91JK0S7`, `TEST12345`, `TEST55555` each with different number of `stop` and data
<br>
this will be shown when running the app for the first time in terminal

