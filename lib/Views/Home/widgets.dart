import 'package:digital_kharcha_app/Controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomIconTextWidget extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;
  final Color textColor;
  final String amount;
  final Color amountColor;

  const CustomIconTextWidget({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.text,
    required this.textColor,
    required this.amount,
    required this.amountColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              height: 25,
              width: 23,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: iconColor,
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 15,
                  color: Colors.white,
                ),
              ),
            ),
            Text(
              text,
              style: TextStyle(color: textColor),
            ).paddingSymmetric(horizontal: 7),
          ],
        ).paddingOnly(top: 30),
        Text(
          amount,
          style: TextStyle(
            color: amountColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class DialogBoxToUpdateTransactionName extends StatelessWidget {
  final TextEditingController transactionnameController =
      TextEditingController();
  final HomeController homeController;
  final String id;
  final String transactionname;

  DialogBoxToUpdateTransactionName(
      {super.key,
      required this.homeController,
      required this.id,
      required this.transactionname});
  @override
  Widget build(BuildContext context) {
    if (transactionname != "Tap Here") {
      transactionnameController.text = transactionname;
    }
    return AlertDialog(
      title: const Text("Transaction name (like Milk, tea, lunch)"),
      content: TextFormField(
        controller: transactionnameController,
        decoration: const InputDecoration(
          labelText: "Enter here",
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back(); // Close the dialog
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            // Handle name update
            homeController.updateTransactionName(
                transactionname: transactionnameController.text, id: id);
            Get.back(); // Close the dialog
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
