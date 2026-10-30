import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Lab02App());
}

class Lab02App extends StatelessWidget {
  const Lab02App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CSS3344 Lab 02',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const MainLayoutScreen(),
    );
  }
}

class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({super.key});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  DateTime _selectedDate = DateTime(2026, 10, 31);
  String _selectedRole = 'Slytherin';

  final List<String> _roles = const [
    'Gryffindor',
    'Slytherin',
    'Ravenclaw',
    'Hufflepuff',
  ];

  // 1. Material Date Picker
  Future<void> _selectMaterialDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1950),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  // 2. Cupertino Date Picker (Modal Bottom Sheet)
  void _showCupertinoDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 260,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Text('Done'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: _selectedDate,
                onDateTimeChanged: (DateTime newDate) {
                  setState(() => _selectedDate = newDate);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 3. Cupertino Wheel Picker (Modal Bottom Sheet)
  void _showCupertinoRolePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 240,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Text('Done'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Expanded(
              child: CupertinoPicker(
                itemExtent: 36,
                scrollController: FixedExtentScrollController(
                  initialItem: _roles.indexOf(_selectedRole) >= 0
                      ? _roles.indexOf(_selectedRole)
                      : 0,
                ),
                onSelectedItemChanged: (int index) {
                  setState(() => _selectedRole = _roles[index]);
                },
                children:
                _roles.map((role) => Center(child: Text(role))).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CSS3344 Mobile App Dev - Lab 02'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? _buildPortraitView()
              : _buildLandscapeView();
        },
      ),
    );
  }

  // Portrait Mode: Vertically stacked scrollable list
  Widget _buildPortraitView() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const StudentDetailsSection(),
        const SizedBox(height: 16),
        const TitleSection(
          name: 'Hogwarts School of Witchcraft and Wizardry',
          location: 'Hogsmeade, Scotland',
          starCount: 41,
        ),
        const SizedBox(height: 16),
        const ImageSection(), // <-- loads assets/images/hogwarts.jpg by default
        const SizedBox(height: 16),
        _buildPickersSection(),
      ],
    );
  }

  // Landscape Mode: Side-by-side two-column layout
  Widget _buildLandscapeView() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          flex: 1,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: StudentDetailsSection(),
          ),
        ),
        Expanded(
          flex: 1,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              const TitleSection(
                name: 'Hogwarts School of Witchcraft and Wizardry',
                location: 'Hogsmeade, Scotland',
                starCount: 41,
              ),
              const SizedBox(height: 16),
              const ImageSection(), // <-- loads assets/images/hogwarts.jpg by default
              const SizedBox(height: 16),
              _buildPickersSection(),
            ],
          ),
        ),
      ],
    );
  }

  // Section displaying interactive picker triggers & states
  Widget _buildPickersSection() {
    final String formattedDate =
        '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}';

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Interactive Pickers (Lab 2.2)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Selected Date: $formattedDate',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              'Selected House: $_selectedRole',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const Divider(height: 24),
            // Material Date Picker Button
            OutlinedButton.icon(
              icon: const Icon(Icons.calendar_month),
              label: const Text('Material Date Picker'),
              onPressed: () => _selectMaterialDate(context),
            ),
            const SizedBox(height: 8),
            // Cupertino Date Picker Button
            OutlinedButton.icon(
              icon: const Icon(Icons.calendar_today_outlined),
              label: const Text('Cupertino Date Picker (Modal Sheet)'),
              onPressed: () => _showCupertinoDatePicker(context),
            ),
            const Divider(height: 24),
            // Material Dropdown
            Row(
              children: [
                const Text('Material Dropdown: '),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: _selectedRole,
                  items: _roles.map((String role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() => _selectedRole = newValue);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Cupertino Wheel Picker Button
            OutlinedButton.icon(
              icon: const Icon(Icons.view_carousel_outlined),
              label: const Text('Cupertino House Wheel Picker'),
              onPressed: () => _showCupertinoRolePicker(context),
            ),
          ],
        ),
      ),
    );
  }
}

// Sub-widget 1: Modularized Student Details Section
class StudentDetailsSection extends StatelessWidget {
  const StudentDetailsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/avatar.jpg'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Reuben Wang Chai Yuen',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Student ID: BCS24020050',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
            const Divider(height: 28, thickness: 1),
            const Text(
              'Personal Life Goal / Quote:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              '"To develop impactful IoT and mobile solutions that solve real-world problems."',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.indigo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Sub-widget 2: Decomposed Title Section (Exercise 2.1)
class TitleSection extends StatelessWidget {
  final String name;
  final String location;
  final int starCount;

  const TitleSection({
    super.key,
    required this.name,
    required this.location,
    required this.starCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    location,
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                ],
              ),
            ),
            Icon(Icons.star, color: Colors.red[500]),
            const SizedBox(width: 4),
            Text('$starCount'),
          ],
        ),
      ),
    );
  }
}

// Sub-widget 3: Responsive Local Asset Image Section
class ImageSection extends StatelessWidget {
  final String imagePath;

  const ImageSection({
    super.key,
    this.imagePath = 'assets/hogwarts.png',
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        imagePath,
        width: double.infinity,
        height: 180,
        fit: BoxFit.cover,
      ),
    );
  }
}