import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';

void main() => runApp(const CountryApp());

class CountryApp extends StatefulWidget {
  const CountryApp({super.key});

  @override
  State<CountryApp> createState() => _CountryAppState();
}

class _CountryAppState extends State<CountryApp> {
  final TextEditingController textEditingController = TextEditingController();
  var name = " ", isoCode = "", capital = "", currencyName = " ", currencyCode = "";
  ImageProvider? flag;
  String data = "No records"; 
  final player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold( 
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color.fromARGB(255, 243, 217, 147), 
        body:Padding(
          padding: const EdgeInsets.all(16.0),
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 100,
                child: Image.asset('assets/app_logo.png', scale: 3,),
              ),
              const SizedBox(height:16.0),
              TextField(
                controller: textEditingController,
                keyboardType: TextInputType.text,            
                decoration: InputDecoration( 
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ), 
                  prefixIcon: const Icon(Icons.search), 
                  labelText: 'Please input country', 
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w500, 
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 16.0,),
              ElevatedButton(
                onPressed: _searchCountry,
                style: ButtonStyle(
                      foregroundColor: getColor(Colors.red, Colors.amber),
                      backgroundColor: getColor(Colors.amber, Colors.red),
                    ),
                child: const Text("Search", style: TextStyle(color: Colors.black,)),     
              ),     
              const SizedBox(height: 16.0,),
              Container(
                padding: const EdgeInsets.all(8.0),  
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10.0)
                ), 
                child: Column(
                  children: [
                    if(flag != null)
                      Image(image: flag!)
                    else
                       const SizedBox.shrink(), 
                    Text(data, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  ],
                ) 
              )             
            ],
          )
        ),       
      )
    );
  }

  Future<void> _searchCountry() async {
    final countryName = textEditingController.text.trim();
    if(countryName.isNotEmpty){
      String apiKey= "bFP3iYsONaw6PG5nObaVxA==oGfd9qW5ouOkx62W"; 
      var url = Uri.parse('https://api.api-ninjas.com/v1/country?name=$countryName');
      var response = await http.get(url, headers:{'X-Api-Key': apiKey}); 
      if (response.statusCode == 200) {    
          String jsonData = response.body; 
          var parsedJson = json.decode(jsonData);
          String responseName = parsedJson[0]['name'];
          String shortcut = parsedJson[0]['iso2'];
          if (responseName.toLowerCase() == countryName.toLowerCase() || shortcut.toLowerCase() == countryName.toLowerCase()) {
              Future.microtask(() {
                QuickAlert.show(
                context: context,
                title: "Success",
                text:"The country was found",
                type: QuickAlertType.success
              );});
            player.play(AssetSource('correct.wav'));
            name = responseName;
            isoCode = parsedJson[0]['iso2'];
            capital = parsedJson[0]['capital'];
            currencyCode = parsedJson[0]['currency']['code'];
            currencyName = parsedJson[0]['currency']['name'];
            flag = NetworkImage("https://flagsapi.com/$isoCode/flat/64.png");
            data = "This country is $name with iso code $isoCode and $capital as capital. The currency is $currencyCode, $currencyName. ";            
            setState(() {              
            });
          }

          else{
            QuickAlert.show(
              context: context,
              title: "Error",
              text:"Please input valid country",
              type: QuickAlertType.error
            );
            player.play(AssetSource('wrong.wav'));
            setState(() {
              data = "No record";
              flag = null;
            });
          }         
      }
    }
    else{
        QuickAlert.show(
            context: context,
            title: "Error",
            text:"Please input country",
            type: QuickAlertType.error
        );
        player.play(AssetSource('wrong.wav'));
        setState(() {
          data = "No record";
          flag = null;
        });         
      }
  }

  MaterialStateProperty<Color> getColor(Color color, Color colorPressed) {
    final getColor = (Set<MaterialState> states){
      if(states.contains(MaterialState.pressed)){
        return colorPressed;
      }
      else{
        return color;
      }
    };
    return MaterialStateProperty.resolveWith(getColor);
  }
}



