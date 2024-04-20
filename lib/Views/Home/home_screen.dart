import 'package:digital_kharcha_app/Views/Home/All%20Transactions/transcations_history_page.dart';
import 'package:digital_kharcha_app/Views/Home/widgets.dart';
import 'package:digital_kharcha_app/const.dart';
import 'package:digital_kharcha_app/Controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    HomeController homeController = Get.put(HomeController());
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: EdgeInsets.only(
                    left: width * 0.07,
                    right: width * 0.07,
                    top: height * 0.04),
                height: height * 0.28,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: kmedBlueColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(width * 0.1),
                      bottomRight: Radius.circular(width * 0.1)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Good Morning,",
                          style: TextStyle(
                              color: Colors.white, fontSize: width * 0.04),
                        ),
                        Text(
                          "OM JATLA",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: width * 0.05,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Icon(
                      Icons.notifications,
                      color: Colors.white,
                      size: width * 0.08,
                    ).paddingOnly(top: height * 0.01)
                  ],
                ),
              ),
              //
              Card(
                elevation: 20,
                surfaceTintColor: Colors.transparent,
                color: kdarkBlueColor,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(width * 0.05),
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.05, vertical: height * 0.03),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Today",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: width * 0.048,
                                    fontWeight: FontWeight.bold),
                              ),
                              Icon(
                                Icons.arrow_drop_up_rounded,
                                size: width * 0.085,
                                color: Colors.white,
                              )
                            ],
                          ),
                          Icon(
                            Icons.more_horiz,
                            color: Colors.white,
                            size: width * 0.075,
                          )
                        ],
                      ),
                      Obx(
                        () => Text(
                          "${homeController.totalAmountOfToday} Rs",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: width * 0.06,
                              fontWeight: FontWeight.bold),
                        ),
                      ),

                      // two rows
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(
                            () => CustomIconTextWidget(
                              icon: Icons.arrow_downward_rounded,
                              iconColor: kiconColor,
                              text: "This Month",
                              textColor: klightBlueColor,
                              amount:
                                  "${homeController.totalAmountOfCurrentMonth.value} Rs",
                              amountColor: Colors.white,
                            ),
                          ),
                          CustomIconTextWidget(
                            icon: Icons.arrow_downward_rounded,
                            iconColor: kiconColor,
                            text: "Last Month",
                            textColor: klightBlueColor,
                            amount: "_ _ Rs",
                            amountColor: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ).paddingOnly(
                  left: width * 0.07, right: width * 0.07, top: height * 0.14)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Transactions",
                style: TextStyle(
                    // color: Colors.white,
                    fontSize: width * 0.045,
                    fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () => Get.to(() => TransactionsHistoryPage(
                      homeController: homeController,
                    )),
                child: Text(
                  "See all",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: width * 0.035,
                  ),
                ),
              ),
            ],
          )
              .paddingSymmetric(
                horizontal: width * 0.07,
              )
              .paddingOnly(top: height * 0.03, bottom: height * 0.01),
          Expanded(
            child: Obx(
              () => homeController.allTodayTranscationDetailsList.isEmpty
                  ? const Center(
                      child: Text('No transactions'),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          for (int i = 0;
                              i <
                                      homeController
                                          .allTodayTranscationDetailsList
                                          .length &&
                                  i < 5;
                              i++)
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.blue.shade50, // Light blue color
                              ),
                              child: ListTile(
                                title: InkWell(
                                  onTap: () => Get.dialog(
                                      DialogBoxToUpdateTransactionName(
                                    transactionname: homeController
                                        .allTodayTranscationDetailsList[i]
                                        .transactionname,
                                    homeController: homeController,
                                    id: homeController
                                        .allTodayTranscationDetailsList[i].id
                                        .toString(),
                                  )),
                                  child: Text(
                                    homeController.allTodayTranscationDetailsList[i].transactionname,
                                    style: TextStyle(
                                      color: Colors
                                          .blue.shade900, // Dark blue color
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                subtitle: Text(
                                  "Date : ${homeController.allTodayTranscationDetailsList[i].date}",
                                  style: TextStyle(
                                    color: Colors
                                        .blue.shade700, // Medium blue color
                                  ),
                                ),
                                trailing: Text(
                                  "${homeController.allTodayTranscationDetailsList[i].amount} Rs",
                                  style: TextStyle(
                                    color:
                                        Colors.blue.shade900, // Dark blue color
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                                .paddingSymmetric(horizontal: width * 0.02)
                                .paddingOnly(bottom: height * 0.01)
                        ],
                      ).paddingSymmetric(horizontal: width * 0.04),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
