import 'package:flutter/material.dart';
import 'package:my_first_app/models/activity_model.dart';
import 'package:my_first_app/providers/city_provider.dart';
import 'activity_form_autocomplete.dart';
import 'activity_form_image_picker.dart';
import 'package:provider/provider.dart';

class ActivityForm extends StatefulWidget {
  final String cityName;
  ActivityForm({this.cityName});
  @override
  _ActivityFormState createState() => _ActivityFormState();
}

class _ActivityFormState extends State<ActivityForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode _priceFocusNode;
  FocusNode _urlFocusNode;
  FocusNode _addressFocusNode;
  Activity _newActivity;
  String _nameInputAsync;
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool _isLoading = false;
  FormState get form {
    return _formKey.currentState;
  }

  @override
  void initState() {
    _newActivity = Activity(
      city: widget.cityName,
      name: null,
      price: 0,
      image: null,
      location: LocationActivity(
        // address: null,
        longitude: null,
        latitude: null,
      ),
      status: ActivityStatus.ongoing,
    );
    _priceFocusNode = FocusNode();
    _urlFocusNode = FocusNode();
    _addressFocusNode = FocusNode();
    _addressFocusNode.addListener(() async {
      if (_addressFocusNode.hasFocus) {
        print('focus');
        var location = await showInputAutocomplete(context);
        _newActivity.location = location;
        setState(() {
          _addressController.text = location.address;
        });
      } else {
        print('no focus');
      }
    });
    super.initState();
  }

  void updateUrlField(String url) {
    setState(() {
      _urlController.text = url;
    });
  }

  Future<void> submitForm() async {
    try {
      CityProvider cityProvider = Provider.of<CityProvider>(
        context,
        listen: false,
      );
      _formKey.currentState.save();
      setState(() => _isLoading = true);
      _nameInputAsync = await cityProvider.verifyIfActivityNameIsUnique(
        widget.cityName,
        _newActivity.name,
      );
      if (form.validate()) {
        await cityProvider.addActivityToCity(_newActivity);
        Navigator.pop(context);
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _urlFocusNode.dispose();
    _addressFocusNode.dispose();
    _urlController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              autofocus: true,
              validator: (value) {
                if (value.isEmpty)
                  return 'Champ obligatoire';
                else if (_nameInputAsync != null) return _nameInputAsync;
                return null;
              },
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                // hintText: 'Nom',
                labelText: 'Nom',
              ),
              onSaved: (value) => _newActivity.name = value,
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_priceFocusNode),
            ),
            SizedBox(height: 30),
            TextFormField(
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value.isEmpty) return 'Champ obligatoire';
                return null;
              },
              textInputAction: TextInputAction.next,
              focusNode: _priceFocusNode,
              decoration: InputDecoration(
                labelText: 'Prix',
              ),
              onSaved: (value) => _newActivity.price = double.parse(value),
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_urlFocusNode),
            ),
            SizedBox(height: 30),
            TextFormField(
              focusNode: _addressFocusNode,
              controller: _addressController,
              decoration: InputDecoration(
                hintText: 'Adresse',
              ),
              onSaved: (value) => _newActivity.location.address = value,
            ),
            SizedBox(height: 30),
            TextFormField(
              keyboardType: TextInputType.url,
              validator: (value) {
                if (value.isEmpty) return 'Champ obligatoire';
                return null;
              },
              focusNode: _urlFocusNode,
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'Url image',
              ),
              onSaved: (value) => _newActivity.image = value,
            ),
            SizedBox(height: 10),
            ActivityFormImagePicker(updateUrl: updateUrlField),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: _isLoading ? null : submitForm,
                  child: Text('Ajouter'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Annuler'),
                  style: TextButton.styleFrom(
                    primary: Colors.grey[600],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
