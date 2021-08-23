import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_first_app/views/activity-form/activity_form_view.dart';
import 'package:provider/provider.dart';
import './providers/city_provider.dart';
import './providers/trip_provider.dart';

import './views/home/home_view.dart';
import './views/city/city_view.dart';
import './views/trips/trips_view.dart';
import './views/trip/trip_view.dart';
import './views/not-found/not_found.dart';

main() {
  runApp(HexaTrip());
}

class HexaTrip extends StatefulWidget {
  @override
  _HexaTripState createState() => _HexaTripState();
}

class _HexaTripState extends State<HexaTrip> {
  final CityProvider cityProvider = CityProvider();
  final TripProvider tripProvider = TripProvider();

  @override
  void initState() {
    cityProvider.fetchData();
    tripProvider.fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.pink,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
    ));
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: cityProvider),
        ChangeNotifierProvider.value(value: tripProvider),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.pink,
          appBarTheme: AppBarTheme(
            brightness: Brightness.dark,
            textTheme: ThemeData.light().textTheme.copyWith(
                  headline6: TextStyle(fontSize: 30),
                ),
          ),
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  color: Colors.pink,
                ),
              ),
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (_) => HomeView(),
          CityView.routeName: (_) => CityView(),
          TripsView.routeName: (_) => TripsView(),
          TripView.routeName: (_) => TripView(),
          ActivityFormView.routeName: (_) => ActivityFormView(),
        },
        onUnknownRoute: (_) => MaterialPageRoute(builder: (_) => NotFound()),
      ),
    );
  }
}
