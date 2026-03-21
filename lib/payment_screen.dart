import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentScreen extends StatefulWidget {
  final VoidCallback onBackToHome;
  const PaymentScreen({super.key,required this.onBackToHome});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {

  List<Map<String, dynamic>> defaultBills = [
    {
      "title": "Monthly Maintenance - March 2026",
      "amount": "₹2500",
      "paid": false,
    },
    {
      "title": "Water Charges - March 2026",
      "amount": "₹650",
      "paid": false,
    },
    {
      "title": "Electricity Backup Charges",
      "amount": "₹900",
      "paid": false,
    },
    {
      "title": "Security Maintenance",
      "amount": "₹1200",
      "paid": false,
    },
    {
      "title": "Clubhouse Charges",
      "amount": "₹500",
      "paid": false,
    },
    {
      "title": "Parking Maintenance",
      "amount": "₹700",
      "paid": false,
    },
  ];

  List<Map<String, dynamic>> bills = [];

  @override
  void initState() {
    super.initState();
    // clearOldData();
    loadBills();
  }
  // Future<void> clearOldData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.remove('saved_bills');
  // }

  Future<void> loadBills() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? savedData = prefs.getString('saved_bills');

    if (savedData != null) {
      List decoded = jsonDecode(savedData);

      setState(() {
        bills = decoded.map((e) => Map<String, dynamic>.from(e)).toList();
      });
    } else {
      bills = List.from(defaultBills);
      saveBills();
      setState(() {});
    }
  }

  Future<void> saveBills() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_bills', jsonEncode(bills));
  }

  void payBill(int index) async {
    setState(() {
      bills[index]["paid"] = true;
    });

    await saveBills();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${bills[index]["title"]} Paid Successfully"),
      ),
    );
  }

  int getPendingAmount() {
    int total = 0;

    for (var bill in bills) {
      if (!bill["paid"]) {
        total += int.parse(
          bill["amount"].replaceAll("₹", ""),
        );
      }
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xffE23744),
        title: const Text(
          "Payments",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: widget.onBackToHome,

          icon: Icon(Icons.arrow_back_ios_new_sharp, color: Colors.white),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: const Color(0xffE23744),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    "Total Pending",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "₹${getPendingAmount()}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: bills.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 6,
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        bills[index]["title"],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        bills[index]["amount"],
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 15),

                      bills[index]["paid"]
                          ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          "Paid",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                          : ElevatedButton(
                        onPressed: () {
                          payBill(index);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffE23744),
                        ),
                        child: const Text(
                          "Pay Now",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}