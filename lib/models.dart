class IcoItemViewModel {
  Map<String, dynamic> mapData;

  IcoItemViewModel(this.mapData);

  String get name => mapData['name'];
  String get symbol => mapData['symbol'];
  String get stage => mapData['stage'];
  String get startTs => mapData['startTs'];
  Function get onItemClicked => mapData['onItemClicked'];
  Function get onMenuClicked => mapData['onMenuClicked'];
}
