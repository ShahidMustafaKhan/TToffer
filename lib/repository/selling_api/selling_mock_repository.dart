import 'package:tt_offer/mock/product_mock_data.dart';
import 'package:tt_offer/mock/user_mock_data.dart';
import 'package:tt_offer/models/product_model.dart';
import 'package:tt_offer/repository/selling_api/selling_repository.dart';

import '../../models/selling_products_model.dart';

class SellingMockRepository extends SellingRepository {
  @override
  Future<SellingProductsModel> getSellingProducts() async {
    return SellingProductsModel(
      data: SellingModel(
        buying: Selling(data: [
          getMockProductById(1),
          getMockProductById(2),
        ]),
        selling: Selling(data: [
          getMockProductById(5),
        ]),
        history: Selling(data: [
          Product(
              title: 'German made bike',
              description: 'German made bike',
              fixPrice: 120000,
              productType: 'featured',
              photo: [
                Photo(
                  url:
                      'https://images.pexels.com/photos/1595476/pexels-photo-1595476.jpeg?auto=compress&cs=tinysrgb&w=300',
                )
              ],
              user: getMockUserById(3),
              userId: getMockUserById(3).id,
              soldToUserId: getMockUser().id),
        ]),
      ),
    );
  }

  @override
  Future<dynamic> markSold(dynamic data) async {
    dynamic response = {};
    return response;
  }
}
