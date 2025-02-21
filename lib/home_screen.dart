// import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
import 'api.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _username = "Guest";
  List<dynamic> wishlistItems = [];

  @override
  void initState() {
    super.initState();
    _loadUsername();
    loadWishlist();
  }

  Future<void> loadWishlist() async {
    try{
      List<dynamic>products = await ApiService.fetchProducts();
      print("API Response: $products");  // Debugging line
      setState(() {
        
        wishlistItems = products;
      });
    }
    catch(e){
      print("Error fetching products: $e");
    }
    // String data = await rootBundle.loadString('assets/wishlist.json');
    // setState(() {
    //   wishlistItems = jsonDecode(data);)
    // }
  }

  Future<void> _loadUsername() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    setState((){
      _username = username ?? "Guest";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,   //removed back button
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   // onPressed: () {
        //   //   Navigator.pop(context); // Navigate back to the login page
        //   // },
        // ),
        title:Text(
          "Welcome, $_username!",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: wishlistItems.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 items per row
                  crossAxisSpacing: 12.0,
                  mainAxisSpacing: 12.0,
                  childAspectRatio: 0.65,
                  
                ),
                itemCount: wishlistItems.length,
                itemBuilder: (context, index) {
                  print(index);
                  
                  var item = wishlistItems[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(item: item),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      elevation: 5,
                      shadowColor: Colors.grey.withOpacity(0.5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16.0)),
                            child: Image.network(
                              item["image"],
                              height: 120,
                              width: double.infinity,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              item["title"],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          
                          const SizedBox(height: 6),
                        
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Settings"),
        ],
        currentIndex: 0, // Default selected tab
        onTap: (index) {
          print("Tab $index clicked");
        },
      ),
    );
  }
}
