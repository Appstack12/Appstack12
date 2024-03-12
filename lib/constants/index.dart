class Constants {
  static const mobileRegex = r'^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$';
  static const emailRegexEx = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
}

class ApiEndpoints {
  static const login = '/login/';
  static const verifyOtp = '/verify-otp/';
  static const updateUserDetails = '/update/user/details/';
  static const editUserDetails = '/update/user-profile/';
  static const uploadImage = '/upload/image/';
  static const getDailyCaloriesData = '/customer-daily-calories';
  static const getWeeklyCaloriesData = '/user-calory-intake/';
  static const getAllDishes = '/all/dishes/';
  static const addDishes = '/add/calory/';
  static const getDishDetails = '/calorigram';
  static const getStats = '/daily-calorigram';
  static const getIngredients = '/get-dishes/';
  static const addNewRecipe = '/create-recipe/';
  static const getUserProfile = '/user-profile/';
  static const getUserDetails = '/user-profile-detail/';
}
