// import 'package:flutter/material.dart';
// import 'package:flutter_expandable_table/flutter_expandable_table.dart';
// import 'package:intl/intl.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
//
// class Today extends StatefulWidget {
//   const Today({super.key});
//
//   @override
//   State<Today> createState() => _TodayState();
// }
//
// class _TodayState extends State<Today> {
//   List<Map<String, dynamic>> _employeeList_att = [];
//   bool _isLoading = false;
//   Set<int> _expandedIndices = {};
//   Future<void> _fetchToday() async {
//     setState(() => _isLoading = true);
//     try {
//       final today = DateTime.now();
//       final todayString = "${today.year.toString().padLeft(4, '0')}-"
//           "${today.month.toString().padLeft(2, '0')}-"
//           "${today.day.toString().padLeft(2, '0')}";
//       final response = await Supabase.instance.client
//           .schema('hr')
//           .from('attendance')
//           .select('id, date_att, check_in, check_out, eml_id!inner(id, name, department)')
//          // .select('id, date_att, eml_id, check_in, check_out, dt, ot')
//           .eq('date_att', todayString)
//           .order('id', ascending: true);
//
//       setState(() {
//         _employeeList_att = List<Map<String, dynamic>>.from(response);
//         print(_employeeList_att);
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
//   @override
//   void initState() {
//     super.initState();
//     _fetchToday();
//   }
//   String _formatTime(String? isoString) {
//     if (isoString == null || isoString.isEmpty) return 'N/A';
//     try {
//       final dt = DateTime.parse(isoString).toLocal();
//       return DateFormat('dd MMM yyyy - hh:mm a').format(dt);
//     } catch (_) {
//       return 'Invalid time';
//     }
//   }
//   @override
//
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Today\'s Attendance'),
//         ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : _employeeList_att.isEmpty
//           ? const Center(child: Text('No attendance records found for today.'))
//           : SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: DataTable(
//           columns: const [
//             DataColumn(label: Text('S/N')),
//             DataColumn(label: Text('Employee ID')),
//             DataColumn(label: Text('Name')),
//             DataColumn(label: Text('Department')),
//             DataColumn(label: Text('Check-in')),
//             DataColumn(label: Text('Check-out')),
//           ],
//           rows: List<DataRow>.generate(
//             _employeeList_att.length,
//                 (index) {
//               final item = _employeeList_att[index];
//               return DataRow(
//                 cells: [
//                   DataCell(Text('${index + 1}')), // Serial Number
//                   DataCell(Text(item['eml_id']['id']?.toString() ?? 'N/A')),
//                   DataCell(Text(item['eml_id']['name'] ?? '')),
//                   DataCell(Text(item['eml_id']['department'] ?? '')),
//                   DataCell(Text(_formatTime(item['check_in']))),
//                   DataCell(Text(_formatTime(item['check_out']))),
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//
//
//
//
//     );
//   }
// }
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Today extends StatefulWidget {
  const Today({super.key});

  @override
  State<Today> createState() => _TodayState();
}

class _TodayState extends State<Today> {
  List<Map<String, dynamic>> _employeeListAtt = [];
  bool _isLoading = false;

  late final _source = _AttendanceDataSource();

  @override
  void initState() {
    super.initState();
    _fetchToday();
  }

