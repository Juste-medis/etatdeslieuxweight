abstract class FilterStoreBase {
  List<int> providerId = [];

  List<int> typeId = [];

  List<int> handymanId = [];

  List<int> ratingId = [];

  List<int> categoryId = [];

  int selectedSubCategoryId = 0;

  String isPriceMax = '';

  String isPriceMin = '';

  String search = '';

  String experience = '';

  String etude = '';

  List<String> contrats = [];

  String latitude = '';

  String longitude = '';

  Future<void> addToProviderList({required int prodId}) async {
    providerId.add(prodId);
  }

  Future<void> addToTypeList({required int prodId}) async {
    typeId.add(prodId);
  }

  Future<void> removeFromProviderList({required int prodId}) async {
    providerId.removeWhere((element) => element == prodId);
  }

  Future<void> removeFromTypeList({required int prodId}) async {
    typeId.removeWhere((element) => element == prodId);
  }

  Future<void> addToCategoryIdList({required int prodId}) async {
    categoryId.add(prodId);
  }

  Future<void> addToContratList({required String prodId}) async {
    contrats.add(prodId);
  }

  Future<void> setSelectedSubCategory({required int catId}) async {
    selectedSubCategoryId = catId;
  }

  Future<void> removeFromCategoryIdList({required int prodId}) async {
    categoryId.removeWhere((element) => element == prodId);
  }

  Future<void> removeFromContratList({required String prodId}) async {
    contrats.removeWhere((element) => element == prodId);
  }

  Future<void> addToHandymanList({required int prodId}) async {
    handymanId.add(prodId);
  }

  Future<void> removeFromHandymanList({required int prodId}) async {
    handymanId.removeWhere((element) => element == prodId);
  }

  Future<void> addToRatingId({required int prodId}) async {
    ratingId.add(prodId);
  }

  Future<void> removeFromRatingId({required int prodId}) async {
    ratingId.removeWhere((element) => element == prodId);
  }

  Future<void> clearFilters() async {
    typeId.clear();
    providerId.clear();
    handymanId.clear();
    ratingId.clear();
    categoryId.clear();
    contrats.clear();
    isPriceMax = "";
    isPriceMin = "";
  }

  void setMaxPrice(String val) => isPriceMax = val;

  void setMinPrice(String val) => isPriceMin = val;

  void setSearch(String val) => search = val;

  void setExperience(String val) => experience = val;

  void setEtude(String val) => etude = val;

  void setLatitude(String val) => latitude = val;

  void setLongitude(String val) => longitude = val;
}
