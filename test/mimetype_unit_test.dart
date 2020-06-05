import 'package:flutter_test/flutter_test.dart';
import 'package:mime_type/mime_type.dart';


void main() {
  test('Fetch mimetype from file path', () {
    String path = 'storage/emulated/0/DCIM/Screenshots/Screenshot_20200605-120741.jpeg';
    String expectedmimetype = mime(path);
    String actualmimetype = 'image/jpeg';
    expect(expectedmimetype,actualmimetype);

    path = 'storage/emulated/0/Xender/video/darkside.mp4';
    expectedmimetype = mime(path);
    actualmimetype = 'video/mp4';
    expect(expectedmimetype,actualmimetype);

    path = 'storage/emulated/0/Ringtones/Charlie_puth.mp3';
    expectedmimetype = mime(path);
    actualmimetype = 'audio/mpeg';
    expect(expectedmimetype,actualmimetype);

  });
}
