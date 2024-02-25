import 'package:flutter/material.dart';
import 'package:tsa_software_2024/data/data_manager.dart';

class MedicineView extends StatefulWidget {
  const MedicineView({super.key});

  @override
  State<StatefulWidget> createState() => MedicineViewState();
}

class MedicineViewState extends State<MedicineView> with RouteAware {
  var future = getAppData();

  @override
  void didPopNext() {
    super.didPopNext();
    setState(() {
      future = getAppData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<AppData>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data;
            return ListView(
              children: data!.medications.asMap().map((index, e) => MapEntry(index, ListTile(
                title: Text(e.name!),
                trailing: Checkbox(
                  value: e.enabled,
                  onChanged: (value) async {
                    var newData = await getAppData();
                    newData.medications[index].enabled = value!;
                    saveAppData(newData);
                    setState(() {
                      future = getAppData();
                    });
                  },
                ),
              ))).values.toList() as List<Widget>
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error!}");
          } else {
            return Container();
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, "/add_medicine");
          },
          label: const Text("Add Medicine"),
          icon: const Icon(Icons.add)
      ),
    );
  }
}