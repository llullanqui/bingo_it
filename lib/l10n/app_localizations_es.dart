// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => '¡Bingo!';

  @override
  String get newTable => 'Nueva Tabla';

  @override
  String get savedTables => 'Tablas Guardadas';

  @override
  String get addItemHint => 'Escribe el elemento que crees que sucederá';

  @override
  String get readyToStart => '¿Listo para comenzar?';

  @override
  String get sureToRestart => '¿Seguro que quieres reiniciar?';

  @override
  String addAtLeastItems(int count) {
    return 'Agrega al menos $count elementos';
  }

  @override
  String tableDraftsSubtitle(int count) {
    return 'Cantidad de chips: $count';
  }

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get ok => 'Ok';

  @override
  String get letsGo => '¡Vamos!';

  @override
  String get cancel => 'Cancelar';

  @override
  String get add => 'Agregar';

  @override
  String get startGame => 'Start Game';

  @override
  String get restart => 'Reiniciar';

  @override
  String get table => 'Tabla';

  @override
  String get saveTable => 'Guardar Tabla';

  @override
  String get tableSaved => '¡Tabla guardada exitosamente!';

  @override
  String get noSavedTablesYet => 'Aún no hay tablas guardadas';

  @override
  String get youWin => '¡GANASTE!';

  @override
  String get deleteItem => '¿Seguro que quieres eliminar el elemento?';

  @override
  String itemCount(int count) {
    return '$count elementos';
  }

  @override
  String completedCount(int count) {
    return '$count completados';
  }

  @override
  String get increment => 'Incremento';
}
