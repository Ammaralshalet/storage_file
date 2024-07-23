import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  File? file;

  Future<void> getFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      file = File(result.files.single.path!);

      String filename =
          '${DateTime.now().millisecondsSinceEpoch}.${result.files.single.extension!}';
      var refStorage = FirebaseStorage.instance.ref(filename);
      await refStorage.putFile(file!);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File Picker'),
      ),
      body: Column(
        children: [
          MaterialButton(
            onPressed: () async {
              await getFile();
            },
            child: const Text("Pick a File"),
          ),
          if (file != null)
            Text(
              'File Selected: ${file!.path.split('/').last}',
              style: const TextStyle(fontSize: 16),
            ),
        ],
      ),
    );
  }
}
