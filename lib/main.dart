import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:my_assistant/db_helper.dart';
import 'package:my_assistant/request_model.dart';
import 'package:my_assistant/trips_list.dart';
import 'package:share_plus/share_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Assistant',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  RequestModel? requestModel;
  MyHomePage({Key? key, this.requestModel}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String vehicleType = '';
  late List<String> jobTypeList;
  late List<String> readyJobsList;
  late String selectedJobType;
  late List<String> plsList;
  late String selectedPl;
  late List<String> requestersList;
  late String selectedRequester;
  late List<String> driversList;
  late String selectedDriver;
  late List<String> dateList;
  late String selectedDate;
  late List<String> vehicleTypeList;
  late String yesterday;
  late String today;
  late String tomorrow;
  late TextEditingController startPointText,
      endPointText,
      dateText,
      timeText,
      contactText,
  requesterText,
      costText,
      notesText;

  @override
  void initState() {
    super.initState();

    DateTime now = DateTime.now();
    yesterday = DateFormat('yyyy-MM-dd').format(DateTime(now.year, now.month, now.day - 1));
    today = DateFormat('yyyy-MM-dd').format(now);
    tomorrow = DateFormat('yyyy-MM-dd').format(DateTime(now.year, now.month, now.day + 1));

    jobTypeList = [
      'Select Job type',
      'delivery',
      'backload',
      'shifting',
    ];

    plsList = [
      'Select Product line',
      'WCT',
      'DS',
      'Rental',
      'Fishing',
      'WL',
      'Thru Tubing',
      'TRS',
      'Liner Hanger',
      'ALS',
      'SDS',
      'JAR',
      'M/S',
      'Coil Tubing',
    ];

    driversList = [
      'Select driver',
      'SMGT',
      'Cardiff',
      'Gurwinder',
      'Wasim',
      'Mina',
      'Mohamed Tariq'
      'Mazid',
      'Anwar',
      'Tarik',
      'Saleem',
      'Aman',
      'Nek Salam',
      'Hidayat',
      'Zahid',
      'Bakhet',
      'Saba',
      'Zakir',
      'Nek Zali',
      'Banaras'
    ];

    vehicleTypeList = [
      'Double Cabin',
      '6x6 Trailer',
      '40ft Trailer',
    ];

    startPointText = TextEditingController();
    endPointText = TextEditingController();
    dateText = TextEditingController();
    timeText = TextEditingController();
    contactText = TextEditingController();
    requesterText = TextEditingController();
    costText = TextEditingController();
    notesText = TextEditingController();

    if (widget.requestModel == null) {
      print('requestModel null');
      selectedJobType = jobTypeList[0];
      selectedPl = plsList[0];
      //selectedRequester = requestersList[0];
      selectedDriver = driversList[0];
      dateList = [today, yesterday, tomorrow];
      selectedDate = dateList[0];
    } else {
      print('requestModel not null');
      dateList = {widget.requestModel!.Date!, today, yesterday, tomorrow}.toList();
      selectedDate = dateList[0];
      selectedJobType = jobTypeList[0];
      selectedPl = widget.requestModel!.Product_Line!;
      requesterText.text = widget.requestModel!.Requester!;
      selectedDriver = widget.requestModel!.Vender!;
      startPointText.text = widget.requestModel!.start_point!;
      endPointText.text = widget.requestModel!.end_point!;
      costText.text = widget.requestModel!.Cost!;
      notesText.text = widget.requestModel!.Notes!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: (() {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => const TripsList()));
            }),
            icon: const Icon(
              Icons.menu,
              color: Colors.black,
            ),
          ),
        ],
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.white, statusBarIconBrightness: Brightness.dark),
        backgroundColor: Colors.white,
        elevation: .5,
        title: const Text(
          'My Assistant',
          style: TextStyle(color: Colors.black, fontFamily: 'Robot'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0) + const EdgeInsets.only(top: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: defaultTextField(
                      context: context,
                      text: 'Start point',
                      controller: startPointText,
                      onSubmitted: null,
                      prefixIcon: Icons.location_on,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: defaultTextField(
                      context: context,
                      text: 'End point',
                      controller: endPointText,
                      onSubmitted: null,
                      prefixIcon: Icons.location_on,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton<String>(
                    value: selectedPl,
                    items: plsList.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(value),
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedPl = newValue!;
                      });
                    },
                  ),
                  DropdownButton<String>(
                    value: selectedJobType,
                    items: jobTypeList.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(value),
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedJobType = newValue!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: DropdownButton<String>(
                      value: selectedDate,
                      items: dateList.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(value),
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedDate = newValue!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: defaultTextField(
                      context: context,
                      text: 'Time',
                      controller: timeText,
                      onSubmitted: null,
                      prefixIcon: Icons.watch_later,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              defaultTextField(
                context: context,
                text: 'Contact',
                controller: contactText,
                onSubmitted: null,
                prefixIcon: Icons.contact_phone,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: defaultTextField(
                      context: context,
                      text: 'Requester',
                      controller: requesterText,
                      onSubmitted: null,
                      prefixIcon: Icons.person,
                    )
                    /*DropdownButton<String>(
                      value: selectedRequester,
                      items: requestersList.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(value),
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedRequester = newValue!;
                        });
                      },
                    ),*/
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: defaultTextField(
                      context: context,
                      text: 'Cost',
                      controller: costText,
                      onSubmitted: null,
                      prefixIcon: Icons.currency_pound,
                      keyboardType: TextInputType.number
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              defaultTextField(
                context: context,
                text: 'Notes',
                controller: notesText,
                onSubmitted: null,
                prefixIcon: Icons.notes,
              ),
              const SizedBox(
                height: 10,
              ),
              DropdownButton<String>(
                value: selectedDriver,
                items: driversList.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(value),
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedDriver = newValue!;
                  });
                },
              ),
              const SizedBox(
                height: 30,
              ),
              Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    ElevatedButton(
                        onPressed: (() {
                          int driverIndex = driversList.indexWhere((element) {
                            return element == selectedDriver;
                          });
                          if (driverIndex == 1) {
                            vehicleType = vehicleTypeList[2];

                          }
                          else if (driverIndex == 2 || driverIndex == 3){
                            vehicleType = vehicleTypeList[1];
                          }
                          else {
                            vehicleType = vehicleTypeList[0];
                          }
                          RequestModel requestModel = RequestModel(
                              Product_Line: selectedPl,
                              Vender: selectedDriver,
                              Vehicle_type: vehicleType,
                              start_point: startPointText.text.trim(),
                              end_point: endPointText.text.trim(),
                              Date: selectedDate,
                              Requester: requesterText.text.trim(),
                              Cost: costText.text.trim(),
                              Notes: notesText.text.trim());
                          save(requestModel);
                        }),
                        child: const Text('Save & Send')),
                     SizedBox(width: 50,),
                    ElevatedButton(
                        onPressed: (() {
                          dateList = {today, yesterday, tomorrow}.toList();
                          selectedDate = dateList[0];
                          selectedJobType = jobTypeList[0];
                          selectedPl = plsList[0];
                          requesterText.text = "";
                          selectedDriver = driversList[0];
                          startPointText.text = "";
                          endPointText.text = "";
                          costText.text = "";
                          notesText.text = "";
                        }),
                        child: const Text('Clear'))
                  ],
                  ),
              ),
              SizedBox(height: 60,),
              DropdownButton<String>(
                value: selectedDriver,
                items: driversList.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(value),
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedDriver = newValue!;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void save(RequestModel requestModel) async {
    if (widget.requestModel == null) {
      DBHelper.insert(requestModel).whenComplete(() => share());
    } else {
      DBHelper.updateItem(requestModel: requestModel, id: widget.requestModel!.id!)
          .whenComplete(() {
        Navigator.pop(context);
      });
    }
  }

  void share() {
    Share.share(
      'from ${startPointText.text} to ${endPointText.text} ${timeText.text}\n${requesterText.text} ${contactText.text}',
    );
  }

  Widget defaultTextField({
    required BuildContext context,
    required String text,
    required TextEditingController controller,
    keyboardType = TextInputType.text,
    isPassword = false,
    required void Function(String)? onSubmitted,
    required IconData prefixIcon,
    IconData? suffixIcon,
    void Function()? onSuffixPressed,
    String? validateText,
    void Function()? onTap,
    bool enabled = true,
    void Function(String)? onChanged,
    FocusNode? focusNode,
    bool autofocus = true,
  }) =>
      TextFormField(
        autofocus: autofocus,
        focusNode: focusNode,
        onChanged: onChanged,
        enabled: enabled,
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword,
        onFieldSubmitted: onSubmitted,
        textInputAction: TextInputAction.next,
        validator: (value) {
          if (value!.isEmpty) {
            return validateText;
          }
          return null;
        },
        onTap: onTap,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.all(12),
            hintText: text,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), gapPadding: 1),
            prefixIcon: Icon(prefixIcon),
            suffixIcon: suffixIcon != null
                ? (IconButton(onPressed: onSuffixPressed, icon: Icon(suffixIcon)))
                : null),
      );
}
