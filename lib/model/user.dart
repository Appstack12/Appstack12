import 'package:fit_for_life/strings/index.dart';
import 'package:intl/intl.dart';

class User {
  final int id;
  final String image;
  final String firstName;
  final String lastName;
  final String gender;
  final String location;
  final String address;
  final String contactNumber;
  final String email;
  final String dob;
  final int age;
  final double height;
  final double weight;
  final String healthIssue;
  final String anyMedication;
  final String vegNonveg;
  final String profession;
  final String help;
  final String accessToken;
  final String heightUnit;
  final String weightUnit;

  factory User.fromJson(Map<String, dynamic> data) {
    return User(
      healthIssue: data['health_issue'] ?? '',
      id: data["id"] ?? 0,
      image: data["image_url"] ?? '',
      firstName: data["first_name"] ?? '',
      lastName: data["last_name"] ?? '',
      gender: data["gender"] ?? 'Male',
      location: data["location"] ?? '',
      address: data["address"] ?? '',
      contactNumber: data["contact_number"] ?? '',
      email: data["email"] ?? '',
      dob: data["date_of_birth"] ??
          DateFormat('dd/MM/yyyy').format(DateTime.now()),
      age: data["age"] ?? 10,
      height: double.tryParse(data["height"].toString()) ??
          (data['height_unit'] == 'feet' ? 3 : 100),
      weight: double.tryParse(data["weight"].toString()) ?? 10,
      anyMedication: data["any_medication"] ?? '',
      vegNonveg: data["veg_nonveg"] ?? '',
      profession: data["profession"] ?? Strings.individual,
      help: data["help"] ?? '',
      accessToken: data["accessToken"] ?? '',
      heightUnit: data['height_unit'] ?? 'kg',
      weightUnit: data['weight_unit'] ?? 'cm',
    );
  }

  User({
    required this.id,
    required this.image,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.location,
    required this.address,
    required this.contactNumber,
    required this.email,
    required this.dob,
    required this.age,
    required this.height,
    required this.weight,
    required this.healthIssue,
    required this.anyMedication,
    required this.vegNonveg,
    required this.profession,
    required this.help,
    required this.accessToken,
    required this.heightUnit,
    required this.weightUnit,
  });
}
