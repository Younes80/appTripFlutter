import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/city_provider.dart';
import '../../widgets/hexa_loader.dart';
import '../../widgets/hexa_drawer.dart';
import '../../models/city_model.dart';
import './widgets/city_card.dart';

class HomeView extends StatefulWidget {
  static const String routeName = '/';

  @override
  _HomeState createState() {
    return _HomeState();
  }
}

class _HomeState extends State<HomeView> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CityProvider cityProvider = Provider.of<CityProvider>(context);
    List<City> filteredCities =
        cityProvider.getFilteredCities(searchController.text);
    return Scaffold(
      appBar: AppBar(
        title: const Text('HexaTrip'),
      ),
      drawer: const HexaDrawer(),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.symmetric(
              horizontal: 14,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Rechercher une ville',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    setState(() => searchController.clear());
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10.00),
              child: RefreshIndicator(
                onRefresh: Provider.of<CityProvider>(context).fetchData,
                child: cityProvider.isLoading
                    ? HexaLoader()
                    : filteredCities.length > 0
                        ? ListView.builder(
                            itemCount: filteredCities.length,
                            itemBuilder: (_, i) =>
                                CityCard(city: filteredCities[i]),
                          )
                        : Text('Aucun résultat'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
