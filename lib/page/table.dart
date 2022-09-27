import 'package:flutter/material.dart';

import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;


class TableUno extends StatefulWidget {
  TableUno({Key? key}) : super(key: key);

  @override
  State<TableUno> createState() => _TableUnoState();
}

class _TableUnoState extends State<TableUno> {
  bool isLoading = false;
  bool hide= false;
  List<String> titles=[];
  List<String>titles4=[];
  List titles3=[];
  
  List<String> titlesGris=[];
  List<String> titlesGris1=[];
  List titlesGris2=[];
    Future<List<String>> extractData() async {
    final response =
        await http.Client().get(Uri.parse('https://app.sct.gob.mx/sibuac_internet/ControllerUI?action=cmdSolRutas&tipo=1&red=simplificada&edoOrigen=1&ciudadOrigen=1040&edoDestino=2&ciudadDestino=2080&vehiculos=11'));
    if (response.statusCode == 200) {          
      var document = parser.parse(response.body);
      try {
        titles=document.getElementsByClassName('tr_blanco')
          .map((e) => e.text.trim())
          .toList();

          titlesGris=document.getElementsByClassName('tr_gris')
          .map((e) => e.text.trim())
          .toList();

            for (var i = 0; i < titles.length; i++) {
              titles4=document.getElementsByClassName('tr_blanco')[i]
               .children
               .map((e) => e.text.trim())
               .toList();
                print("tengo ${titles4}");
                titles3.add(titles4);
                  }

          for (var i = 0; i < titlesGris.length; i++) {
            titlesGris1=document.getElementsByClassName('tr_gris')[i]
               .children
               .map((e) => e.text.trim())
               .toList();
              titlesGris2.add(titlesGris1);
          }
        
         return titles4;
      } 
      catch (e) {
        return ['', '', 'ERROR!'];
      }
    } else {
      return ['', '', 'ERROR: ${response.statusCode}.'];
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text("Tabla")),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height*2.3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(child: 
              isLoading
                ?Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    CircularProgressIndicator(),
                  ],
                ):
                hide?
                  Table(
                    border: TableBorder.all(),
                  children:[ 
                    buildRowGreen(["Nombre", "Edo.", "Carretera","Long.(Km)","Tiempo(Hrs)","Caseta o punte","Camion 4 ejes"]),
                     for(int i = 1; i < titles3.length-4; i++)
                   buildRow(titles3[i]),
                   for(int i = 0; i < titlesGris2.length-1; i++)
                   buildRow(titlesGris2[i]),
                ],
                  ):
                Container()
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              MaterialButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                      hide=true;
                      titles3.clear();
                      titlesGris2.clear();
                    });
                    final response = await extractData();
                    setState(() {
                      isLoading = false;
                    });
                  },
                  child: Text(
                    'Ver Tabla',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Color.fromARGB(255, 38, 88, 40),
                )
            ],
          ),
        ),
      ),
    );
  }
  
  
    TableRow buildRow(List<String> celdas) =>TableRow(
       children: celdas.map((listaCelda) {
        return Padding(
          padding: const EdgeInsets.all(2),
          child: Center(
            child: Text(listaCelda, 
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 9),)),
          );
       }
       ).toList()     
  );
        TableRow buildRowGreen(List<String> celdas) =>TableRow(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 38, 88, 40)
          ),
       children: celdas.map((listaCelda) {
        return Padding(
          padding: const EdgeInsets.all(2),
          child: Center(
            child: Text(listaCelda, 
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 9,
            color:Colors.white),)),
          );
       }
       ).toList()     
  );
    
  }
  
  
