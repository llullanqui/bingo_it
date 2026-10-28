import 'package:bingo_it_all/models/chip_table.dart';
import 'package:bingo_it_all/repository/shared_preferences_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferencesRepository repository;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repository = SharedPreferencesRepository();
  });

  group('SharedPreferencesRepository', () {
    test('factory returns the shared repository instance', () {
      expect(SharedPreferencesRepository(), same(repository));
    });

    test('returns an empty list when no tables are stored', () async {
      expect(await repository.getStoredTables(), isEmpty);
    });

    test('saves and restores all table data', () async {
      final table = ChipTableModel.name('Weekend')
        ..addChip('Take a trip')
        ..addChip('Try a new recipe');

      await repository.saveTablesToStorage([table]);

      final tables = await repository.getStoredTables();
      expect(tables, hasLength(1));
      expect(tables.single.id, table.id);
      expect(tables.single.name, 'Weekend');
      expect(tables.single.chips.map((chip) => chip.text),
          ['Take a trip', 'Try a new recipe']);
    });

    test('replaces previously stored tables when saving', () async {
      final firstTable = ChipTableModel.name('First');
      final replacement = ChipTableModel.name('Replacement');

      await repository.saveTablesToStorage([firstTable]);
      await repository.saveTablesToStorage([replacement]);

      final tables = await repository.getStoredTables();
      expect(tables, hasLength(1));
      expect(tables.single.id, replacement.id);
      expect(tables.single.name, 'Replacement');
    });

    test('finds a stored table by ID', () async {
      final table = ChipTableModel.name('Find me')..addChip('A chip');
      await repository.saveTablesToStorage([table]);

      final result = await repository.getTableById(table.id);

      expect(result, isNotNull);
      expect(result!.id, table.id);
      expect(result.name, 'Find me');
      expect(result.chips.single.text, 'A chip');
    });

    test('returns null when the requested table ID is not stored', () async {
      await repository.saveTablesToStorage([ChipTableModel.name('Other')]);

      expect(await repository.getTableById('missing-id'), isNull);
    });
  });
}
