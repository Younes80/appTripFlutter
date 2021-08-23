import 'dart:math';
import 'package:flutter/material.dart';
import '../../../models/activity_model.dart';

class TripActivityCard extends StatefulWidget {
  final Activity activity;
  final Function deleteActivity;

  Color getColor() {
    const colors = [Colors.blue, Colors.red];
    return colors[Random().nextInt(2)];
  }

  const TripActivityCard({Key key, this.activity, this.deleteActivity})
      : super(key: key);

  @override
  _TripActivityCardState createState() => _TripActivityCardState();
}

class _TripActivityCardState extends State<TripActivityCard> {
  Color color;

  @override
  void initState() {
    color = widget.getColor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(widget.activity.image),
        ),
        title: Text(
          widget.activity.name,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(widget.activity.city),
        trailing: IconButton(
          icon: Icon(
            Icons.delete,
            color: Colors.red[700],
          ),
          onPressed: () {
            widget.deleteActivity(widget.activity.id);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Activité supprimée'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 1),
            ));
          },
        ),
      ),
    );
  }
}
