import 'package:flutter/material.dart';
import 'package:my_first_app/providers/city_provider.dart';
import 'package:my_first_app/providers/trip_provider.dart';
import 'package:my_first_app/views/activity-form/activity_form_view.dart';
import 'package:provider/provider.dart';
import '../../widgets/hexa_drawer.dart';

import '../../views/home/home_view.dart';

import '../../models/city_model.dart';
import '../../models/trip_model.dart';
import '../../models/activity_model.dart';

import './widgets/trip_overview.dart';
import './widgets/activity_list.dart';
import './widgets/trip_activity_list.dart';

class CityView extends StatefulWidget {
  static const String routeName = '/city';

  showContext({BuildContext context, List<Widget> children}) {
    var orientation = MediaQuery.of(context).orientation;

    if (orientation == Orientation.landscape) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      );
    } else {
      return Column(children: children);
    }
  }

  @override
  _CityState createState() => _CityState();
}

class _CityState extends State<CityView> with WidgetsBindingObserver {
  Trip mytrip;
  int index;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    index = 0;
    mytrip = Trip(
      activities: [],
      city: null,
      date: null,
    );
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
  }

  double get amount {
    double initialPrice = 0;
    return mytrip.activities.fold(initialPrice, (prev, element) {
      return prev + element.price;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print(state);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  void setDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2022),
    ).then((newDate) {
      if (newDate != null) {
        setState(() {
          mytrip.date = newDate;
        });
      }
    });
  }

  void switchIndex(newIndex) {
    setState(() {
      index = newIndex;
    });
  }

  void toggleActivity(Activity activity) {
    setState(() {
      mytrip.activities.contains(activity)
          ? mytrip.activities.remove(activity)
          : mytrip.activities.add(activity);
    });
  }

  void deleteTripActivity(Activity activity) {
    setState(() {
      mytrip.activities.remove(activity);
    });
  }

  void saveTrip(String cityName) async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text(
            'Voulez-vous sauvegarder ?',
          ),
          contentPadding: const EdgeInsets.all(10),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, 'cancel');
                  },
                  child: const Text('annuler'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.grey),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, 'save');
                  },
                  child: const Text('sauvegarder'),
                ),
              ],
            ),
          ],
        );
      },
    );
    if (mytrip.date == null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Attention !'),
            content: const Text('Vous devez renseigner une date'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('ok'),
              )
            ],
          );
        },
      );
    } else if (result == 'save') {
      // widget.addTrip(mytrip);
      mytrip.city = cityName;
      Provider.of<TripProvider>(context, listen: false).addTrip(mytrip);
      Navigator.pushNamed(context, HomeView.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    String cityName = ModalRoute.of(context).settings.arguments;
    City city = Provider.of<CityProvider>(context).getCityByName(cityName);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organisation voyage'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(
                context, ActivityFormView.routeName,
                arguments: cityName,),
          ),
        ],
      ),
      drawer: const HexaDrawer(),
      body: Container(
        child: Column(
          children: <Widget>[
            TripOverview(
              cityName: city.name,
              trip: mytrip,
              setDate: setDate,
              amount: amount,
              cityImage: city.image,
            ),
            Expanded(
              child: index == 0
                  ? ActivityList(
                      activities: city.activities,
                      selectedActivities: mytrip.activities,
                      toggleActivity: toggleActivity,
                    )
                  : TripActivityList(
                      activities: mytrip.activities,
                      deleteActivity: deleteTripActivity,
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.forward),
        onPressed: () {
          saveTrip(city.name);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        items: [
          const BottomNavigationBarItem(
            icon: const Icon(Icons.map),
            label: 'Découverte',
          ),
          const BottomNavigationBarItem(
            icon: const Icon(Icons.stars),
            label: 'Mes activités',
          ),
        ],
        onTap: switchIndex,
      ),
    );
  }
}
