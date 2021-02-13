class CreateHousingStrctureModel{
  String name;
  int totalhouse;
  Map<String, dynamic> toMap() {
    return {
      'Name': name,
      'Length': totalhouse, // length = number of house
    };}
  CreateHousingStrctureModel({this.name ,this.totalhouse});
}