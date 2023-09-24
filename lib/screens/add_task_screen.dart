import 'package:flutter/material.dart';
import 'package:probots/Networking/cityNetwork.dart';
import 'package:probots/Networking/filters.dart';
import 'package:probots/models/FilterModels.dart';
import 'package:material_text_fields/material_text_fields.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddTaskScreen extends StatefulWidget {
  final double width;
  AddTaskScreen(this.width);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}


class _AddTaskScreenState extends State<AddTaskScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController namecontroller=TextEditingController();
  final TextEditingController payoutcontroller=TextEditingController();
  final TextEditingController durationcontroller=TextEditingController();
  final TextEditingController stopscontroller=TextEditingController();
  bool isloading = false;




 static final List<MultiList> _offerType = [
  MultiList(id: 0, name: "Normal"),
  MultiList(id: 1, name: "SUV")
  ];
  final _offerTypeItems = _offerType
      .map((animal) => MultiSelectItem<MultiList>(animal, animal.name))
      .toList();
  List<int> _offerTypeSelection = [];

  static List<MultiList> _citiesList = [
  ];
  var _items = _citiesList
      .map((animal) => MultiSelectItem<MultiList>(animal, animal.name))
      .toList();
  List<String> _selectedAnimals = [];
  final _multiSelectKey = GlobalKey<FormFieldState>();

  String? multiKey(value) {
    if (value!.isEmpty) {
      return 'Please enter required value.';
    }
    if (_selectedAnimals.length < 1){
      return 'Please select at least one city';
    }
    return null;
  }

  String? validator(value) {
      if (value!.isEmpty) {
      return 'Please enter required value.';
      }
      return null;
  }

  Future<void> fetchCities() async{
    var data = await cityList();
    try {
      _citiesList = data;
      _items = _citiesList
          .map((animal) => MultiSelectItem<MultiList>(animal, animal.name))
          .toList();
      setState(() {
        isloading = false;
      });
    }catch(e){
      print(e);
      Fluttertoast.showToast(msg: "Error Encountered");
      setState(() {
        Navigator.pop(context);

      });
    }
  }

  @override
  void initState() {

    super.initState();
    fetchCities();
    namecontroller.text = '';
    stopscontroller.text = '';
    payoutcontroller.text = '';
    durationcontroller.text = '';
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff757575),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: widget.width * 0.1,
            vertical:widget.width * 0.1, ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(widget.width * 0.07),
            topRight: Radius.circular(widget.width * 0.07),
          ),
        ),
        child: isloading ? Center(child: CircularProgressIndicator(),) :Form(
          key: _key,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text("New Filter ", style: TextStyle(color: Colors.black, fontSize: widget.width * 0.06),),
                SizedBox(
                  height: widget.width * 0.1,
                ),

                Text("Filter Name"),
                MaterialTextField(

                  keyboardType: TextInputType.emailAddress,
                  hint: 'Any Name',
                  textInputAction: TextInputAction.next,
                  suffixIcon: const Icon(Icons.perm_identity),
                  controller: namecontroller,
                  validator: validator,
                ),
                SizedBox(
                  height: widget.width * 0.1,
                ),


                Text("Accept List"),
                MultiSelectDialogField(
                  validator: multiKey,
                  items: _items,
                  title: Text("Accept Cities"),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                  ),
                  buttonIcon: Icon(
                    Icons.location_city,
                    color: Colors.blue,
                  ),
                  buttonText: Text(
                    "Select Cities",
                  ),
                  onConfirm: (results) {
                    for (var res in results)
                      _selectedAnimals.add(res.name);
                  },
                ),
                SizedBox(
                  height: widget.width * 0.1,
                ),



                Text("Maximum Stops"),
                MaterialTextField(
                  keyboardType: const TextInputType.numberWithOptions(signed: false),
                  hint: 'Maximum Stops',
                  textInputAction: TextInputAction.next,
                  suffixIcon: const Icon(Icons.location_pin),
                  controller: stopscontroller,
                  validator: validator,
                ),
                SizedBox(
                  height: widget.width * 0.1,
                ),

                Text("Max Duration"),
                MaterialTextField(
                  keyboardType: const TextInputType.numberWithOptions(signed: false),
                  hint: 'Maximum Duration',
                  textInputAction: TextInputAction.next,
                  suffixIcon: const Icon(Icons.lock_clock),
                  controller: durationcontroller,
                  validator: validator,
                ),
                SizedBox(
                  height: widget.width * 0.1,
                ),


                Text("Minimum Price"),
                MaterialTextField(
                  validator: validator,
                  keyboardType: const TextInputType.numberWithOptions(signed: false),
                  hint: 'Minimum Payout',
                  textInputAction: TextInputAction.next,
                  suffixIcon: const Icon(Icons.currency_bitcoin),
                  controller: payoutcontroller,
                ),
                SizedBox(
                  height: widget.width * 0.1,
                ),

                Text("OfferType"),
                MultiSelectDialogField(
                  items: _offerTypeItems,
                  title: Text("Offer Type"),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                  ),
                  buttonIcon: const Icon(
                    Icons.car_rental,
                    color: Colors.blue,
                  ),
                  buttonText: const Text(
                    "OfferType",
                  ),
                  onConfirm: (results) {
                    for(var res in results)
                      {
                        _offerTypeSelection.add(res.id);
                      }
                  },
                ),
                SizedBox(
                  height: widget.width * 0.1,
                ),



                Container(
                  height: widget.width * 0.15,
                  child: ElevatedButton(
                    onPressed:() {
                      _addTask(context);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.lightBlueAccent, // Set the button's background color
                    ),
                    child: Text(
                      'Add Filter',
                      style: TextStyle(color: Colors.white, fontSize: widget.width * 0.06),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addTask(BuildContext context) async{
    if (_key.currentState?.validate() == true) {
      filterclassModel model = filterclassModel(name: namecontroller.text,
      payout: int.parse(payoutcontroller.text),cities: _selectedAnimals,
      offerType: [0,1],duration: int.parse(durationcontroller.text),stops: int.parse(stopscontroller.text));
      bool res = await createFilters(model);
      if(res){
        Fluttertoast.showToast(
            msg: "Filters Updated",
        );
      }
      Fluttertoast.showToast(
        msg: "Error Encountered",
      );
      Navigator.pop(context);
    }
  }
}
