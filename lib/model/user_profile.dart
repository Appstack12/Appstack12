class UserProfile {
  UserProfile({
    this.profileImage = '',
    this.name = '',
    this.age = 0,
    this.calories = 0,
    this.calorieIntake,
    this.nutritionIntake,
  });

  factory UserProfile.fromJson(Map<String, dynamic> data) {
    return UserProfile(
      profileImage: data['user_image'] ?? '',
      name: data['name'] ?? '',
      age: data['age'] ?? 0,
      calories: data['calories'] ?? 0,
      calorieIntake: CalorieIntake.fromJson(data['calorie_intake']),
      nutritionIntake: NutritionIntake.fromJson(data['nutrition_intake']['data_points']),
    );
  }

  final String? profileImage;
  final String? name;
  final int? age;
  final dynamic calories;
  final CalorieIntake? calorieIntake;
  final NutritionIntake? nutritionIntake;
}

class CalorieIntake {
  CalorieIntake({
    required this.averageCalorie,
    required this.dataPoints,
  });

  factory CalorieIntake.fromJson(Map<String, dynamic> data) {
    return CalorieIntake(
      averageCalorie: data['average_calorie'] ?? 0,
      dataPoints: DataArray.fromJson(data['data_points']).dataArr,
    );
  }

  final dynamic averageCalorie;
  final List<double> dataPoints;
}

class NutritionIntake {
  NutritionIntake({
    required this.dataPoints,
  });

  factory NutritionIntake.fromJson(List data) {
    final List<DataPoints> dataPoints = [];
    if (data.isNotEmpty) {
      for (var i = 0; i < data.length; i++) {
        dataPoints.add(DataPoints.fromJson(data[i]));
      }
    }

    return NutritionIntake(dataPoints: dataPoints);
  }

  final List<DataPoints> dataPoints;
}

class DataPoints {
  DataPoints({
    required this.name,
    required this.values,
  });

  factory DataPoints.fromJson(Map<String, dynamic> data) {
    return DataPoints(
      name: data['name'] ?? '',
      values: DataArray.fromJson(data['values']).dataArr,
    );
  }

  final String name;
  final List<double> values;
}

class DataArray {
  DataArray({required this.dataArr});

  factory DataArray.fromJson(List data) {
    return DataArray(dataArr: data.map((e) => double.tryParse(e.toString()) ?? 0).toList());
  }

  final List<double> dataArr;
}

class Data {
  Data({required this.value});

  factory Data.fromJson(double data) {
    return Data(value: data);
  }

  final double value;
}
