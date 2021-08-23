import 'package:flutter/material.dart';
import '../../trip/widgets/trip_activity_list.dart';
import '../../../models/activity_model.dart';

class TripActivities extends StatelessWidget {
  final String tripId;
  TripActivities({this.tripId});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              child: TabBar(labelColor: Theme.of(context).primaryColor, tabs: [
                const Tab(
                  text: 'En cours',
                ),
                const Tab(
                  text: 'Terminé',
                ),
              ]),
            ),
            Container(
              height: 600,
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  TripActivityList(
                    tripId: tripId,
                    filter: ActivityStatus.ongoing,
                  ),
                  TripActivityList(
                    tripId: tripId,
                    filter: ActivityStatus.done,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
