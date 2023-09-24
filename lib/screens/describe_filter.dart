import 'package:flutter/material.dart';
import 'package:probots/Networking/filters.dart';
import 'package:probots/models/FilterModels.dart';
import 'package:fluttertoast/fluttertoast.dart';
class DescribeTaskScreen extends StatefulWidget {
  final double width;
  final String name;
  DescribeTaskScreen(this.width,this.name);

  @override
  _DescribeTaskScreenState createState() => _DescribeTaskScreenState();
}


class _DescribeTaskScreenState extends State<DescribeTaskScreen> {
  bool isloading = true;
  late filterclassModel model;
  String offerType = "-";
  String acceptList = "-";
  void fetch()
  async{
    try{
      model = await getDescribe(widget.name);
      if(model.offerType != null){
        for (int offer in model.offerType!){
            offerType += ["/ Normal ","/ SUV "][offer];
    }}
      if(model.cities != null){
        for (String offer in model.cities!){
          acceptList += "/ ${offer} ";
        }}
      setState(() {
        isloading = false;
        print("state changed");
      });
    }
    catch (e){
      print(e);
      Fluttertoast.showToast(msg: "Could not load filter resource");
    }
  }

  @override
  void initState() {

    fetch();
    super.initState();
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
        child: isloading ? Center(child: CircularProgressIndicator(),) :SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text("Filter Details - ", style: TextStyle(color: Colors.black, fontSize: widget.width * 0.06),),
              SizedBox(
                height: widget.width * 0.1,
              ),

              Text("Name : ${model.name}", style: TextStyle(color: Colors.black, fontSize: widget.width * 0.04),),
              SizedBox(
                height: widget.width * 0.05,
              ),

              Text("Min Payout : ${model.payout}", style: TextStyle(color: Colors.black, fontSize: widget.width * 0.04),),
              SizedBox(
                height: widget.width * 0.05,
              ),

              Text("Max Stops : ${model.stops}", style: TextStyle(color: Colors.black, fontSize: widget.width * 0.04),),
              SizedBox(
                height: widget.width * 0.05,
              ),

              Text("Max Duration : ${model.duration}", style: TextStyle(color: Colors.black, fontSize: widget.width * 0.04),),
              SizedBox(
                height: widget.width * 0.05,
              ),

              Text("Accept List : ${acceptList}", style: TextStyle(color: Colors.black, fontSize: widget.width * 0.04),),
              SizedBox(
                height: widget.width * 0.05,
              ),

              Text("OfferType : ${offerType}", style: TextStyle(color: Colors.black, fontSize: widget.width * 0.04),),
              SizedBox(
                height: widget.width * 0.05,
              ),
              Container(

                height: widget.width * 0.1,
                child: ElevatedButton(
                  onPressed:(){ _deleteTask(context);},
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // Set the button's background color
                  ),
                  child: Text(
                    'Delete Filter',
                    style: TextStyle(color: Colors.white, fontSize: widget.width * 0.06),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteTask(BuildContext context) async{
    try{
      bool res = await removeFilter(widget.name);
      if(res)
        Fluttertoast.showToast(msg: "Filter Removed !");
      Fluttertoast.showToast(msg: "Can't remove !");
    }catch(e){
      print(e);
      Fluttertoast.showToast(msg: "Exception !");
    }
      print("deleteFilter");
      Navigator.pop(context);
  }
}
