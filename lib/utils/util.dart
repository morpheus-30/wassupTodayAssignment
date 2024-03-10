import 'dart:io';

Future<bool> hasNetwork() async {
  try {
    final result = await InternetAddress.lookup('example.com');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } on SocketException catch (_) {
    return false;
  }
}

String humanizeDateTime(String date) {
  DateTime dateTime = DateTime.parse(date);
  return "${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute<10?'0'+dateTime.minute.toString():dateTime.minute}";
}