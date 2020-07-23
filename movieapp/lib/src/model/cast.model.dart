import 'package:movieapp/src/api/apiConfig.dart';

class Cast {
  int castId;
  String character;
  String creditId;
  int gender;
  int id;
  String name;
  int order;
  String profilePath;

  Cast(
      {this.castId,
      this.character,
      this.creditId,
      this.gender,
      this.id,
      this.name,
      this.order,
      this.profilePath});

  Cast.fromMapObject(Map<dynamic, dynamic> map) {
    castId = int.parse(map['cast_id'].toString());
    character = map['character'].toString();
    creditId = map['credit_id'].toString();
    gender = int.parse(map['gender'].toString());
    id = int.parse(map['id'].toString());
    name = map['name'].toString();
    order = int.parse(map['order'].toString());
    profilePath = APIConfig.imagePath + map['profile_path'].toString();
  }
}
