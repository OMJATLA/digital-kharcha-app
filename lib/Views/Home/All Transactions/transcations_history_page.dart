import 'package:digital_kharcha_app/Controllers/home_controller.dart';
import 'package:digital_kharcha_app/Views/Home/widgets.dart';
import 'package:digital_kharcha_app/const.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionsHistoryPage extends StatelessWidget {
  const TransactionsHistoryPage({super.key, required this.homeController});

  final HomeController homeController;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: CustomScrollView(
        shrinkWrap: true,
        slivers: <Widget>[
          SliverAppBar(
            actions: [
              Icon(
                Icons.share,
                color: Colors.white,
                size: width * 0.062,
              ).paddingOnly(right: width * 0.06)
            ],
            leading: GestureDetector(
              onTap: () => Get.back(),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
              ).paddingOnly(left: width * 0.02),
            ),
            backgroundColor: kmedBlueColor,
            expandedHeight: height * 0.12,
            centerTitle: true,
            // floating: true,
            pinned: true,
            // snap: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: const EdgeInsets.only(bottom: 20, top: 16),
              title: Text(
                'Transactions',
                style: TextStyle(
                  fontSize: height * 0.020,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Obx(
              () => Container(
                color: kmedBlueColor,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.04,
                    vertical: height * 0.01,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                    ),
                  ),
                  child: homeController.allTranscationDetailsList.isEmpty
                      ? const Center(
                          child: Text(
                            'No transactions',
                            style: TextStyle(color: Colors.black87),
                          ),
                        )
                      : Column(
                          children: [
                            SizedBox(height: height * 0.02),
                            Text(
                              'This Month : ',
                              style: TextStyle(
                                fontSize: height * 0.018,
                                color: const Color(0xff666666),
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                            Text(
                              '${homeController.totalAmountOfCurrentMonth} Rs',
                              style: TextStyle(
                                fontSize: height * 0.03,
                                color: kmedBlueColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: height * 0.02),
                            Column(
                              children: [
                                for (int index = homeController
                                            .allTranscationDetailsList.length -
                                        1;
                                    index >= 0;
                                    index--)
                                  Container(
                                    // margin: EdgeInsets.only(
                                    //   bottom: height * 0.01,
                                    // ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.blue.shade50,
                                    ),
                                    child: ListTile(
                                      title: GestureDetector(
                                        onTap: () => Get.dialog(
                                            DialogBoxToUpdateTransactionName(
                                                transactionname: homeController
                                                    .allTranscationDetailsList[
                                                        index]
                                                    .transactionname,
                                                homeController: homeController,
                                                id: homeController
                                                    .allTranscationDetailsList[
                                                        index]
                                                    .id
                                                    .toString())),
                                        child: Text(
                                          homeController
                                              .allTranscationDetailsList[index]
                                              .transactionname,
                                          style: TextStyle(
                                            color: Colors.blue
                                                .shade900, // Dark blue color
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      subtitle: Text(
                                        "Date : ${homeController.allTranscationDetailsList[index].date}",
                                        style: TextStyle(
                                          color: Colors.blue
                                              .shade700, // Medium blue color
                                        ),
                                      ),
                                      trailing: Text(
                                        "${homeController.allTranscationDetailsList[index].amount} Rs",
                                        style: TextStyle(
                                          color: Colors
                                              .blue.shade900, // Dark blue color
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ).paddingOnly(
                                      bottom: 10,
                                      right: width * 0.02,
                                      left: width * 0.02),
                              ],
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