  Future<void> _fetchToday() async {
    setState(() => _isLoading = true);
    try {
      final today = DateTime.now();
      final todayString = DateFormat('yyyy-MM-dd').format(today);

      final response = await Supabase.instance.client
          .schema('hr')
          .from('attendance')
          .select('id, date_att, check_in, check_out, eml_id!inner(id, name, department)')
          .eq('date_att', todayString)
          .order('id', ascending: true);

      _employeeListAtt = List<Map<String, dynamic>>.from(response);
      _source.updateData(_employeeListAtt, _formatTime);
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

  String _formatTime(String? isoString) {
    if (isoString == null || isoString.isEmpty) return 'N/A';
    try {
      final dt = DateTime.parse(isoString).toLocal();
      return DateFormat('hh:mm a').format(dt);
    } catch (_) {
      return 'Invalid time';
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C9797),
        title: const Text("Today's Attendance"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _employeeListAtt.isEmpty
          ? const Center(
        child: Text(
          'No attendance records found for today.',
          style: TextStyle(color: Colors.white70),
        ),
      )
          : LayoutBuilder(
        builder: (context, constraints) {
          return Theme(
            data: theme.copyWith(
              cardColor: const Color(0xFF1B1B1B),
              dividerColor: Colors.transparent,
              dataTableTheme: DataTableThemeData(
                headingRowColor:
                MaterialStateProperty.all(const Color(0xFF2C2C2C)),
                dataRowColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.selected)) {
                    return const Color(0xFF333333);
                  }
                  return const Color(0xFF1B1B1B);
                }),
                headingTextStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                dataTextStyle: const TextStyle(color: Colors.white70),
              ),
            ),
            child: SizedBox(
              height: constraints.maxHeight,
              child: PaginatedDataTable2(
                columns: const [
                  DataColumn(label: Text('S/N')),
                  DataColumn(label: Text('Employee ID')),
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Department')),
                  DataColumn(label: Text('Check-in')),
                  DataColumn(label: Text('Check-out')),
                ],
                source: _source,
                rowsPerPage: _employeeListAtt.length,
                columnSpacing: 20,
                horizontalMargin: 12,
                headingRowHeight: 48,
                dataRowHeight: 52,
              ),
            ),
          );
        },
      ),
    );
  }

// Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: const Text("Today's Attendance")),
  //     body: _isLoading
  //         ? const Center(child: CircularProgressIndicator())
  //         : _employeeListAtt.isEmpty
  //         ? const Center(child: Text('No attendance records found for today.'))
  //         : LayoutBuilder(
  //       builder: (context, constraints) {
  //         return SizedBox(
  //           height: constraints.maxHeight, // Constrains height
  //           child: PaginatedDataTable2(
  //             columns: const [
  //               DataColumn(label: Text('S/N')),
  //               DataColumn(label: Text('Employee ID')),
  //               DataColumn(label: Text('Name')),
  //               DataColumn(label: Text('Department')),
  //               DataColumn(label: Text('Check-in')),
  //               DataColumn(label: Text('Check-out')),
  //             ],
  //             source: _source,
  //             rowsPerPage: _employeeListAtt.length,
  //           ),
  //         );
  //       },
  //     )
  //
  //   );
  // }
}

class _AttendanceDataSource extends DataTableSource {
  List<Map<String, dynamic>> _data = [];
  String Function(String?) _formatter = (_) => 'N/A';

  void updateData(List<Map<String, dynamic>> data, String Function(String?) formatter) {
    _data = data;
    _formatter = formatter;
    notifyListeners();
  }

  @override
  DataRow? getRow(int index) {
    if (index >= _data.length) return null;

    final item = _data[index];
    final eml = item['eml_id'] ?? {};

    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text('${index + 1}')),
        DataCell(Text(eml['id']?.toString() ?? 'N/A')),
        DataCell(Text(eml['name'] ?? '')),
        DataCell(Text(eml['department'] ?? '')),
        DataCell(Text(_formatter(item['check_in']))),
        DataCell(Text(_formatter(item['check_out']))),
      ],
    );
  }

  @override
  int get rowCount => _data.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:syncfusion_flutter_datagrid/datagrid.dart';
