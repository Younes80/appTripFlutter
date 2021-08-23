import 'package:flutter/material.dart';
import '../activity-form/widgets/activity_form.dart';
import '../../widgets/hexa_drawer.dart';

class ActivityFormView extends StatelessWidget {
  static const String routeName = '/activity-form';

  @override
  Widget build(BuildContext context) {
    String cityName = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter une activité'),
      ),
      drawer: HexaDrawer(),
      body: Container(
        child: ActivityForm(cityName: cityName),
      ),
    );
  }
}
