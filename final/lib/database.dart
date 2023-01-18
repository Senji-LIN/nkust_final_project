class Backgammon{
  final int? id;
  final String? type_list;
  final String? color_list;
  final String? lock;

  Backgammon({this.id,this.type_list, this.color_list, this.lock});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type_list': type_list,
      'color_list': color_list,
      'lock': lock,
    };
  }
}