
// import 'package:trotter/trotter.dart';
// import 'package:path_provider/path_provider.dart'

// Future<String> get _localPath async {
//   final directory = await getApplicationDocumentsDirectory();
//
//   return directory.path;
// }
//
// Future<File> get _localFile async {
//   final path = await _localPath;
//   return File('$path/test.txt');
// }
//
// Future<File> writeCounter(int counter) async {
//   final file = await _localFile;
//   print("writing");
//   // Write the file.
//   return file.writeAsString('$counter');
// }
//
//
// Future<String> _read() async {
//   String text;
//   try {
//     final Directory directory = await getApplicationDocumentsDirectory();
//     // final File file = File('assets/textFiles/test.txt'); // Using path '/data/user/0/com.danielwilliams.neusea/app_flutter/test.txt'
//     final File file = File('assets/textFiles/test.txt'); // Using absolute path
//     text = await file.readAsString();
//   } catch (e) {
//     print("Couldn't read file");
//     print(e);
//   }
//   return text;
// }
//
//
// // Async File Opening and Reading Methods
// class FileUtils {
//   static Future<String> get getFilePath async {
//     final directory = await getApplicationDocumentsDirectory();
//     return directory.path;
//   }
//
//   static Future<File> get getFile async {
//     final path = await getFilePath;
//     return File('$path/assets/textFiles/test.txt');
//   }
//
//   static Future<String> readFromFile() async {
//     try {
//       final file = await getFile;
//       var fileContents = await file.readAsString();
//       print(fileContents);
//       return fileContents;
//     } catch (e) {
//       return "";
//     }
//   }
// }