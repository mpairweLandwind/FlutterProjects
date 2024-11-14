// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductWidget extends StatelessWidget {
  ProductWidget({super.key});




  List itemTitle = [
    "Dental Chairs",
    "Mobile working Units",
    "Oil Free Air Compresors",
  ];
  List itemImage = [
    "dental_chair.jpg",
    "mobile_working_dental_unit.jpg",
    "COMPRESSOR.jpg",
  ];

 

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = (screenWidth - 40) / 2;
    return SingleChildScrollView(
      child: SizedBox(
        height: 240,
        child: ListView(
          scrollDirection: Axis.horizontal ,
          children: [
            for (int i = 0; i < itemTitle.length; i++) Container(
              width: itemWidth,
              margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, "/productScreen");
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: Image.asset("assets/${itemImage[i]}",
                      height: itemWidth * 0.75,
                      
                      ),
                    ),
                  ),
                  Text(itemTitle[i],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),  
                  ),
                  const SizedBox(height: 12),               
                  
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:  [
                      Text("\$10",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 8, 79, 202)),
                      ),
                      Icon(CupertinoIcons.add,
                      color: Color.fromARGB(255, 8, 79, 202),
                      size: 26,
                      )
                    ],
                  ),
                      ),

                    ]
              ),
            ),
          ],

        ),
      ),
    );
  }
}
