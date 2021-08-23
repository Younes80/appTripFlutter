import 'package:flutter/material.dart';
import '../widgets/trip_activity_card.dart';
import '../../../models/activity_model.dart';

class TripActivityList extends StatelessWidget {
  final List<Activity> activities;
  final Function deleteActivity;

  const TripActivityList({this.activities, this.deleteActivity});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: activities
            .map(
              (activity) => TripActivityCard(
                key: ValueKey(activity.id),
                activity: activity,
                deleteActivity: deleteActivity,
              ),
            )
            .toList(),
      ),
    );
  }
}
