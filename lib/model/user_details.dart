class UserDetails {
  UserDetails({
    this.profileImage = '',
    this.name = '',
    this.age = 0,
    this.calories = 0,
    this.email,
    this.phoneNumber,
    this.dob,
    this.dobDate,
    this.gender,
    this.height,
    this.weight,
    this.address,
    this.foodPreference,
    this.healthIssues,
  });

  factory UserDetails.fromJson(Map<String, dynamic> data) {
    String  dobData = data['date_of_birth'] ?? '';
    //dobData = dobData.substring(3,dobData.length);
    return UserDetails(
      profileImage: data['image_url'] ?? '',
      name: '${data['first_name'] ?? ''} ${data['last_name'] ?? ''}',
      age: data['age'] ?? 0,
      calories: data['calories'] ?? 0,
      email: data['email'] ?? '',
      phoneNumber: data['contact_number'] ?? '',
      dob: dobData,
      dobDate: data['date_of_birth'] ?? '',
      gender: data['gender'],
      height: '${data['height'] ?? ''} ${data['height_unit'] ?? ''}',
      weight: '${data['weight'] ?? ''} ${data['weight_unit'] ?? ''}',
      address: data['address'],
      foodPreference: data['veg_nonveg'] ?? '',
      healthIssues: (data['health_issue'] ?? '')?.split(', '),
    );
  }

  final String? profileImage;
  final String? name;
  final int? age;
  final dynamic calories;
  final String? email;
  final String? phoneNumber;
  final String? dob;
  final String? dobDate;
  final String? gender;
  final String? height;
  final String? weight;
  final String? address;
  final String? foodPreference;
  final List<String>? healthIssues;
}
