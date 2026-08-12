class ChatRoomGift {
  String? giftId;
  String? giftName;
  String? giftIcon;
  String? giftPrice;
  String? giftEffect;
  int giftCount = 1;

  ChatRoomGift({
    this.giftId,
    this.giftName,
    this.giftIcon,
    this.giftPrice,
    this.giftEffect,
    this.giftCount = 1,
  });

  ChatRoomGift.fromJson(Map<String, dynamic> json) {
    giftId = json['giftId'];
    giftName = json['giftName'];
    giftIcon = json['giftIcon'];
    giftPrice = json['giftPrice'];
    giftEffect = json['giftEffect'];
    giftCount = json['count'] ?? giftCount;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['giftId'] = giftId;
    data['giftName'] = giftName;
    data['giftIcon'] = giftIcon;
    data['giftPrice'] = giftPrice;
    data['giftEffect'] = giftEffect;
    data['count'] = giftCount;
    return data;
  }
}
