import 'package:bingo_it_all/constants/app_constants.dart';
import 'package:bingo_it_all/models/chip_table.dart';
import 'package:bingo_it_all/services/abstract_table_generator_service.dart';
import 'package:bingo_it_all/mixins/classic_table_generator_mixin.dart';

class Bingo75GeneratorService extends AbstractTableGeneratorService with ClassicTableGeneratorMixin {
  @override
  ChipTableModel generateTable({required String name}) {
    return generateClassicTable(
      AppConstants.classicBingo75Columns,
      AppConstants.classicBingo75Range,
      AppConstants.classicBingo75ChipsPerColumn,
      name: name,
    );
  }
}