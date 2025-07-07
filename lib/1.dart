import 'package:flutter/material.dart';

class Demo extends StatefulWidget {
  const Demo({super.key});

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xFF94FA8E),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 42,
            children: [
              Container(
                width:  screenWidth *0.7725,
                height: 78,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular( screenWidth *0.01,),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 4,
                      offset: Offset(0, 5),
                      spreadRadius: 0,
                    )
                  ],
                ),
              ),
              Container(
                width:  screenWidth *  0.05,
                height: 78,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular( screenWidth *0.01),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 4,
                      offset: Offset(0, 5),
                      spreadRadius: 0,
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height:  screenHeight * 0.051125,),
          Row(
            children: [
              SizedBox(width:  screenWidth *  0.078,),
              Container(
                width:  screenWidth * 0.23,
                height:  screenHeight * 0.73875,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular( screenWidth * 0.01),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 4,
                      offset: Offset(0, 5),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Padding(
                  padding:  EdgeInsets.all( screenWidth * 0.003),
                  child: Column(children: [
                    Container(
                      width:  screenWidth * 0.23,
                      height:  screenHeight * 0.652,
                      decoration: ShapeDecoration(
                        color: const Color(0xFF94FA8E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular( screenWidth * 0.009),
                            topRight: Radius.circular( screenWidth * 0.009),
                          ),
                        ),
                      ),
                   //   child:Image.network("https://drive.google.com/uc?export=view&id=10N5rTEUxjcNf-gU2WueUO_4QpRnJeBvB")
                    ),
                    Spacer(),
                    Container(
                      width:  screenWidth * 1.025,
                      height:  screenHeight * 0.075,
                      decoration: ShapeDecoration(
                        color: const Color(0xFF94FA8E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular( screenWidth * 0.009),
                            bottomRight: Radius.circular( screenWidth * 0.009),
                          ),
                        ),
                      ),
                    child: Center(
                      child: Text(
                        'ID  : -  9006',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: screenWidth *  0.015,
                          fontFamily: 'Inria Serif',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    ),
                   // SizedBox(height:  screenHeight *  0.001,)
                  ],),
                ),
              ),
              SizedBox(width:  screenWidth * 0.063,),
              Container(
                width:  screenWidth *  0.5225,
                height:  screenHeight *  0.550,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular( screenWidth *  0.01),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 4,
                      offset: Offset(0, 5),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal:  screenWidth *0.0225),
                  child: Column(children: [
                    SizedBox(height:  screenHeight * 0.0525,),
                    Container(
                      width:  screenWidth * 1.9475,
                      height:  screenHeight * 0.22375,
                      decoration: BoxDecoration(color: const Color(0xFFD9D9D9)),
                      child: Padding(
                        padding:  EdgeInsets.only(left:  screenWidth * 0.025,top:  screenHeight *  0.03625,),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                          Text(
                            'Name  :    ADNAN',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize:  screenWidth * 0.021,
                              fontFamily: 'Inria Serif',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: screenHeight *  0.035,),
                          Text(
                            'Dep  :    TECHNICAL',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: screenWidth *  0.021,
                              fontFamily: 'Inria Serif',
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ],),
                      ),
                    ),
                    SizedBox(height:  screenHeight * 0.0425,),
                    Container(
                      width: screenWidth *  1.9475,
                      height: screenHeight *  0.07625,
                      decoration: ShapeDecoration(
                        color: const Color(0xFF94FA8E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(screenWidth *  0.0125,),
                            topRight: Radius.circular(screenWidth * 0.0125,),
                          ),
                        ),
                      ),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Check IN :  ',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: screenWidth *  0.015,
                              fontFamily: 'Inria Serif',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '12/10/2025 10:20 AM',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: screenWidth *  0.014,
                              fontFamily: 'Inria Serif',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height:  screenHeight * 0.0125,),
                    Container(
                      width: screenWidth * 1.9475,
                      height: screenHeight * 0.07625,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFFF6B6B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(screenWidth * 0.0125,),
                            bottomRight: Radius.circular(screenWidth * 0.0125,),
                          ),
                        ),
                      ),child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                          'Check OUT:  ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth *  0.015,
                            fontFamily: 'Inria Serif',
                            fontWeight: FontWeight.w700,
                          ),
                                              ),

                          Text(
                            '12/10/2025 10:20 AM',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth *  0.014,
                              fontFamily: 'Inria Serif',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],),
                ),
              )
            ],
          )

        ],
      ),
    );
  }
}
