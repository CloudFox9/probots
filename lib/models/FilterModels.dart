class MultiList {
  final int id;
  final String name;

  MultiList({
    required this.id,
    required this.name,
  });
}

class filterclassModel {
  String? name;
  int? payout;
  List<String>? cities;
  List<int>? offerType;
  int? duration;
  int? stops;

  filterclassModel(
      {this.name,
        this.payout,
        this.cities,
        this.offerType,
        this.duration,
        this.stops});

  filterclassModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    payout = json['payout'];
    cities = json['cities'].cast<String>();
    offerType = json['offerType'].cast<int>();
    duration = json['duration'];
    stops = json['stops'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['payout'] = this.payout;
    data['cities'] = this.cities;
    data['offerType'] = this.offerType;
    data['duration'] = this.duration;
    data['stops'] = this.stops;
    return data;
  }
}