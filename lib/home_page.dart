import 'package:flutter/material.dart';
import 'package:note_app_gsheet/google_sheets_api.dart';
import 'package:note_app_gsheet/notes_grid.dart';
import 'package:note_app_gsheet/text_box.dart';

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
          NotesGrid(),
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
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     const Text('@ c r e a t e d by s y s'),
                //     ElevatedButton(
                //         onPressed: () {
                //           post();
                //         },
                //         child: const Text('POST'))
                //   ],
                // )
              ],
            ),
          ),
        ]));
  }
}
