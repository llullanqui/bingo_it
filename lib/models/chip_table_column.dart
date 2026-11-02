class ChipTableColumnModel {
  final String _name;
  final String? _displayName;
  int? order;
  ChipTableColumnModel(this._name, {this._displayName, this.order = 0});

  String get displayedName {
    return _displayName ?? _name;
  }

  String get name {
    return _name;
  }

}
