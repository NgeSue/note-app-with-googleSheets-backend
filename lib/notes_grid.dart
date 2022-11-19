import 'package:flutter/material.dart';
import 'package:note_app_gsheet/google_sheets_api.dart';
import 'text_box.dart';

class NotesGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GridView.builder(
            itemCount: GoogleSheetsApi.currentNotes.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4),
            itemBuilder: (BuildContext context, index) {
              return TextBox(text: GoogleSheetsApi.currentNotes[index]);
            }));
  }
}
