import 'dart:async';

import 'package:flutter/material.dart';
import 'package:note_app_gsheet/google_sheets_api.dart';
import 'package:note_app_gsheet/loading_circle.dart';
import 'package:note_app_gsheet/notes_grid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  void post() {
    // print(_controller.tos);
    GoogleSheetsApi.insert(_controller.text);
    _controller.clear();
    setState(() {});
  }

// wait for the data to be fetched from google sheets
  void startLoading() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (GoogleSheetsApi.loading == false) {
        setState(() {
          timer.cancel();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(
              child: Text(
            'Post a Note',
            style: TextStyle(color: Colors.pink),
          )),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.grey[200],
        body: Column(children: [
          Expanded(
              child: GoogleSheetsApi.loading == true
                  ? const LoadingCircle()
                  : NotesGrid()),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                        hintText: 'Enter your ideas...',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        suffixIcon: IconButton(
                            onPressed: () {
                              _controller.clear();
                            },
                            icon: const Icon(Icons.clear))),
                  ),
                ),
                Expanded(
                  child: IconButton(
                      onPressed: () {
                        post();
                        // _controller.clear();
                      },
                      icon: const Icon(
                        Icons.send,
                        color: Colors.pink,
                      )),
                )
              ],
            ),
          ),
        ]));
  }
}
