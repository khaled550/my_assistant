import 'package:flutter/material.dart';
import 'package:my_assistant/db_helper.dart';
import 'package:my_assistant/main.dart';
import 'package:my_assistant/request_model.dart';

class TripsList extends StatefulWidget {
  const TripsList({Key? key}) : super(key: key);

  @override
  State<TripsList> createState() => _TripsListState();
}

class _TripsListState extends State<TripsList> {
  List<RequestModel> requests = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTripsData();
  }

  void getTripsData() {
    DBHelper.getTasksFromDB().then((value) {
      value.sort((a, b) => b.Date!.compareTo(a.Date!));
      requests = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (() {
            Navigator.pop(context);
          }),
          icon: const Icon(Icons.close),
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        elevation: .5,
        title: const Text(
          'My Assistant',
          style: TextStyle(color: Colors.black, fontFamily: 'Robot'),
        ),
      ),
      body: _buildTripsList(requests),
    );
  }

  Widget _buildTripsList(List<RequestModel> requests) {
    if (requests.isEmpty) {
      return const Center(child: Text('No data'));
    }
    String trip = '';
    return ListView.separated(
      itemCount: requests.length,
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          print('item id: ${requests[index].id}');
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => MyHomePage(
                        requestModel: requests[index],
                      )))
              .then((_) => getTripsData());
        },
        title: Text(requests[index].Vender!),
        subtitle: Text(
            '${requests[index].Date} - ${requests[index].Product_Line} - ${requests[index].start_point} to ${requests[index].end_point}'),
      ),
      separatorBuilder: (context, index) {
        //if (index == 0) return const SizedBox.shrink();
        if (requests[index].Date != requests[index + 1].Date) {
          return const Divider(
            thickness: 2,
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

/* class ExportCsv {
  final List data;
  ExportCsv({required this.data});

  List<List<dynamic>> rows = [];
  downloadData() {
    for (int i = 0; i < data.length; i++) {
      List<dynamic> row = [];
      row.add(data[i].userName);
      row.add(data[i].userLastName);
      row.add(data[i].userEmail);
      rows.add(row);
    }

    String csv = const ListToCsvConverter().convert(rows);
    new AnchorElement(href: "data:text/plain;charset=utf-8,$csv")
      ..setAttribute("download", "data.csv")
      ..click();
  }
} */