//
// class Today extends StatefulWidget {
//   const Today({super.key});
//
//   @override
//   State<Today> createState() => _TodayState();
// }
//
// class _TodayState extends State<Today> {
//   List<AttendanceRecord> _records = [];
//   bool _isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchToday();
//   }
//
//   Future<void> _fetchToday() async {
//     setState(() => _isLoading = true);
//     try {
//       final today = DateTime.now();
//       final todayString = DateFormat('yyyy-MM-dd').format(today);
//
//       final response = await Supabase.instance.client
//           .schema('hr')
//           .from('attendance')
//           .select('id, date_att, check_in, check_out, eml_id!inner(id, name, department)')
//           .eq('date_att', todayString)
//           .order('id', ascending: true);
//
//       final data = List<Map<String, dynamic>>.from(response);
//       _records = data.map((item) {
//         return AttendanceRecord(
//           id: item['eml_id']['id'] ?? 0,
//           name: item['eml_id']['name'] ?? '',
//           department: item['eml_id']['department'] ?? '',
//           checkIn: _formatTime(item['check_in']),
//           checkOut: _formatTime(item['check_out']),
//         );
//       }).toList();
//
//       setState(() {});
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error fetching employees: $e')),
//         );
//       }
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
//
//   String _formatTime(String? isoString) {
//     if (isoString == null || isoString.isEmpty) return 'N/A';
//     try {
//       final dt = DateTime.parse(isoString).toLocal();
//       return DateFormat('hh:mm a').format(dt);
//     } catch (_) {
//       return 'Invalid time';
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final dataSource = AttendanceDataSource(records: _records);
//
//     return Scaffold(
//       appBar: AppBar(title: const Text("Today's Attendance")),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : _records.isEmpty
//           ? const Center(child: Text('No attendance records found for today.'))
//           : SfDataGrid(
//         source: dataSource,
//         columnWidthMode: ColumnWidthMode.fill,
//         columns: [
//           GridColumn(
//             columnName: 'sn',
//             label: Center(child: Text('S/N', style: TextStyle(fontWeight: FontWeight.bold))),
//           ),
//            GridColumn(
//             columnName: 'id',
//             label: Center(child: Text('Employee ID', style: TextStyle(fontWeight: FontWeight.bold))),
//           ),
//            GridColumn(
//             columnName: 'name',
//             label: Center(child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
//           ),
//            GridColumn(
//             columnName: 'dept',
//             label: Center(child: Text('Department', style: TextStyle(fontWeight: FontWeight.bold))),
//           ),
//            GridColumn(
//             columnName: 'in',
//             label: Center(child: Text('Check-in', style: TextStyle(fontWeight: FontWeight.bold))),
//           ),
//            GridColumn(
//             columnName: 'out',
//             label: Center(child: Text('Check-out', style: TextStyle(fontWeight: FontWeight.bold))),
//           ),
//         ],
//       ),
//     );
//   }
// }
// class AttendanceRecord {
//   final int id;
//   final String name;
//   final String department;
//   final String checkIn;
//   final String checkOut;
//
//   AttendanceRecord({
//     required this.id,
//     required this.name,
//     required this.department,
//     required this.checkIn,
//     required this.checkOut,
//   });
// }
//
// class AttendanceDataSource extends DataGridSource {
//   AttendanceDataSource({required List<AttendanceRecord> records}) {
//     _rows = records.asMap().entries.map((entry) {
//       int index = entry.key;
//       final record = entry.value;
//       return DataGridRow(cells: [
//         DataGridCell<int>(columnName: 'sn', value: index + 1),
//         DataGridCell<int>(columnName: 'id', value: record.id),
//         DataGridCell<String>(columnName: 'name', value: record.name),
//         DataGridCell<String>(columnName: 'dept', value: record.department),
//         DataGridCell<String>(columnName: 'in', value: record.checkIn),
//         DataGridCell<String>(columnName: 'out', value: record.checkOut),
//       ]);
//     }).toList();
//   }
//
//   late List<DataGridRow> _rows;
//
//   @override
//   List<DataGridRow> get rows => _rows;
//
//   @override
//   DataGridRowAdapter buildRow(DataGridRow row) {
//     return DataGridRowAdapter(
//       cells: row.getCells().map((cell) {
//         return Container(
//           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//           alignment: Alignment.centerLeft,
//           child: Text(cell.value.toString()),
//         );
//       }).toList(),
//     );
//   }
// }
