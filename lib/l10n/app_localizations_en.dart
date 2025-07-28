// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Bingo it!';

  @override
  String get newTable => 'New Table';

  @override
  String get savedTables => 'Saved Tables';

  @override
  String get addItemHint => 'Write the item you think will happen';

  @override
  String get readyToStart => 'Ready to start?';

  @override
  String get sureToRestart => 'Sure you want to restart?';

  @override
  String addAtLeastItems(int count) {
    return 'Add at least $count items';
  }

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get ok => 'Ok';

  @override
  String get letsGo => 'Let\'s go!';

  @override
  String get cancel => 'Cancel';

  @override
  String get add => 'Add';

  @override
  String get restart => 'Restart';

  @override
  String get saveTable => 'Save Table';

  @override
  String get tableSaved => 'Table saved successfully!';

  @override
  String get youWin => 'YOU WIN!';

  @override
  String get deleteItem => 'Sure you want to delete the item?';

  @override
  String itemCount(int count) {
    return '$count items';
  }

  @override
  String completedCount(int count) {
    return '$count completed';
  }
}
