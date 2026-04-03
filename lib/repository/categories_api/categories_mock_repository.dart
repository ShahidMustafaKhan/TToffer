import 'package:tt_offer/mock/sub_category_mock_data.dart';

import '../../mock/category_mock_data.dart';
import 'categories_repository.dart';

class CategoryMockRepository implements CategoryRepository {
  @override
  Future<dynamic> categoryApi() async {
    return CategoriesMockService.getMockCategoryModelsList();
  }

  @override
  Future<dynamic> subCategoryApi() async {
    return SubCategoriesMockService.getSubCategoriesMockModel();
  }
}
