// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// import '../DailyReport/Daily Report.dart';
//
// class AttendanceScreen extends StatefulWidget {
//   const AttendanceScreen({super.key});
//
//   @override
//   State<AttendanceScreen> createState() => _AttendanceScreenState();
// }
//
// class _AttendanceScreenState extends State<AttendanceScreen> {
//   final TextEditingController _controller = TextEditingController();
//   List<Map<String, dynamic>> _employeeList = [];
//   bool _isLoading = false;
//   @override
//   void initState() {
//     super.initState();
//     _fetchEmployees();
//   }
//
//   Future<void> _fetchEmployees() async {
//     setState(() => _isLoading = true);
//     try {
//       final response = await Supabase.instance.client
//           .schema('hr')
//           .from('eml')
//           .select('id, name, department')
//           .order('id', ascending: true);
//
//       setState(() {
//         _employeeList = List<Map<String, dynamic>>.from(response);
//       });
//     } catch (e) {
//       if (mounted) {
//         print("Error fetching employees:$e");
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error fetching employees: $e')),
//         );
//       }
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
//
//   Future<void> _checkInput(String value) async {
//     if (value.length != 4) return;
//
//     setState(() => _isLoading = true);
//     _controller.clear();
//
//     try {
//       final employee = _employeeList.firstWhere(
//             (emp) => emp['id'].toString() == value,
//         orElse: () => {},
//       );
//
//       if (employee.isEmpty) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Employee ID not found')),
//           );
//         }
//         return;
//       }
//
//       final now = DateTime.now();
//       final today = now.toIso8601String().split('T')[0];
//
//       final records = await Supabase.instance.client
//           .schema('hr')
//           .from('attendance')
//           .select()
//           .eq('eml_id', employee['id'])
//           .filter('check_out', 'is', null)
//           .order('check_in', ascending: false)
//           .limit(1);
//
//       if (records.isEmpty) {
//         // ✅ First time check-in
//         await _createCheckIn(employee, now, today);
//         if (mounted) _showSnackBar('✅ First check-in for ${employee['name']}');
//       } else {
//         final latest = records.first;
//         final checkIn = DateTime.parse(latest['check_in']);
//         final diffInDays = now.difference(checkIn).inDays;
//         final diffInMinutes = now.difference(checkIn).inMinutes;
//
//         if (diffInDays > 2) {
//           // ⚠️ Record older than 2 days - force new check-in
//           await _createCheckIn(employee, now, today);
//           if (mounted) _showSnackBar('✅ New check-in for ${employee['name']} (previous record expired)');
//         } else {
//           // Handle normal check-out
//           if (diffInMinutes < 2) {
//             if (mounted) _showSnackBar('⏳ Please wait ${2 - diffInMinutes} more minute(s) to check out');
//           } else {
//             await _performCheckOut(latest['id'], now);
//             if (mounted) _showSnackBar('✅ Check-out recorded for ${employee['name']}');
//           }
//         }
//       }
//
//       await _fetchEmployees();
//     } catch (e) {
//       if (mounted) _showSnackBar('❌ Error: $e');
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }
//
// // Helper functions
//   Future<void> _createCheckIn(Map<String, dynamic> employee, DateTime now, String today) async {
//     await Supabase.instance.client
//         .schema('hr')
//         .from('attendance')
//         .insert({
//       'date_att': today,
//       'eml_id': employee['id'],
//       'check_in': now.toIso8601String(),
//     });
//   }
//
//   Future<void> _performCheckOut(int recordId, DateTime now) async {
//     await Supabase.instance.client
//         .schema('hr')
//         .from('attendance')
//         .update({'check_out': now.toIso8601String()})
//         .eq('id', recordId);
//   }
//
//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(onPressed: (){
//        //   Navigator.of(context).push(MaterialPageRoute(builder: (_)=>CalendarPage()));
//         }, icon: Icon(Icons.calendar_month_outlined)),
//         actions: [PopupMenuButton<String>(
//           icon: const Icon(Icons.calendar_month),
//           onSelected: (String value) {
//             if (value == 'today') {
//               Navigator.of(context).push(MaterialPageRoute(builder: (_)=>Today()));
//             } else if (value == 'custom') {
//            //   Navigator.of(context).push(MaterialPageRoute(builder: (_)=>DateCustomize()));
//               // Navigator.pushNamed(context, '/custom');
//             }
//           },
//           itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
//             const PopupMenuItem<String>(
//               value: 'today',
//               child: ListTile(
//                 leading: Icon(Icons.today),
//                 title: Text("Today's Attendance"),
//               ),
//             ),
//             const PopupMenuItem<String>(
//               value: 'custom',
//               child: ListTile(
//                 leading: Icon(Icons.date_range),
//                 title: Text('Custom Attendance'),
//               ),
//             ),
//           ],
//         ),],
//         title: const Text('Employee Attendance'),),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _controller,
//               maxLength: 4,
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(
//                 labelText: 'Enter Employee ID',
//                 border: OutlineInputBorder(),
//                 hintText: '4-digit code',
//               ),
//               onChanged: _checkInput,
//             ),
//
//
//             // Row(
//             //   children: [
//             //     SizedBox(width:  screenWidth *  0.078,),
//             //     Container(
//             //       width:  screenWidth * 0.23,
//             //       height:  screenHeight * 0.73875,
//             //       decoration: ShapeDecoration(
//             //         color: Colors.white,
//             //         shape: RoundedRectangleBorder(
//             //           borderRadius: BorderRadius.circular( screenWidth * 0.01),
//             //         ),
//             //         shadows: [
//             //           BoxShadow(
//             //             color: Color(0x3F000000),
//             //             blurRadius: 4,
//             //             offset: Offset(0, 5),
//             //             spreadRadius: 0,
//             //           )
//             //         ],
//             //       ),
//             //       child: Padding(
//             //         padding:  EdgeInsets.all( screenWidth * 0.003),
//             //         child: Column(children: [
//             //           Container(
//             //             width:  screenWidth * 0.23,
//             //             height:  screenHeight * 0.652,
//             //             decoration: ShapeDecoration(
//             //               color: const Color(0xFF94FA8E),
//             //               shape: RoundedRectangleBorder(
//             //                 borderRadius: BorderRadius.only(
//             //                   topLeft: Radius.circular( screenWidth * 0.009),
//             //                   topRight: Radius.circular( screenWidth * 0.009),
//             //                 ),
//             //               ),
//             //             ),
//             //             //   child:Image.network("https://drive.google.com/uc?export=view&id=10N5rTEUxjcNf-gU2WueUO_4QpRnJeBvB")
//             //           ),
//             //           Spacer(),
//             //           Container(
//             //             width:  screenWidth * 1.025,
//             //             height:  screenHeight * 0.075,
//             //             decoration: ShapeDecoration(
//             //               color: const Color(0xFF94FA8E),
//             //               shape: RoundedRectangleBorder(
//             //                 borderRadius: BorderRadius.only(
//             //                   bottomLeft: Radius.circular( screenWidth * 0.009),
//             //                   bottomRight: Radius.circular( screenWidth * 0.009),
//             //                 ),
//             //               ),
//             //             ),
//             //             child: Center(
//             //               child: Text(
//             //                 'ID  : -  id_place',
//             //                 style: TextStyle(
//             //                   color: Colors.black,
//             //                   fontSize: screenWidth *  0.015,
//             //                   fontFamily: 'Inria Serif',
//             //                   fontWeight: FontWeight.w700,
//             //                 ),
//             //               ),
//             //             ),
//             //           ),],),
//             //       ),
//             //     ),
//             //     SizedBox(width:  screenWidth * 0.063,),
//             //     Container(
//             //       width:  screenWidth *  0.5225,
//             //       height:  screenHeight *  0.550,
//             //       decoration: ShapeDecoration(
//             //         color: Colors.white,
//             //         shape: RoundedRectangleBorder(
//             //           borderRadius: BorderRadius.circular( screenWidth *  0.01),
//             //         ),
//             //         shadows: [
//             //           BoxShadow(
//             //             color: Color(0x3F000000),
//             //             blurRadius: 4,
//             //             offset: Offset(0, 5),
//             //             spreadRadius: 0,
//             //           )
//             //         ],
//             //       ),
//             //       child: Padding(
//             //         padding:  EdgeInsets.symmetric(horizontal:  screenWidth *0.0225),
//             //         child: Column(children: [
//             //           SizedBox(height:  screenHeight * 0.0525,),
//             //           Container(
//             //             width:  screenWidth * 1.9475,
//             //             height:  screenHeight * 0.22375,
//             //             decoration: BoxDecoration(color: const Color(0xFFD9D9D9)),
//             //             child: Padding(
//             //               padding:  EdgeInsets.only(left:  screenWidth * 0.025,top:  screenHeight *  0.03625,),
//             //               child: Column(crossAxisAlignment: CrossAxisAlignment.start,
//             //                 children: [
//             //                   Text(
//             //                     'Name  :    name_place',
//             //                     style: TextStyle(
//             //                       color: Colors.black,
//             //                       fontSize:  screenWidth * 0.021,
//             //                       fontFamily: 'Inria Serif',
//             //                       fontWeight: FontWeight.w700,
//             //                     ),
//             //                   ),
//             //                   SizedBox(height: screenHeight *  0.035,),
//             //                   Text(
//             //                     'Dep  :    department_place',
//             //                     style: TextStyle(
//             //                       color: Colors.black,
//             //                       fontSize: screenWidth *  0.021,
//             //                       fontFamily: 'Inria Serif',
//             //                       fontWeight: FontWeight.w700,
//             //                     ),
//             //                   )
//             //                 ],),
//             //             ),
//             //           ),
//             //           SizedBox(height:  screenHeight * 0.0425,),
//             //           Container(
//             //             width: screenWidth *  1.9475,
//             //             height: screenHeight *  0.07625,
//             //             decoration: ShapeDecoration(
//             //               color: const Color(0xFF94FA8E),
//             //               shape: RoundedRectangleBorder(
//             //                 borderRadius: BorderRadius.only(
//             //                   topLeft: Radius.circular(screenWidth *  0.0125,),
//             //                   topRight: Radius.circular(screenWidth * 0.0125,),
//             //                 ),
//             //               ),
//             //             ),
//             //             child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
//             //               children: [
//             //                 Text(
//             //                   'Check IN :  ',
//             //                   style: TextStyle(
//             //                     color: Colors.black,
//             //                     fontSize: screenWidth *  0.015,
//             //                     fontFamily: 'Inria Serif',
//             //                     fontWeight: FontWeight.w700,
//             //                   ),
//             //                 ),
//             //                 Text(
//             //                   '12/10/2025 10:20 AM',
//             //                   style: TextStyle(
//             //                     color: Colors.black,
//             //                     fontSize: screenWidth *  0.014,
//             //                     fontFamily: 'Inria Serif',
//             //                     fontWeight: FontWeight.w700,
//             //                   ),
//             //                 ),
//             //               ],
//             //             ),
//             //           ),
//             //           SizedBox(height:  screenHeight * 0.0125,),
//             //           Container(
//             //             width: screenWidth * 1.9475,
//             //             height: screenHeight * 0.07625,
//             //             decoration: ShapeDecoration(
//             //               color: const Color(0xFFFF6B6B),
//             //               shape: RoundedRectangleBorder(
//             //                 borderRadius: BorderRadius.only(
//             //                   bottomLeft: Radius.circular(screenWidth * 0.0125,),
//             //                   bottomRight: Radius.circular(screenWidth * 0.0125,),
//             //                 ),
//             //               ),
//             //             ),child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
//             //             children: [
//             //               Text(
//             //                 'Check OUT:  ',
//             //                 style: TextStyle(
//             //                   color: Colors.white,
//             //                   fontSize: screenWidth *  0.015,
//             //                   fontFamily: 'Inria Serif',
//             //                   fontWeight: FontWeight.w700,
//             //                 ),
//             //               ),
//             //
//             //               Text(
//             //                 '12/10/2025 10:20 AM',
//             //                 style: TextStyle(
//             //                   color: Colors.white,
//             //                   fontSize: screenWidth *  0.014,
//             //                   fontFamily: 'Inria Serif',
//             //                   fontWeight: FontWeight.w700,
//             //                 ),
//             //               ),
//             //             ],
//             //           ),
//             //           )
//             //         ],),
//             //       ),
//             //     )
//             //   ],
//             // )
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // const SizedBox(height: 20),
// // if (_isLoading) const CircularProgressIndicator(),
// // const Text('Employee List', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
// // Expanded(
// //   child: _employeeList.isEmpty
// //       ? const Center(child: Text('No employees found'))
// //       : ListView.builder(
// //     itemCount: _employeeList.length,
// //     itemBuilder: (context, index) {
// //       final employee = _employeeList[index];
// //       return InkWell(onTap: (){
// //    //     Navigator.of(context).push(MaterialPageRoute(builder: (_)=>EmployeeDetails(employeeId:employee['id'].toString() ,)));
// //       },
// //         child: Card(
// //           margin: const EdgeInsets.symmetric(vertical: 4),
// //           child: ListTile(
// //             title: Text(employee['name'] ?? 'Unknown'),
// //             subtitle: Text('ID: ${employee['id']} - ${employee['department'] ?? 'No department'}'),
// //             leading: CircleAvatar(
// //               child: Text(employee['id'].toString()),
// //             ),
// //           ),
// //         ),
// //       );
// //     },
// //   ),
// // ),
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../DailyReport/Daily Report.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _employeeList = [];
  Map<String, dynamic>? _activeEmployee;
  Map<String, dynamic>? _attendanceRecord;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchEmployees();
  }

  Future<void> _fetchEmployees() async {
    setState(() => _isLoading = true);
    try {
      final response = await Supabase.instance.client
          .schema('hr')
          .from('eml')
          .select('id, name, department')
          .order('id', ascending: true);

      setState(() {
        _employeeList = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching employees: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }
  Future<void> _checkInput(String value) async {
    if (value.length != 4) return;

    setState(() => _isLoading = true);
    _controller.clear();

    try {
      final employee = _employeeList.firstWhere(
            (emp) => emp['id'].toString() == value,
        orElse: () => {},
      );

      if (employee.isEmpty) {
        if (mounted) _showSnackBar('❌ Employee ID not found');
        return;
      }

      final now = DateTime.now();
      final today = now.toIso8601String().split('T')[0];

      final records = await Supabase.instance.client
          .schema('hr')
          .from('attendance')
          .select()
          .eq('eml_id', employee['id'])
          .filter('check_out', 'is', null)
          .order('check_in', ascending: false)
          .limit(1);

      if (records.isEmpty) {
        // ✅ First time check-in
        await _createCheckIn(employee, now, today);

        setState(() {
          _activeEmployee = employee;
          _attendanceRecord = {
            'check_in': now.toIso8601String(),
            'check_out': null,
          };
        });

        if (mounted) _showSnackBar('✅ Check-in for ${employee['name']}');
      } else {
        final latest = records.first;
        final checkIn = DateTime.parse(latest['check_in']);
        final diffInDays = now.difference(checkIn).inDays;
        final diffInMinutes = now.difference(checkIn).inMinutes;

        if (diffInDays > 2) {
          // ⚠️ Expired record → new check-in
          await _createCheckIn(employee, now, today);

          setState(() {
            _activeEmployee = employee;
            _attendanceRecord = {
              'check_in': now.toIso8601String(),
              'check_out': null,
            };
          });

          if (mounted) {
            _showSnackBar('✅ New check-in for ${employee['name']} (expired)');
          }
        } else {
          if (diffInMinutes < 2) {
            if (mounted) {
              _showSnackBar('⏳ Wait ${2 - diffInMinutes} minute(s) to check out');
            }
          } else {
            await _performCheckOut(latest['id'], now);

            setState(() {
              _activeEmployee = employee;
              _attendanceRecord = {
                'check_in': latest['check_in'],
                'check_out': now.toIso8601String(),
              };
            });

            if (mounted) _showSnackBar('✅ Check-out for ${employee['name']}');
          }
        }
      }

      // Hide info after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _activeEmployee = null;
            _attendanceRecord = null;
          });
        }
      });

      await _fetchEmployees();
    } catch (e) {
      if (mounted) _showSnackBar('❌ Error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Future<void> _checkInput(String value) async {
  //   if (value.length != 4) return;
  //
  //   setState(() {
  //     _isLoading = true;
  //     _controller.clear();
  //   });
  //
  //   try {
  //     final employee = _employeeList.firstWhere(
  //           (emp) => emp['id'].toString() == value,
  //       orElse: () => {},
  //     );
  //
  //     if (employee.isEmpty) {
  //       if (mounted) {
  //         _showSnackBar('Employee ID not found');
  //       }
  //       return;
  //     }
  //
  //     setState(() {
  //       _activeEmployee = employee;
  //       _attendanceRecord = null;
  //     });
  //
  //     final now = DateTime.now();
  //     final today = now.toIso8601String().split('T')[0];
  //
  //     final records = await Supabase.instance.client
  //         .schema('hr')
  //         .from('attendance')
  //         .select()
  //         .eq('eml_id', employee['id'])
  //         .filter('check_out', 'is', null)
  //         .order('check_in', ascending: false)
  //         .limit(1);
  //
  //     if (records.isEmpty) {
  //       await _createCheckIn(employee, now, today);
  //       if (mounted) _showSnackBar('✅ First check-in for ${employee['name']}');
  //       setState(() {
  //         _attendanceRecord = {
  //           'check_in': now.toIso8601String(),
  //           'check_out': null,
  //         };
  //       });
  //     } else {
  //       final latest = records.first;
  //       final checkIn = DateTime.parse(latest['check_in']);
  //       final diffInDays = now.difference(checkIn).inDays;
  //       final diffInMinutes = now.difference(checkIn).inMinutes;
  //
  //       if (diffInDays > 2) {
  //         await _createCheckIn(employee, now, today);
  //         if (mounted) _showSnackBar('✅ New check-in for ${employee['name']} (previous record expired)');
  //         setState(() {
  //           _attendanceRecord = {
  //             'check_in': now.toIso8601String(),
  //             'check_out': null,
  //           };
  //         });
  //       } else {
  //         if (diffInMinutes < 2) {
  //           if (mounted) _showSnackBar('⏳ Please wait ${2 - diffInMinutes} more minute(s) to check out');
  //         } else {
  //           await _performCheckOut(latest['id'], now);
  //           if (mounted) _showSnackBar('✅ Check-out recorded for ${employee['name']}');
  //           setState(() {
  //             _attendanceRecord = {
  //               'check_in': latest['check_in'],
  //               'check_out': now.toIso8601String(),
  //             };
  //           });
  //         }
  //       }
  //     }
  //
  //     await _fetchEmployees();
  //   } catch (e) {
  //     if (mounted) _showSnackBar('❌ Error: $e');
  //   } finally {
  //     if (mounted) setState(() => _isLoading = false);
  //   }
  // }

  Future<void> _createCheckIn(Map<String, dynamic> employee, DateTime now, String today) async {
    await Supabase.instance.client
        .schema('hr')
        .from('attendance')
        .insert({
      'date_att': today,
      'eml_id': employee['id'],
      'check_in': now.toIso8601String(),
    });
  }

  Future<void> _performCheckOut(int recordId, DateTime now) async {
    await Supabase.instance.client
        .schema('hr')
        .from('attendance')
        .update({'check_out': now.toIso8601String()})
        .eq('id', recordId);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  String _formatDateTime(String dateTimeStr) {
    final dt = DateTime.parse(dateTimeStr);
    return '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,

        surfaceTintColor: Colors.white,
        title: const Text('Employee Attendance'),

        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.calendar_month),
            onSelected: (String value) {
              if (value == 'today') {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => Today()));
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'today',
                child: ListTile(
                  leading: Icon(Icons.today),
                  title: Text("Today's Attendance"),
                ),
              ),
            ],
          ),
        ],
      ),
      backgroundColor:  Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_activeEmployee == null) Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _controller,
                maxLength: 4,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Enter Employee ID',
                  border: OutlineInputBorder(),
                  hintText: '4-digit code',
                ),
                onChanged: _checkInput,
              ),
            ),
            if (_activeEmployee != null)
            Container(
              color: _attendanceRecord?['check_out'] == null &&
                  _attendanceRecord?['check_in'] != null?Colors.green:Colors.red,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [

                    if (_activeEmployee == null) const SizedBox(height: 10),

                    Text(
                     _attendanceRecord?['check_out'] == null &&
                    _attendanceRecord?['check_in'] != null? 'Check - IN' : 'Check - OUT',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                Container(
                  width: screenWidth,
                height: screenHeight*0.05,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(screenWidth * 0.001),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 4,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '${_activeEmployee?['id'] ?? '-'}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenWidth * 0.03,
                        fontWeight: FontWeight.w700,
                      ),
                    ),),
                ),
                    SizedBox(height: screenHeight*0.02,),
                    Container(width: screenWidth*0.65,
                      height: screenHeight*0.5,color: Colors.yellow,),
                    SizedBox(height: screenHeight*0.02,),
                    Container(
                      width: screenWidth,
                      height: screenHeight*0.05,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(screenWidth * 0.001),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 4,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Center(
                        child:Text(
                          '${_activeEmployee?['name'] ?? '-'}',
                          style: TextStyle(
                            fontSize: screenWidth * 0.021,
                            fontWeight: FontWeight.w700,
                          ),
                        ),),
                    ),
                    SizedBox(height: screenHeight*0.01,),
                    Container(
                      width: screenWidth,
                      height: screenHeight*0.05,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(screenWidth * 0.001),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 4,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Center(
                        child:Text(
                          '${_activeEmployee?['department'] ?? '-'}',
                          style: TextStyle(
                            fontSize: screenWidth * 0.021,
                            fontWeight: FontWeight.w700,
                          ),
                        ),),
                    ),
                    SizedBox(height: screenHeight*0.01,),
                    Container(
                      width: screenWidth,
                      height: screenHeight*0.05,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(screenWidth * 0.001),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 4,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Center(
                        child:  Text(
                          _attendanceRecord?['check_in'] != null
                              ? _formatDateTime(_attendanceRecord!['check_in'])
                              : '-',style: TextStyle(color: Colors.green.shade900),
                        ),),
                    ),
                    _attendanceRecord?['check_out'] == null ?SizedBox():  Container(
                      width: screenWidth,

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(screenWidth * 0.001),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 4,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Center(
                        child:  Text(
                          _attendanceRecord?['check_out'] != null
                              ? _formatDateTime(_attendanceRecord!['check_out'])
                              : '-',
                          style:  TextStyle(color: Colors.red.shade900),
                        ), ),
                    ),

                    // Row(
                    //   children: [
                    //
                    //     Container(
                    //       width: screenWidth * 0.23,
                    //       height: screenHeight * 0.73875,
                    //       decoration: BoxDecoration(
                    //         color: Colors.white,
                    //         borderRadius: BorderRadius.circular(screenWidth * 0.01),
                    //         boxShadow: const [
                    //           BoxShadow(
                    //             color: Color(0x3F000000),
                    //             blurRadius: 4,
                    //             offset: Offset(0, 5),
                    //           ),
                    //         ],
                    //       ),
                    //       child: Column(
                    //         children: [
                    //           Container(
                    //             width: screenWidth * 0.23,
                    //             height: screenHeight * 0.652,
                    //             decoration: const BoxDecoration(
                    //               color: Color(0xFF94FA8E),
                    //             ),
                    //           ),
                    //           const Spacer(),
                    //           Container(
                    //             height: screenHeight * 0.075,
                    //             width: double.infinity,
                    //             decoration: const BoxDecoration(
                    //               color: Color(0xFF94FA8E),
                    //             ),
                    //             child: Center(
                    //               child: Text(
                    //                 'ID : ${_activeEmployee?['id'] ?? '-'}',
                    //                 style: TextStyle(
                    //                   fontSize: screenWidth * 0.015,
                    //                   fontWeight: FontWeight.w700,
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //     SizedBox(width: screenWidth * 0.063),
                    //     Container(
                    //       width: screenWidth * 0.5225,
                    //       height: screenHeight * 0.55,
                    //       decoration: BoxDecoration(
                    //         color: Colors.white,
                    //         borderRadius: BorderRadius.circular(screenWidth * 0.01),
                    //         boxShadow: const [
                    //           BoxShadow(
                    //             color: Color(0x3F000000),
                    //             blurRadius: 4,
                    //             offset: Offset(0, 5),
                    //           ),
                    //         ],
                    //       ),
                    //       child: Padding(
                    //         padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.0225),
                    //         child: Column(
                    //           children: [
                    //             SizedBox(height: screenHeight * 0.0525),
                    //             Container(
                    //               width: double.infinity,
                    //               height: screenHeight * 0.22375,
                    //               color: const Color(0xFFD9D9D9),
                    //               padding: EdgeInsets.only(
                    //                 left: screenWidth * 0.025,
                    //                 top: screenHeight * 0.03625,
                    //               ),
                    //               child: Column(
                    //                 crossAxisAlignment: CrossAxisAlignment.start,
                    //                 children: [
                    //                   Text(
                    //                     'Name  : ${_activeEmployee?['name'] ?? '-'}',
                    //                     style: TextStyle(
                    //                       fontSize: screenWidth * 0.021,
                    //                       fontWeight: FontWeight.w700,
                    //                     ),
                    //                   ),
                    //                   SizedBox(height: screenHeight * 0.035),
                    //                   Text(
                    //                     'Dep   : ${_activeEmployee?['department'] ?? '-'}',
                    //                     style: TextStyle(
                    //                       fontSize: screenWidth * 0.021,
                    //                       fontWeight: FontWeight.w700,
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //             SizedBox(height: screenHeight * 0.0425),
                    //             Container(
                    //               width: double.infinity,
                    //               height: screenHeight * 0.07625,
                    //               decoration: BoxDecoration(
                    //                 color: const Color(0xFF94FA8E),
                    //                 borderRadius: BorderRadius.vertical(top: Radius.circular(screenWidth * 0.0125)),
                    //               ),
                    //               child: Row(
                    //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //                 children: [
                    //                   const Text('Check IN :'),
                    //                   Text(
                    //                     _attendanceRecord?['check_in'] != null
                    //                         ? _formatDateTime(_attendanceRecord!['check_in'])
                    //                         : '-',
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //             SizedBox(height: screenHeight * 0.0125),
                    //             Container(
                    //               width: double.infinity,
                    //               height: screenHeight * 0.07625,
                    //               decoration: BoxDecoration(
                    //                 color: const Color(0xFFFF6B6B),
                    //                 borderRadius: BorderRadius.vertical(bottom: Radius.circular(screenWidth * 0.0125)),
                    //               ),
                    //               child: Row(
                    //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //                 children: [
                    //                   const Text(
                    //                     'Check OUT:',
                    //                     style: TextStyle(color: Colors.white),
                    //                   ),
                    //                   Text(
                    //                     _attendanceRecord?['check_out'] != null
                    //                         ? _formatDateTime(_attendanceRecord!['check_out'])
                    //                         : '-',
                    //                     style: const TextStyle(color: Colors.white),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
