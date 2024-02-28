import 'package:flutter/material.dart';
import 'package:tsa_software_2024/data/data_manager.dart';
import 'package:tsa_software_2024/routes/arguments/arguments.dart';
import 'package:tsa_software_2024/widgets/medicine/medicine_overview.dart';

class MedicineView extends StatefulWidget {
  final RouteObserver<ModalRoute> routeObserver;
  const MedicineView({super.key, required this.routeObserver});

  @override
  State<StatefulWidget> createState() => MedicineViewState();
}

class MedicineViewState extends State<MedicineView> with RouteAware {
  var future = getAppData();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    super.dispose();
    widget.routeObserver.unsubscribe(this);
  }

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
                title: Text(e.name!, style: (!e.enabled)
                  ? const TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough)
                  : const TextStyle(),),
                leading: Checkbox(
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
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    Navigator.pushNamed(context, "/add_medicine", arguments: AddMedicineArguments(medicine: e));
                  },
                ),
                onTap: () async {
                  await showModalBottomSheet(
                      context: context,
                      showDragHandle: true,
                      builder: (context) {
                        return MedicineOverview(parent: e);
                      }
                  );
                },
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