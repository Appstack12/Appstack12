import 'package:fit_for_life/constants/index.dart';
import 'package:fit_for_life/services/index.dart';

class HomeService {
  final _apiClass = ApiClass();

  Future<Map<String, dynamic>> onFetchDailyCaloriesData(String date) async {
    final response = await _apiClass.onCallGetApi('${ApiEndpoints.getDailyCaloriesData}/$date');

    return response;
  }

  Future<Map<String, dynamic>> onFetchWeeklyCaloriesData(String startDate,String endData) async {
    var body = {
      "start_date":startDate,
      "end_date":endData
    };
    print("body $body");
    final response = await _apiClass.onCallPostApi('${ApiEndpoints.getWeeklyCaloriesData}',body);
    return response;
  }

  Future<Map<String, dynamic>> onFetchDishes(String mealType, int page, int pageSize, String dish,
      [String search = '']) async {

    print("payload ${'${ApiEndpoints.getAllDishes}?meal_type=$mealType&page=$page&page_size=$pageSize&dish=$dish${search.isNotEmpty ? '&search=$search' : ''}'}");


    final response = await _apiClass.onCallGetApi(
        '${ApiEndpoints.getAllDishes}?meal_type=$mealType&page=$page&page_size=$pageSize&dish=$dish${search.isNotEmpty ? '&search=$search' : ''}');

   print("onFetchDishes dish $response");
    return response;
  }

  Future<Map<String, dynamic>> onAddDishes(Map<String, dynamic> data) async {
    final response = await _apiClass.onCallPostApi(ApiEndpoints.addDishes, data);
    return response;
  }

  Future<Map<String, dynamic>> onFetchDishDetails(String id) async {
    final response = await _apiClass.onCallGetApi('${ApiEndpoints.getDishDetails}/$id');
    return response;
  }

  Future<Map<String, dynamic>> onFetchStats(String date, [String mealType = '']) async {
    final response = await _apiClass
        .onCallGetApi('${ApiEndpoints.getStats}/$date/${mealType.isNotEmpty ? '?meal_type=$mealType' : ''}');
    return response;
  }

  Future<Map<String, dynamic>> onFetchIngredients() async {
    final response = await _apiClass.onCallGetApi(ApiEndpoints.getIngredients);
    return response;
  }

  Future<Map<String, dynamic>> onAddNewRecipe(Map<String, dynamic> data) async {
    final response = await _apiClass.onCallPostApi(ApiEndpoints.addNewRecipe, data);
    return response;
  }

  Future<Map<String, dynamic>> onFetchUserProfile() async {
    final response = await _apiClass.onCallGetApi(ApiEndpoints.getUserProfile);
    return response;
  }

  Future<Map<String, dynamic>> onFetchUserDetails() async {
    final response = await _apiClass.onCallGetApi(ApiEndpoints.getUserDetails);
    return response;
  }
}
