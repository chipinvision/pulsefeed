import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_style.dart';
import 'category_feed.dart';

class Category extends StatefulWidget {
  const Category({Key? key}) : super(key: key);

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {

  List<String> category = [
    'science',
    'health',
    'entertainment',
    'business',
    'sports',
    'technology',
  ];

  List<String> displayList = [
    'Science',
    'Health',
    'Entertainment',
    'Business',
    'Sports',
    'Technology',
  ];

  List<IconData> categoryIcons = [
    Icons.science,
    Icons.health_and_safety,
    Icons.local_fire_department,
    Icons.business,
    Icons.sports,
    Icons.computer,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left:15, right:15, top:5),
      child: ListView.separated(
          itemBuilder: (BuildContext context, int index){
            return Card(
              surfaceTintColor: AppStyle.secondary,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppStyle.primary,
                  child: Icon(categoryIcons[index], color: AppStyle.text,),
                ),
                title: Text(
                  displayList[index],
                  style: GoogleFonts.getFont(
                    'Poppins',
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppStyle.text,
                    ),
                  ),
                ),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryFeed(category: category[index], displayTitle: displayList[index]),
                    ),
                  );
                },
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index){
            return const SizedBox(height:10);
          },
          itemCount: category.length,
      ),
    );
  }
}
