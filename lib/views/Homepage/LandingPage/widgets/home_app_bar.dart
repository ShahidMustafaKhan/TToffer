import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/Utils/widgets/others/app_text.dart';
import 'package:tt_offer/view_model/cart/cart_viewmodel.dart';
import 'package:tt_offer/view_model/suggestion/suggestion_view_model.dart';
import 'package:tt_offer/views/Authentication%20screens/login_screen.dart';
import 'package:tt_offer/views/ShoppingFlow/cart/cart_screen.dart';


class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final context;
  final StateSetter setState;
  final String? authenticationCode;

  const HomeAppBar({super.key, this.context, this.authenticationCode, required this.setState});

  @override
  Widget build(BuildContext context) {

    return Consumer<SuggestionViewModel>(
        builder: (context, suggestionViewModel, child) {
          return Padding(
            padding: EdgeInsets.only(left: 25.0, bottom: 11.h, right: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: (){
                       suggestionViewModel.removeSearchScreen(context);
                      },
                      child: Row(
                        children: [
                          SizedBox(height: 37.w, width: 37.w,child: Image.asset('assets/images/ttoffer_logo.png', fit: BoxFit.cover,)),
                          SizedBox(width: 8.w,),
                          Text('TT Offer',
                              style: GoogleFonts.merienda(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20.sp
                              ),
                              ),
                        ],
                      ),
                    ),

                    Consumer<CartViewModel>(
                        builder: (context, cartViewModel, child) {
                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              GestureDetector(
                                  onTap: (){
                                    if(authenticationCode != null) {
                                      push(context, const CartScreen());
                                    } else {
                                      push(context, const SigInScreen());
                                    }
                                  },
                                  child: const Icon(Icons.shopping_cart_outlined)),
                              if(cartViewModel.cartItemsCount!=0)
                                Positioned(
                                  top: -4.5,
                                  right: -3.5,
                                  child: Container(
                                    height: 14, // Adjust the size as needed
                                    width: 14,  // Adjust the size as needed
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(child: AppText.appText('${cartViewModel.cartItemsCount}', textColor: Colors.white, fontSize: 7.sp, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                            ],
                          );
                        }
                    )

                  ],
                ),


              ],
            ),
          );
        }
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(MediaQuery.of(context).size.height * 0.077);
}
