import 'package:flutter/material.dart';
import '../models/employee.dart';
import 'add_employee_screen.dart';
import 'edit_employee_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // In-memory list to store employee data
  final List<Employee> _employees = [
    Employee(
      id: '1',
      name: 'John Doe',
      birthPlace: 'Jakarta',
      birthDate: DateTime(1990, 5, 15),
      absentCount: 2,
    ),
    Employee(
      id: '2',
      name: 'Jane Smith',
      birthPlace: 'Bandung',
      birthDate: DateTime(1988, 8, 22),
      absentCount: 0,
    ),
    Employee(
      id: '3',
      name: 'Mike Johnson',
      birthPlace: 'Surabaya',
      birthDate: DateTime(1992, 3, 10),
      absentCount: 1,
    ),
  ];

  void _addEmployee() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddEmployeeScreen()),
    );
    
    if (result != null && result is Employee) {
      setState(() {
        _employees.add(result);
      });
    }
  }

  void _editEmployee(Employee employee) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditEmployeeScreen(employee: employee),
      ),
    );
    
    if (result != null) {
      if (result is Employee) {
        setState(() {
          final index = _employees.indexWhere((e) => e.id == employee.id);
          if (index != -1) {
            _employees[index] = result;
          }
        });
      } else if (result == 'DELETE') {
        _deleteEmployee(employee);
      }
    }
  }

  void _deleteEmployee(Employee employee) {
    setState(() {
      _employees.removeWhere((e) => e.id == employee.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${employee.name} has been deleted'),
        backgroundColor: Colors.green[600],
      ),
    );
  }

  void _markPresent(Employee employee) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${employee.name} is present'),
        backgroundColor: Colors.green[600],
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _markAbsent(Employee employee) {
    setState(() {
      employee.markAbsent();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${employee.name} marked as absent'),
        backgroundColor: Colors.orange[600],
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: const Text(
          'Employee Attendance',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green[600],
        elevation: 0,
      ),
      body: _employees.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 80,
                    color: Colors.green[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No employees yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.green[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the + button to add an employee',
                    style: TextStyle(
                      color: Colors.green[500],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _employees.length,
              itemBuilder: (context, index) {
                final employee = _employees[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green[100],
                      child: Text(
                        employee.name[0].toUpperCase(),
                        style: TextStyle(
                          color: Colors.green[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      employee.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Absent: ${employee.absentCount} times',
                      style: TextStyle(
                        color: employee.absentCount > 0 
                          ? Colors.orange[600] 
                          : Colors.green[600],
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow('Birth Place', employee.birthPlace),
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              'Birth Date', 
                              '${employee.birthDate.day}/${employee.birthDate.month}/${employee.birthDate.year}',
                            ),
                            const SizedBox(height: 16),
                            
                            // Attendance buttons
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => _markPresent(employee),
                                    icon: const Icon(Icons.check_circle),
                                    label: const Text('Present'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green[600],
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => _markAbsent(employee),
                                    icon: const Icon(Icons.cancel),
                                    label: const Text('Absent'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange[600],
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            
                            // Edit and Delete buttons
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () => _editEmployee(employee),
                                    icon: const Icon(Icons.edit),
                                    label: const Text('Edit Profile'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.green[600],
                                      side: BorderSide(color: Colors.green[600]!),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () => _deleteEmployee(employee),
                                    icon: const Icon(Icons.delete),
                                    label: const Text('Delete'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.red[600],
                                      side: BorderSide(color: Colors.red[600]!),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEmployee,
        backgroundColor: Colors.green[600],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
