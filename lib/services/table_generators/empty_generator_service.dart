import 'package:bingo_it_all/models/chip_table.dart';
import 'package:bingo_it_all/services/abstract_table_generator_service.dart';

class EmptyGeneratorService extends AbstractTableGeneratorService {
  @override
  ChipTableModel generateTable({required String name}) {
    return ChipTableModel.empty();
  }
}
