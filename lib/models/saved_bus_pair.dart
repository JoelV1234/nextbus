class SavedBusPair {
  final String stopId;
  final String busLine;
  final String? nickname;

  SavedBusPair({required this.stopId, required this.busLine, this.nickname});

  Map<String, dynamic> toJson() {
    return {'stopId': stopId, 'busLine': busLine, 'nickname': nickname};
  }

  factory SavedBusPair.fromJson(Map<String, dynamic> json) {
    return SavedBusPair(
      stopId: json['stopId'] as String,
      busLine: json['busLine'] as String,
      nickname: json['nickname'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedBusPair &&
          runtimeType == other.runtimeType &&
          stopId == other.stopId &&
          busLine == other.busLine;

  @override
  int get hashCode => stopId.hashCode ^ busLine.hashCode;
}
