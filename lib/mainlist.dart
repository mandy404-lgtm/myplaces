
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Mainlist extends StatefulWidget {
  const Mainlist({super.key});

  @override
  State<Mainlist> createState() => _MainlistState();
}

class _MainlistState extends State<Mainlist> {
  late double screenWidth, screenHeight;
  List<dynamic> placeList = [];
  String status = "Press the button to fetch places";
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      screenWidth = 600; //limit max width for better readability
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Interesting place in Malaysia'),
        backgroundColor: const Color.fromARGB(255, 241, 209, 147),
      ),

      body: Center(
        child: SizedBox(
          width: screenWidth,
          child: Column(
            children: [
              Text('Welcome to Malaysia', style: TextStyle(fontSize: 20)),
              SizedBox(
                width: screenWidth,
                child: ElevatedButton(
                  onPressed: () {
                    fetchPlace();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 241, 209, 147),
                  ),
                  child: Text('Find Place'),
                ),
              ),

              if (isLoading)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                )
              else if (placeList.isEmpty)
                SizedBox(height: 100, child: Center(child: Text(status)))
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: placeList.length,
                    itemBuilder: (context, index) {
                      String name = placeList[index]['name'];
                      String state = placeList[index]['state'];
                      String imageUrl = placeList[index]['image_url'];
                      double rating =double.tryParse(placeList[index]['rating'].toString(),) ??00;

                      return SizedBox(
                        height: 220,
                        child: Card(
                          elevation: 2,
                          shadowColor: Colors.orange,
                          margin: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 8,
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 150,
                                height: 200,
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                        Icons.error,
                                        color: Colors.red,
                                      ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        name,
                                        style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        ),
                                      ),
                                      Text('State: $state'),
                                      Text('Rating: $rating'),
                                    ],
                                  ),
                                ),
                              ),

                              IconButton(
                                icon: const Icon(Icons.arrow_forward_ios),
                                onPressed: () {
                                  String description =placeList[index]['description'];
                                  String category = placeList[index]['category'];
                                  String contact = placeList[index]['contact'];
                                  double latitude =double.tryParse(placeList[index]['latitude'].toString(),) ??00;
                                  double longitude =double.tryParse(placeList[index]['longitude'].toString(),) ??00;

                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(name),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Center(child: Image.network(
                                                imageUrl,
                                                width: 200,
                                                height: 200,
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (context,error,stackTrace,) => const Icon(
                                                      Icons.broken_image,
                                                      color: Colors.red,
                                                      size: 80,
                                                    ),
                                              ),),
                                             
                                              const SizedBox(height: 10),
                                              Text(
                                                'State: $state',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),

                                              const SizedBox(height: 10),
                                              const Text(
                                                'Description:',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                description,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              const Text(
                                                'Category:',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                category,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),


                                              const SizedBox(height: 10),
                                              const Text(
                                                'Contact:',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                contact,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              const Text(
                                                'Location:',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text('Latitude: $latitude'),
                                              Text('Longitude: $longitude'),
                                            ],
                                          ),
                                        ),

                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                            Navigator.pop(context),
                                            child: const Text("Close"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void fetchPlace() async {
    setState(() {
      isLoading = true;
      status = "Fetching places...";
      placeList=[];
    });
     
    try{
      final response = await http.get(
        Uri.parse(
          'https://slumberjer.com/teaching/a251/locations.php?state=&category=&name=',
        ),
      );
      if (response.statusCode != 200) {
      print('Error fetching places: ${response.statusCode}');
      setState(() {
        isLoading = false;
        status = 'Error fetching places: ${response.statusCode}';
      });
      return;
    }

      if (response.body.isEmpty) {
      print('Error fetching places: Empty response');
      setState(() {
        isLoading = false;
        status = 'Error fetching places: Empty response';
      });
      return;
    }
    placeList = json.decode(response.body);
    setState(() {
      isLoading = false;
      if (placeList.isEmpty) {
        status = "No places found.";
      } 
    });
    }catch (e) {
      setState(() {
        isLoading=false;
        status = "Connection error. Please check your internet.";
      });   
    }
  }
}
