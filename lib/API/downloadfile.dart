import 'dart:io';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class DownloadFile {
  

  Future<File?> downloadFile(String url, String filename) async {
    try {
      final downloadsDirectory = await getExternalStorageDirectory();
      final file = File('${downloadsDirectory!.path}/$filename');
      final dio = Dio();
      final response = await dio.get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
        ),
      );

      if (response.statusCode == 200) {
        await file.writeAsBytes(response.data);
        return file;
      } else if (response.statusCode == 302) {
        // Handle redirects if necessary
        final redirectUrl = response.headers['location']?.first;
        if (redirectUrl != null) {
          return downloadFile(redirectUrl, filename);
        }
      }

      print("Error downloading. Status Code: ${response.statusCode}");
      return null;
    } catch (e) {
      print("Error downloading: $e");
      return null;
    }
  }
}
