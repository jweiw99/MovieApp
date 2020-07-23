import 'package:movieapp/src/api/apiConfig.dart';

class Crew {
  String creditId;
  String department;
  int gender;
  int id;
  String job;
  String name;
  String profilePath;

  Crew(
      {this.creditId,
      this.department,
      this.gender,
      this.id,
      this.job,
      this.name,
      this.profilePath});

  Crew.fromMapObject(Map<dynamic, dynamic> map) {
    creditId = map['credit_id'].toString();
    department = map['department'].toString();
    gender = int.parse(map['gender'].toString());
    id = int.parse(map['id'].toString());
    job = map['job'].toString();
    name = map['name'].toString();
    profilePath = APIConfig.imagePath + map['profile_path'].toString();
  }
}
