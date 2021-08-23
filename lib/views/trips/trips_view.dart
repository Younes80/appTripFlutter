import 'package:flutter/material.dart';
import 'package:my_first_app/providers/trip_provider.dart';
import 'package:my_first_app/views/trips/widgets/trip_list.dart';
import 'package:my_first_app/widgets/hexa_loader.dart';
import 'package:provider/provider.dart';
import '../../widgets/hexa_drawer.dart';

class TripsView extends StatelessWidget {
  static const String routeName = '/trips';
  @override
  Widget build(BuildContext context) {
    TripProvider tripProvider = Provider.of<TripProvider>(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mes voyages'),
          bottom: const TabBar(
            tabs: [
              const Tab(
                text: 'A venir',
              ),
              const Tab(
                text: 'Passés',
              ),
            ],
          ),
        ),
        drawer: const HexaDrawer(),
        body: tripProvider.isLoading != true
            ? tripProvider.trips.length > 0
                ? TabBarView(
                    children: [
                      TripList(
                        trips: tripProvider.trips
                            .where((trip) => DateTime.now().isBefore(trip.date))
                            .toList(),
                      ),
                      TripList(
                        trips: tripProvider.trips
                            .where((trip) => DateTime.now().isAfter(trip.date))
                            .toList(),
                      ),
                    ],
                  )
                : Container(
                    alignment: Alignment.center,
                    child: Text('Aucun voyage pour le moment'),
                  )
            : HexaLoader(),
      ),
    );
  }
}
