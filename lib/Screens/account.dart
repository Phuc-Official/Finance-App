import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {

  String _name = '';

  @override
  void initState() {
    super.initState();
    _loadName();
  }

  Future<void> _loadName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('userName') ?? '';
    });
  }

  void _editName() {

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Name'),
        content: TextField(
          controller: TextEditingController(text: _name),
          onChanged: (value) {
            setState(() {
              _name = value;
            });
          },
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('userName', _name);
              Navigator.of(context).pop();
            },
            child: const Text('Save', style: TextStyle(fontFamily: 'Inter')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(height: 100),
        Text(_name, style: const TextStyle(fontFamily: 'Inter')),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: _editName,
          child: const Icon(Icons.edit_outlined),
        ),
      ],
    );
  }
}