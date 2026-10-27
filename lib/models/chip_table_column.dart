class ChipTableColumn {
  String name;
  String? displayName;
  int? order;
  ChipTableColumn(this.name, {this.displayName, this.order});

  String get displayedName {
    return displayName ?? name;
  }
}
