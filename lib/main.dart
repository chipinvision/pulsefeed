////////////////////////////////////////////////////////
//  Instagram: @invisionchip
//  Github: https://github.com/chipinvision
//  LinkedIn: https://linkedin.com/invisionchip
////////////////////////////////////////////////////////
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pulsefeed/utils/app_style.dart';
import 'package:pulsefeed/views/dashboard.dart';
import 'package:pulsefeed/views/feed.dart';
import 'package:pulsefeed/views/category.dart';
import 'package:pulsefeed/views/search.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PulseFeed',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.orange,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _cindex = 0;

  void navigate(int index){
    setState(() {
      _cindex = index;
    });
  }

  List views = const [
    Feed(),
    Category(),
    DashBoard(),
  ];

  String greetUser(){
    final hour = TimeOfDay.now().hour;
    if(hour<=12){
      return "Good Morning";
    }else if(hour<=17){
      return "Good Afternoon";
    }else{
      return "Good Evening";
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.bg,
      extendBody: true,
      appBar: AppBar(
        toolbarHeight: 75.0,
        title: Text(
          greetUser(),
          style: GoogleFonts.getFont(
            'Poppins',
            textStyle: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w600,
              color: AppStyle.secondary,
            ),
          ),
        ),
        elevation: 0.0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right:15.0),
            child: CircleAvatar(
              minRadius: 10,
              backgroundColor: AppStyle.primary,
              child: IconButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Search(),
                    ),
                  );
                },
                icon: const Icon(Icons.search, size: 30,),
              ),
            ),
          ),
        ],
      ),
      body: views[_cindex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _cindex,
        onTap: navigate,
        type: BottomNavigationBarType.shifting,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.newspaper),label: 'Feed'),
          BottomNavigationBarItem(icon: Icon(Icons.tune),label: 'Category'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard),label: 'Dashboard'),
        ],
        showUnselectedLabels: false,
        showSelectedLabels: false,
        elevation: 0.0,
        backgroundColor: Colors.white,
        selectedItemColor: AppStyle.primary,
        unselectedItemColor: AppStyle.secondary,
      ),
    );
  }
}

