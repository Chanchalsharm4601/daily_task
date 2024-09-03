import 'package:flutter/material.dart';

class ListItemActions extends StatelessWidget {
  final int index;
  final String text;
  final VoidCallback onDelete;
  final ValueChanged<String> onEdit;

  ListItemActions({
    required this.index,
    required this.text,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      onSelected: (value) {
        if (value == 1) {
          _editItem(context);
        } else if (value == 2) {
          onDelete();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Text('Edit'),
        ),
        PopupMenuItem(
          value: 2,
          child: Text('Delete'),
        ),
      ],
      icon: Icon(Icons.more_vert, color: Colors.black87),
    );
  }

  void _editItem(BuildContext context) {
    final _editController = TextEditingController(text: text);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Item'),
        content: TextField(
          controller: _editController,
          decoration: InputDecoration(labelText: 'Edit text'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              onEdit(_editController.text);
              Navigator.of(context).pop();
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
