import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_first_app/views/city/widgets/trio_overview_city.dart';
import '../../../models/trip_model.dart';

class TripOverview extends StatelessWidget {
  final Function setDate;
  final Trip trip;
  final String cityName;
  final String cityImage;
  final double amount;

  const TripOverview({
    this.setDate,
    this.trip,
    this.cityName,
    this.cityImage,
    this.amount,
  });

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    var size = MediaQuery.of(context).size;
    return Container(
      width:
          orientation == Orientation.landscape ? size.width * 0.5 : size.width,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TripOviewCity(
            cityName: cityName,
            cityImage: cityImage,
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    trip.date != null
                        ? DateFormat("dd/MM/yy").format(trip.date)
                        : 'Choississez une date',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                ElevatedButton(
                  child: const Text('Selectionner une date'),
                  onPressed: setDate,
                )
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              children: [
                Expanded(
                  child: const Text(
                    'Montant / personne : ',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                Text(
                  '$amount €',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
