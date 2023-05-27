import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:queueing_system_web/Models/MonthsModel.dart';
import 'package:queueing_system_web/Services/StringExtensions.dart';
import 'package:queueing_system_web/widgets/ButttonWidget.dart';
import 'package:http/http.dart' as http;
import 'package:queueing_system_web/widgets/TextFieldWidget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../Models/ChartModel.dart';
import '../Models/QueueModel.dart';
import '../Models/UsertypeModel.dart';
import '../Services/Sizer.dart';
import '../config/Endpoint.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController phoneno = TextEditingController();
  TextEditingController address = TextEditingController();

  TextEditingController edit_username = TextEditingController();
  TextEditingController edit_password = TextEditingController();
  TextEditingController edit_confirmpassword = TextEditingController();

  List<ChartData> data = [];
  var tooltip = TooltipBehavior(enable: true);
  int index = 0;
  bool isLoading = true;
  TextEditingController search = TextEditingController();
  onClick({required int selectedindex}) async {
    setState(() {
      index = selectedindex;
    });
  }

  List<QueueModel> queueList = [];
  List<UsertypeModel> cashierList = [];
  List<UsertypeModel> registrarList = [];
  List<UsertypeModel> customerList = [];

  List<String> year = [
    '2015',
    '2016',
    '2017',
    '2018',
    '2019',
    '2020',
    '2021',
    '2022',
    '2023',
    '2024',
    '2025',
    '2026',
    '2027',
    '2028',
    '2029',
    '2030',
  ];

  List<MonthsModel> months = [
    MonthsModel('January', 1),
    MonthsModel('February', 2),
    MonthsModel('March', 3),
    MonthsModel('April', 4),
    MonthsModel('May', 5),
    MonthsModel('June', 6),
    MonthsModel('July', 7),
    MonthsModel('August', 8),
    MonthsModel('September', 9),
    MonthsModel('October', 10),
    MonthsModel('November', 11),
    MonthsModel('December', 12),
  ];

  String selectedMonth = 'January';
  int selectedMonthNumber = 1;

  String selectedYear = DateTime.now().year.toString();

  Timer? _debounce;

  getDataForAnalytics() async {
    double noshow_count = 0;
    double arrived_count = 0;
    double pending_count = 0;

    for (var i = 0; i < queueList.length; i++) {
      if (queueList[i].dateCreated.year == int.parse(selectedYear) &&
          queueList[i].dateCreated.month == selectedMonthNumber) {
        if (queueList[i].status == 'Done') {
          arrived_count = arrived_count + 1;
        } else if (queueList[i].status == 'Pending') {
          pending_count = pending_count + 1;
        } else {
          noshow_count = noshow_count + 1;
        }
      }
    }

    setState(() {
      data = [
        ChartData('Arrived', arrived_count),
        ChartData('Pending', pending_count),
        ChartData('No Show', noshow_count),
      ];
    });
  }

  getQueues() async {
    try {
      var url = Uri.parse("${AppEndpoint.endPointDomain}/get-queues.php");
      var response = await http.post(
        url,
      );

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['data'];

        if (data.length == 0 || data.isEmpty) {
        } else {
          var queuedata = await queueModelFromJson(jsonEncode(data));
          setState(() {
            queueList = queuedata;
          });
          getDataForAnalytics();
        }
      } else {}
      setState(() {
        isLoading = false;
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  searchQueue(String word) async {
    setState(() {
      queueList.clear();
    });
    try {
      var url =
          Uri.parse("${AppEndpoint.endPointDomain}/get-queues-search.php");
      var response = await http.post(url, body: {"word": word});
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['data'];
        if (data.length == 0 || data.isEmpty) {
        } else {
          var queuedata = await queueModelFromJson(jsonEncode(data));
          setState(() {
            queueList = queuedata;
          });
        }
      } else {}
    } on Exception catch (e) {
      print(e);
    }
  }

  searchCashier(String word) async {
    setState(() {
      cashierList.clear();
    });
    try {
      var url =
          Uri.parse("${AppEndpoint.endPointDomain}/get-cashier-search.php");
      var response = await http.post(url, body: {"word": word});

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['data'];

        if (data.length == 0 || data.isEmpty) {
        } else {
          var cashierData = await usertypeModelFromJson(jsonEncode(data));
          setState(() {
            cashierList = cashierData;
          });
        }
      } else {}
    } on Exception catch (e) {
      print(e);
    }
  }

  searchRegistrar(String word) async {
    setState(() {
      registrarList.clear();
    });
    try {
      var url =
          Uri.parse("${AppEndpoint.endPointDomain}/get-registrar-search.php");
      var response = await http.post(url, body: {"word": word});

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['data'];

        if (data.length == 0 || data.isEmpty) {
        } else {
          var registrarData = await usertypeModelFromJson(jsonEncode(data));
          setState(() {
            registrarList = registrarData;
          });
        }
      } else {}
    } on Exception catch (e) {
      print(e);
    }
  }

  searchCustomer(String word) async {
    setState(() {
      customerList.clear();
    });
    try {
      var url =
          Uri.parse("${AppEndpoint.endPointDomain}/get-customer-search.php");
      var response = await http.post(url, body: {"word": word});
      print(response.body);
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['data'];

        if (data.length == 0 || data.isEmpty) {
          customerList.clear();
        } else {
          var customerdata = await usertypeModelFromJson(jsonEncode(data));
          setState(() {
            customerList = customerdata;
          });
        }
      } else {}
    } on Exception catch (e) {
      print(e);
    }
  }

  getCashier() async {
    try {
      var url = Uri.parse("${AppEndpoint.endPointDomain}/get-cashiers.php");
      var response = await http.post(
        url,
      );

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['data'];
        if (data.length == 0 || data.isEmpty) {
        } else {
          var cashierData = await usertypeModelFromJson(jsonEncode(data));
          setState(() {
            cashierList = cashierData;
          });
        }
      } else {}
    } on Exception catch (e) {
      print(e);
    }
  }

  getRegistrar() async {
    try {
      var url = Uri.parse("${AppEndpoint.endPointDomain}/get-registrar.php");
      var response = await http.post(
        url,
      );

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['data'];

        if (data.length == 0 || data.isEmpty) {
        } else {
          var registrardata = await usertypeModelFromJson(jsonEncode(data));
          setState(() {
            registrarList = registrardata;
          });
        }
      } else {}
    } on Exception catch (e) {
      print(e);
    }
  }

  getCustomer() async {
    try {
      var url = Uri.parse("${AppEndpoint.endPointDomain}/get-customer.php");
      var response = await http.post(
        url,
      );

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['data'];

        if (data.length == 0 || data.isEmpty) {
        } else {
          var customerdata = await usertypeModelFromJson(jsonEncode(data));
          setState(() {
            customerList = customerdata;
          });
        }
      } else {}
    } on Exception catch (e) {
      print(e);
    }
  }

  createCashierOrRegistrar({
    required String usertype,
  }) async {
    try {
      var url = Uri.parse(
          "${AppEndpoint.endPointDomain}/create-cashier-or-registrar.php");
      var response = await http.post(url, body: {
        "username": username.text,
        "password": password.text,
        "firstname": firstname.text,
        "lastname": lastname.text,
        "age": age.text,
        "address": address.text,
        "phoneno": phoneno.text,
        "usertype": usertype,
      });

      if (response.statusCode == 200) {
        if (usertype == 'cashier') {
          getCashier();
        } else {
          getRegistrar();
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Successfully Created.'),
          backgroundColor: Colors.lightBlue,
        ));
      } else {}
    } on Exception catch (e) {
      print(e);
    }
  }

  resetQueue() async {
    try {
      var url = Uri.parse("${AppEndpoint.endPointDomain}/reset-queue.php");
      var response = await http.post(
        url,
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Reset Done.'),
          backgroundColor: Colors.lightBlue,
        ));
      } else {}
    } on Exception catch (e) {
      print(e);
    }
  }

  update_account({required String id}) async {
    try {
      var url = Uri.parse("${AppEndpoint.endPointDomain}/update-account.php");
      var response = await http.post(url, body: {
        "id": id,
        "username": edit_username.text,
        "password": edit_password.text,
      });

      if (response.statusCode == 200) {
        getCashier();
        getRegistrar();
        getCustomer();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Update Done.'),
          backgroundColor: Colors.lightBlue,
        ));
      } else {}
    } on Exception catch (e) {
      print(e);
    }
  }

  showDialogCreateUser({required String usertype}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Create ${usertype.capitalize()} Account"),
          content: Container(
            height: Sizer.getHeight(height: 65, context: context),
            width: Sizer.getWidth(width: 50, context: context),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Login Details",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).textScaleFactor * 15),
                  ),
                ),
                SizedBox(
                  height: Sizer.getHeight(height: 1.5, context: context),
                ),
                TextFieldWidget(controller: username, label: "Username"),
                SizedBox(
                  height: Sizer.getHeight(height: 3, context: context),
                ),
                TextFieldWidget(
                  controller: password,
                  label: "Password",
                  isObscure: true,
                ),
                SizedBox(
                  height: Sizer.getHeight(height: 3, context: context),
                ),
                TextFieldWidget(
                  controller: confirmpassword,
                  label: "Confirm password",
                  isObscure: true,
                ),
                SizedBox(
                  height: Sizer.getHeight(height: 3, context: context),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "User Details",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).textScaleFactor * 15),
                  ),
                ),
                SizedBox(
                  height: Sizer.getHeight(height: 1.5, context: context),
                ),
                Container(
                  child: Row(
                    children: [
                      Expanded(
                          child: TextFieldWidget(
                              controller: firstname, label: "First Name")),
                      SizedBox(
                        width: Sizer.getWidth(width: 2, context: context),
                      ),
                      Expanded(
                          child: TextFieldWidget(
                              controller: lastname, label: "Last Name")),
                    ],
                  ),
                ),
                SizedBox(
                  height: Sizer.getHeight(height: 3, context: context),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child:
                              TextFieldWidget(controller: age, label: "Age")),
                      SizedBox(
                        width: Sizer.getWidth(width: 2, context: context),
                      ),
                      Expanded(
                          child: TextFieldWidget(
                              controller: phoneno, label: "Phone no.")),
                    ],
                  ),
                ),
                SizedBox(
                  height: Sizer.getHeight(height: 3, context: context),
                ),
                TextFieldWidget(controller: address, label: "Address"),
                SizedBox(
                  height: Sizer.getHeight(height: 3, context: context),
                ),
                ButtonWidget(
                    labelText: "CREATE",
                    onPressFunction: () {
                      if (username.text.isEmpty ||
                          password.text.isEmpty ||
                          lastname.text.isEmpty ||
                          firstname.text.isEmpty ||
                          age.text.isEmpty ||
                          phoneno.text.isEmpty ||
                          address.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Missing fields'),
                          backgroundColor: Colors.red,
                        ));
                      } else if (password.text.isEmpty !=
                          confirmpassword.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Password not match.'),
                          backgroundColor: Colors.red,
                        ));
                      } else {
                        Navigator.pop(context);
                        createCashierOrRegistrar(usertype: usertype);
                      }
                    })
              ],
            ),
          ),
        );
      },
    );
  }

  showDialogEditUser(
      {required String usertype, required UsertypeModel userData}) {
    showDialog(
      context: context,
      builder: (context) {
        edit_username.text = userData.username;
        edit_password.text = userData.password;
        edit_confirmpassword.text = userData.password;
        return AlertDialog(
          title: Text("Edit ${usertype.capitalize()} Account"),
          content: Container(
            height: Sizer.getHeight(height: 35, context: context),
            width: Sizer.getWidth(width: 50, context: context),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Edit Credential",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).textScaleFactor * 15),
                  ),
                ),
                SizedBox(
                  height: Sizer.getHeight(height: 1.5, context: context),
                ),
                TextFieldWidget(controller: edit_username, label: "Username"),
                SizedBox(
                  height: Sizer.getHeight(height: 3, context: context),
                ),
                TextFieldWidget(
                  controller: edit_password,
                  label: "Password",
                  isObscure: true,
                ),
                SizedBox(
                  height: Sizer.getHeight(height: 3, context: context),
                ),
                TextFieldWidget(
                  controller: edit_confirmpassword,
                  label: "Confirm password",
                  isObscure: true,
                ),
                SizedBox(
                  height: Sizer.getHeight(height: 3, context: context),
                ),
                ButtonWidget(
                    labelText: "UPDATE",
                    onPressFunction: () {
                      if (edit_username.text.isEmpty ||
                          edit_password.text.isEmpty ||
                          edit_confirmpassword.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Missing fields'),
                          backgroundColor: Colors.red,
                        ));
                      } else if (edit_password.text.isEmpty !=
                          edit_confirmpassword.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Password not match.'),
                          backgroundColor: Colors.red,
                        ));
                      } else {
                        Navigator.pop(context);
                        update_account(
                          id: userData.id.toString(),
                        );
                      }
                    })
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getQueues();
    getCashier();
    getRegistrar();
    getCustomer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading == true
          ? Center(
              child: Container(
                padding: EdgeInsets.only(
                    left: Sizer.getWidth(width: 35, context: context),
                    right: Sizer.getWidth(width: 35, context: context)),
                child: Image.asset("assets/image/logo1.png"),
              ),
            )
          : Center(
              child: Row(
              children: [
                Container(
                  width: Sizer.getWidth(width: 14, context: context),
                  height: Sizer.getHeight(height: 100, context: context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Container(
                            child: Image.asset("assets/image/logo1.png"),
                          ),
                          SizedBox(
                            height:
                                Sizer.getHeight(height: 2, context: context),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left:
                                    Sizer.getWidth(width: 1, context: context),
                                right:
                                    Sizer.getWidth(width: 1, context: context)),
                            child: ButtonWidget(
                                labelText: "Dashboard",
                                onPressFunction: () {
                                  onClick(selectedindex: 0);
                                }),
                          ),
                          SizedBox(
                            height:
                                Sizer.getHeight(height: 2, context: context),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left:
                                    Sizer.getWidth(width: 1, context: context),
                                right:
                                    Sizer.getWidth(width: 1, context: context)),
                            child: ButtonWidget(
                                labelText: "Cashier",
                                onPressFunction: () {
                                  onClick(selectedindex: 1);
                                }),
                          ),
                          SizedBox(
                            height:
                                Sizer.getHeight(height: 2, context: context),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left:
                                    Sizer.getWidth(width: 1, context: context),
                                right:
                                    Sizer.getWidth(width: 1, context: context)),
                            child: ButtonWidget(
                                labelText: "Registrar",
                                onPressFunction: () {
                                  onClick(selectedindex: 2);
                                }),
                          ),
                          SizedBox(
                            height:
                                Sizer.getHeight(height: 2, context: context),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left:
                                    Sizer.getWidth(width: 1, context: context),
                                right:
                                    Sizer.getWidth(width: 1, context: context)),
                            child: ButtonWidget(
                                labelText: "Customers",
                                onPressFunction: () {
                                  onClick(selectedindex: 3);
                                }),
                          ),
                          SizedBox(
                            height:
                                Sizer.getHeight(height: 2, context: context),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left:
                                    Sizer.getWidth(width: 1, context: context),
                                right:
                                    Sizer.getWidth(width: 1, context: context)),
                            child: ButtonWidget(
                                labelText: "Analytics",
                                onPressFunction: () {
                                  onClick(selectedindex: 4);
                                }),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                                left:
                                    Sizer.getWidth(width: 1, context: context),
                                right:
                                    Sizer.getWidth(width: 1, context: context)),
                            child: ButtonWidget(
                                colors: Colors.red,
                                labelText: "Logout",
                                onPressFunction: () {
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, "/Loginpage", (route) => false);
                                  final box = GetStorage();
                                  box.remove('id');
                                  box.remove('username');
                                  box.remove('password');
                                  box.remove('firstname');
                                  box.remove('lastname');
                                }),
                          ),
                          SizedBox(
                            height:
                                Sizer.getHeight(height: 4, context: context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: index == 0
                      ////////////////////////////////////////////////////////////////////////////////////
                      ////                           DASHBOARD                                        ////
                      ////////////////////////////////////////////////////////////////////////////////////
                      ? Container(
                          child: Column(
                            children: [
                              SizedBox(
                                height: Sizer.getHeight(
                                    height: 3, context: context),
                              ),
                              Container(
                                  padding: EdgeInsets.only(
                                      left: Sizer.getWidth(
                                          width: 5, context: context),
                                      right: Sizer.getWidth(
                                          width: 5, context: context)),
                                  child: TextField(
                                    controller: search,
                                    onChanged: (value) {
                                      if (_debounce?.isActive ?? false)
                                        _debounce!.cancel();
                                      _debounce = Timer(
                                          const Duration(milliseconds: 500),
                                          () {
                                        if (search.text.isEmpty ||
                                            search.text == "") {
                                          getQueues();
                                        } else {
                                          searchQueue(search.text);
                                        }
                                      });
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: "Search",
                                    ),
                                  )),
                              SizedBox(
                                height: Sizer.getHeight(
                                    height: 1.5, context: context),
                              ),
                              // ? Colors.lightBlue[50]
                              //           : Colors.purple[50],
                              Container(
                                padding: EdgeInsets.only(
                                    left: Sizer.getWidth(
                                        width: 5, context: context),
                                    right: Sizer.getWidth(
                                        width: 5, context: context)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text("Cashier: "),
                                        Container(
                                          height: Sizer.getHeight(
                                              height: 1, context: context),
                                          width: Sizer.getWidth(
                                              width: 1, context: context),
                                          color: Colors.lightBlue[50],
                                        ),
                                        SizedBox(
                                          width: Sizer.getWidth(
                                              width: .5, context: context),
                                        ),
                                        Text("Registrar: "),
                                        Container(
                                          height: Sizer.getHeight(
                                              height: 1, context: context),
                                          width: Sizer.getWidth(
                                              width: 1, context: context),
                                          color: Colors.purple[50],
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: Sizer.getWidth(
                                          width: 10, context: context),
                                      alignment: Alignment.centerRight,
                                      child: ButtonWidget(
                                          labelText: "Reset Queue",
                                          onPressFunction: () {
                                            resetQueue();
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: Sizer.getHeight(
                                    height: 1.5, context: context),
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: Sizer.getWidth(
                                          width: 5, context: context),
                                      right: Sizer.getWidth(
                                          width: 5, context: context)),
                                  child: ListView.builder(
                                    itemCount: queueList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                            bottom: Sizer.getHeight(
                                                height: 1, context: context)),
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              left: Sizer.getWidth(
                                                  width: .5, context: context),
                                              right: Sizer.getWidth(
                                                  width: .5, context: context)),
                                          height: Sizer.getHeight(
                                              height: 10, context: context),
                                          width: Sizer.getWidth(
                                              width: 100, context: context),
                                          color: queueList[index].queueType ==
                                                  "cashier"
                                              ? Colors.lightBlue[50]
                                              : Colors.purple[50],
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: Sizer.getHeight(
                                                    height: 1,
                                                    context: context),
                                              ),
                                              Text(
                                                "#${queueList[index].id}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10,
                                                ),
                                              ),
                                              SizedBox(
                                                height: Sizer.getHeight(
                                                    height: .5,
                                                    context: context),
                                              ),
                                              Container(
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      height: Sizer.getHeight(
                                                          height: 6,
                                                          context: context),
                                                      width: Sizer.getWidth(
                                                          width: 3,
                                                          context: context),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                            color: Colors.black,
                                                          ),
                                                          image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image: NetworkImage(
                                                                  "http://190.160.15.118/queuing/images/${queueList[index].image}"))),
                                                    ),
                                                    SizedBox(
                                                      width: Sizer.getWidth(
                                                          width: 0.5,
                                                          context: context),
                                                    ),
                                                    Container(
                                                      width: Sizer.getWidth(
                                                          width: 60,
                                                          context: context),
                                                      height: Sizer.getHeight(
                                                          height: 6,
                                                          context: context),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            queueList[index]
                                                                    .firstname
                                                                    .capitalize() +
                                                                " " +
                                                                queueList[index]
                                                                    .lastname,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 10,
                                                            ),
                                                          ),
                                                          Text(
                                                            queueList[index]
                                                                .status,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 10,
                                                            ),
                                                          ),
                                                          Text(
                                                            DateFormat.yMMMMd()
                                                                    .format(queueList[
                                                                            index]
                                                                        .dateCreated) +
                                                                " " +
                                                                DateFormat.jm()
                                                                    .format(queueList[
                                                                            index]
                                                                        .dateCreated),
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 10,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      : index == 1
                          ?
                          ////////////////////////////////////////////////////////////////////////////////////
                          ////                           CASHIER                                          ////
                          ////////////////////////////////////////////////////////////////////////////////////
                          Container(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: Sizer.getHeight(
                                        height: 3, context: context),
                                  ),
                                  Container(
                                      padding: EdgeInsets.only(
                                          left: Sizer.getWidth(
                                              width: 5, context: context),
                                          right: Sizer.getWidth(
                                              width: 5, context: context)),
                                      child: TextField(
                                        controller: search,
                                        onChanged: (value) {
                                          if (_debounce?.isActive ?? false)
                                            _debounce!.cancel();
                                          _debounce = Timer(
                                              const Duration(milliseconds: 500),
                                              () {
                                            if (search.text.isEmpty ||
                                                search.text == "") {
                                              getCashier();
                                            } else {
                                              searchCashier(search.text);
                                            }
                                          });
                                        },
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: "Search",
                                        ),
                                      )),
                                  SizedBox(
                                    height: Sizer.getHeight(
                                        height: 3, context: context),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: Sizer.getWidth(
                                            width: 75, context: context),
                                        right: Sizer.getWidth(
                                            width: 5, context: context)),
                                    alignment: Alignment.centerRight,
                                    child: ButtonWidget(
                                        labelText: "Create",
                                        onPressFunction: () {
                                          showDialogCreateUser(
                                              usertype: "cashier");
                                        }),
                                  ),
                                  SizedBox(
                                    height: Sizer.getHeight(
                                        height: 3, context: context),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          left: Sizer.getWidth(
                                              width: 5, context: context),
                                          right: Sizer.getWidth(
                                              width: 5, context: context)),
                                      child: ListView.builder(
                                        itemCount: cashierList.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                                bottom: Sizer.getHeight(
                                                    height: 1,
                                                    context: context)),
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  left: Sizer.getWidth(
                                                      width: .5,
                                                      context: context),
                                                  right: Sizer.getWidth(
                                                      width: .5,
                                                      context: context)),
                                              height: Sizer.getHeight(
                                                  height: 10, context: context),
                                              width: Sizer.getWidth(
                                                  width: 100, context: context),
                                              color: Colors.lightBlue[50],
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        height: Sizer.getHeight(
                                                            height: 1,
                                                            context: context),
                                                      ),
                                                      Text(
                                                        "ID: ${cashierList[index].id}",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: Sizer.getHeight(
                                                            height: .5,
                                                            context: context),
                                                      ),
                                                      Container(
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              height: Sizer
                                                                  .getHeight(
                                                                      height: 6,
                                                                      context:
                                                                          context),
                                                              width: Sizer
                                                                  .getWidth(
                                                                      width: 3,
                                                                      context:
                                                                          context),
                                                              decoration:
                                                                  BoxDecoration(
                                                                      border:
                                                                          Border
                                                                              .all(
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                      image: DecorationImage(
                                                                          fit: BoxFit
                                                                              .cover,
                                                                          image:
                                                                              NetworkImage("http://190.160.15.118/queuing/images/${cashierList[index].image}"))),
                                                            ),
                                                            SizedBox(
                                                              width: Sizer
                                                                  .getWidth(
                                                                      width:
                                                                          0.5,
                                                                      context:
                                                                          context),
                                                            ),
                                                            Container(
                                                              width: Sizer
                                                                  .getWidth(
                                                                      width: 60,
                                                                      context:
                                                                          context),
                                                              height: Sizer
                                                                  .getHeight(
                                                                      height: 6,
                                                                      context:
                                                                          context),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    cashierList[index]
                                                                            .firstname
                                                                            .capitalize() +
                                                                        " " +
                                                                        cashierList[index]
                                                                            .lastname,
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          10,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    cashierList[
                                                                            index]
                                                                        .age,
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          10,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    cashierList[
                                                                            index]
                                                                        .address,
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          10,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    cashierList[
                                                                            index]
                                                                        .phoneno,
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          10,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  IconButton(
                                                      onPressed: () {
                                                        showDialogEditUser(
                                                            usertype: "cashier",
                                                            userData:
                                                                cashierList[
                                                                    index]);
                                                      },
                                                      icon: Icon(Icons
                                                          .mode_edit_outline_outlined))
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          : index == 2
                              ////////////////////////////////////////////////////////////////////////////////////
                              ////                           REGISTRAR                                        ////
                              ////////////////////////////////////////////////////////////////////////////////////
                              ? Container(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: Sizer.getHeight(
                                            height: 3, context: context),
                                      ),
                                      Container(
                                          padding: EdgeInsets.only(
                                              left: Sizer.getWidth(
                                                  width: 5, context: context),
                                              right: Sizer.getWidth(
                                                  width: 5, context: context)),
                                          child: TextField(
                                            controller: search,
                                            onChanged: (value) {
                                              if (_debounce?.isActive ?? false)
                                                _debounce!.cancel();
                                              _debounce = Timer(
                                                  const Duration(
                                                      milliseconds: 500), () {
                                                if (search.text.isEmpty ||
                                                    search.text == "") {
                                                  getRegistrar();
                                                } else {
                                                  searchRegistrar(search.text);
                                                }
                                              });
                                            },
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              hintText: "Search",
                                            ),
                                          )),
                                      SizedBox(
                                        height: Sizer.getHeight(
                                            height: 3, context: context),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: Sizer.getWidth(
                                                width: 75, context: context),
                                            right: Sizer.getWidth(
                                                width: 5, context: context)),
                                        alignment: Alignment.centerRight,
                                        child: ButtonWidget(
                                            labelText: "Create",
                                            onPressFunction: () {
                                              showDialogCreateUser(
                                                  usertype: "registrar");
                                            }),
                                      ),
                                      SizedBox(
                                        height: Sizer.getHeight(
                                            height: 3, context: context),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              left: Sizer.getWidth(
                                                  width: 5, context: context),
                                              right: Sizer.getWidth(
                                                  width: 5, context: context)),
                                          child: ListView.builder(
                                            itemCount: registrarList.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: Sizer.getHeight(
                                                        height: 1,
                                                        context: context)),
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      left: Sizer.getWidth(
                                                          width: .5,
                                                          context: context),
                                                      right: Sizer.getWidth(
                                                          width: .5,
                                                          context: context)),
                                                  height: Sizer.getHeight(
                                                      height: 10,
                                                      context: context),
                                                  width: Sizer.getWidth(
                                                      width: 100,
                                                      context: context),
                                                  color: Colors.lightBlue[50],
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            height:
                                                                Sizer.getHeight(
                                                                    height: 1,
                                                                    context:
                                                                        context),
                                                          ),
                                                          Text(
                                                            "ID: ${registrarList[index].id}",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 10,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height:
                                                                Sizer.getHeight(
                                                                    height: .5,
                                                                    context:
                                                                        context),
                                                          ),
                                                          Container(
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  height: Sizer
                                                                      .getHeight(
                                                                          height:
                                                                              6,
                                                                          context:
                                                                              context),
                                                                  width: Sizer
                                                                      .getWidth(
                                                                          width:
                                                                              3,
                                                                          context:
                                                                              context),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                          border: Border
                                                                              .all(
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                          image: DecorationImage(
                                                                              fit: BoxFit.cover,
                                                                              image: NetworkImage("http://190.160.15.118/queuing/images/${registrarList[index].image}"))),
                                                                ),
                                                                SizedBox(
                                                                  width: Sizer.getWidth(
                                                                      width:
                                                                          0.5,
                                                                      context:
                                                                          context),
                                                                ),
                                                                Container(
                                                                  width: Sizer
                                                                      .getWidth(
                                                                          width:
                                                                              60,
                                                                          context:
                                                                              context),
                                                                  height: Sizer
                                                                      .getHeight(
                                                                          height:
                                                                              6,
                                                                          context:
                                                                              context),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        registrarList[index].firstname.capitalize() +
                                                                            " " +
                                                                            registrarList[index].lastname,
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontSize:
                                                                              10,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        registrarList[index]
                                                                            .age,
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontSize:
                                                                              10,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        registrarList[index]
                                                                            .address,
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontSize:
                                                                              10,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        registrarList[index]
                                                                            .phoneno,
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontSize:
                                                                              10,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      IconButton(
                                                          onPressed: () {
                                                            showDialogEditUser(
                                                                usertype:
                                                                    "registrar",
                                                                userData:
                                                                    registrarList[
                                                                        index]);
                                                          },
                                                          icon: Icon(Icons
                                                              .mode_edit_outline_outlined))
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : index == 3
                                  ?
                                  ////////////////////////////////////////////////////////////////////////////////////
                                  ////                           CUSTOMER                                         ////
                                  ////////////////////////////////////////////////////////////////////////////////////
                                  Container(
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: Sizer.getHeight(
                                                height: 3, context: context),
                                          ),
                                          Container(
                                              padding: EdgeInsets.only(
                                                  left: Sizer.getWidth(
                                                      width: 5,
                                                      context: context),
                                                  right: Sizer.getWidth(
                                                      width: 5,
                                                      context: context)),
                                              child: TextField(
                                                controller: search,
                                                onChanged: (value) {
                                                  if (_debounce?.isActive ??
                                                      false)
                                                    _debounce!.cancel();
                                                  _debounce = Timer(
                                                      const Duration(
                                                          milliseconds: 500),
                                                      () {
                                                    if (search.text.isEmpty ||
                                                        search.text == "") {
                                                      getCustomer();
                                                    } else {
                                                      searchCustomer(
                                                          search.text);
                                                    }
                                                  });
                                                },
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  hintText: "Search",
                                                ),
                                              )),
                                          SizedBox(
                                            height: Sizer.getHeight(
                                                height: 3, context: context),
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  left: Sizer.getWidth(
                                                      width: 5,
                                                      context: context),
                                                  right: Sizer.getWidth(
                                                      width: 5,
                                                      context: context)),
                                              child: ListView.builder(
                                                itemCount: customerList.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: Sizer.getHeight(
                                                            height: 1,
                                                            context: context)),
                                                    child: Container(
                                                      padding: EdgeInsets.only(
                                                          left: Sizer.getWidth(
                                                              width: .5,
                                                              context: context),
                                                          right: Sizer.getWidth(
                                                              width: .5,
                                                              context:
                                                                  context)),
                                                      height: Sizer.getHeight(
                                                          height: 10,
                                                          context: context),
                                                      width: Sizer.getWidth(
                                                          width: 100,
                                                          context: context),
                                                      color:
                                                          Colors.lightBlue[50],
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SizedBox(
                                                                height: Sizer
                                                                    .getHeight(
                                                                        height:
                                                                            1,
                                                                        context:
                                                                            context),
                                                              ),
                                                              Text(
                                                                "ID: ${customerList[index].id}",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 10,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: Sizer
                                                                    .getHeight(
                                                                        height:
                                                                            .5,
                                                                        context:
                                                                            context),
                                                              ),
                                                              Container(
                                                                child: Row(
                                                                  children: [
                                                                    Container(
                                                                      height: Sizer.getHeight(
                                                                          height:
                                                                              6,
                                                                          context:
                                                                              context),
                                                                      width: Sizer.getWidth(
                                                                          width:
                                                                              3,
                                                                          context:
                                                                              context),
                                                                      decoration: BoxDecoration(
                                                                          border: Border.all(
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                          image: DecorationImage(fit: BoxFit.cover, image: NetworkImage("http://190.160.15.118/queuing/images/${customerList[index].image}"))),
                                                                    ),
                                                                    SizedBox(
                                                                      width: Sizer.getWidth(
                                                                          width:
                                                                              0.5,
                                                                          context:
                                                                              context),
                                                                    ),
                                                                    Container(
                                                                      width: Sizer.getWidth(
                                                                          width:
                                                                              60,
                                                                          context:
                                                                              context),
                                                                      height: Sizer.getHeight(
                                                                          height:
                                                                              6,
                                                                          context:
                                                                              context),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            customerList[index].firstname.capitalize() +
                                                                                " " +
                                                                                customerList[index].lastname,
                                                                            style:
                                                                                TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 10,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            customerList[index].age,
                                                                            style:
                                                                                TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 10,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            customerList[index].address,
                                                                            style:
                                                                                TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 10,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            customerList[index].phoneno,
                                                                            style:
                                                                                TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 10,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          IconButton(
                                                              onPressed: () {
                                                                showDialogEditUser(
                                                                    usertype:
                                                                        "customer",
                                                                    userData:
                                                                        customerList[
                                                                            index]);
                                                              },
                                                              icon: Icon(Icons
                                                                  .mode_edit_outline_outlined))
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  : Container(
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: Sizer.getHeight(
                                                height: 2, context: context),
                                          ),
                                          Container(
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: Sizer.getWidth(
                                                      width: 4,
                                                      context: context),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey[200],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4)),
                                                  padding:
                                                      EdgeInsets.only(left: 10),
                                                  height: 40,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.10,
                                                  child: DropdownButton(
                                                    underline: SizedBox(),
                                                    isExpanded: true,
                                                    value: selectedYear,
                                                    onChanged: (newValue) {
                                                      setState(() {
                                                        selectedYear =
                                                            newValue!;
                                                        getDataForAnalytics();
                                                      });
                                                    },
                                                    items: year.map((data) {
                                                      return DropdownMenuItem(
                                                        child: new Text(data),
                                                        value: data,
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: Sizer.getWidth(
                                                      width: 2,
                                                      context: context),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey[200],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4)),
                                                  padding:
                                                      EdgeInsets.only(left: 10),
                                                  height: 40,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.10,
                                                  child: DropdownButton(
                                                    underline: SizedBox(),
                                                    isExpanded: true,
                                                    value: selectedMonth,
                                                    onChanged: (newValue) {
                                                      setState(() {
                                                        selectedMonth =
                                                            newValue!;
                                                        for (var i = 0;
                                                            i < months.length;
                                                            i++) {
                                                          if (months[i]
                                                                  .monthname ==
                                                              selectedMonth) {
                                                            selectedMonthNumber =
                                                                months[i]
                                                                    .number;
                                                          }
                                                        }
                                                      });
                                                      getDataForAnalytics();
                                                    },
                                                    items:
                                                        months.map((location) {
                                                      return DropdownMenuItem(
                                                        child: new Text(
                                                            location.monthname),
                                                        value:
                                                            location.monthname,
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: Sizer.getHeight(
                                                height: 15, context: context),
                                          ),
                                          SfCartesianChart(
                                            primaryXAxis: CategoryAxis(),
                                            primaryYAxis: NumericAxis(
                                                minimum: 0,
                                                maximum: 100,
                                                interval: 10),
                                            tooltipBehavior: tooltip,
                                            series: <
                                                ChartSeries<ChartData, String>>[
                                              BarSeries<ChartData, String>(
                                                  dataSource: data,
                                                  xValueMapper:
                                                      (ChartData data, _) =>
                                                          data.x,
                                                  yValueMapper:
                                                      (ChartData data, _) =>
                                                          data.y,
                                                  name: 'Count',
                                                  color: Color.fromRGBO(
                                                      8, 142, 255, 1))
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                ),
              ],
            )),
    );
  }
}
