import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tt_offer/Utils/utils.dart';
import 'package:tt_offer/data/response/status.dart';
import 'package:tt_offer/view_model/profile/user_profile/user_view_model.dart';

import '../../../Utils/widgets/others/app_text.dart';
import '../../../Utils/widgets/others/custom_app_bar.dart';
import '../../../models/transaction_model.dart';



class TransactionScreen extends StatelessWidget {

  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {

    UserViewModel userViewModel = Provider.of<UserViewModel>(context, listen: false);
    userViewModel.getAllTransaction(userViewModel.userModel.data?.id);

    return Scaffold(
      appBar: CustomAppBar1(
        title: "Transactions",
        preferredHeight: 55.0,
        actionOntap: () {
        },
      ),
      body: Consumer<UserViewModel>(
          builder: (context, userViewModel, child) {
            List<Transaction>? transactionList = userViewModel.transactionList.data?.data?.transactionList?.reversed.toList() ?? [];
            if(transactionList.isEmpty && userViewModel.transactionList.status != Status.loading) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 55.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/truck.png", height: 48.w, width: 48.w, fit: BoxFit.cover,),
                      SizedBox(height: 24.h,),
                      AppText.appText('No shipping transaction', fontSize: 16.sp, fontWeight: FontWeight.bold),
                      SizedBox(height: 8.h,),
                      AppText.appText('When you have shipping purchase or sale,\nYou’ll see it here', fontSize: 12.sp, fontWeight: FontWeight.w500, textAlign: TextAlign.center),
                    ],
                  ),
                ),
              );
            }
            return userViewModel.transactionList.status == Status.loading?
                const Center(child: CircularProgressIndicator())
                : ListView.builder(
                itemCount: transactionList.length,
                itemBuilder: (context, index) {
                final transaction = transactionList[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '${index+1}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 18.w,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Transaction type: ${capitalizeWords(transaction.type)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Text('Transaction Time: ${timeAgo(transaction.createdAt)}'),
                          const SizedBox(height: 5),
                          Text('Amount: AED ${transaction.amount}'),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );

        }
      ),
    );
  }
}
