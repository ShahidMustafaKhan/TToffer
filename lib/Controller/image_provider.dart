import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:tt_offer/Utils/utils.dart';

class ImageNotifyProvider extends ChangeNotifier {
  List<String> imagePaths = [];
  var vedioPath = "";
  bool isCompressing = false;

////////////////////////////////////////// Image From Camera ///////////////////////////////////////
  ///
 

  ///

  Future<void> takePicture() async {
    isCompressing = true;
    notifyListeners();
    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      await compressAndAddImage(pickedFile.path);
    }
    isCompressing = false;
    notifyListeners();
  }
////////////////////////////////////////// Image From Galery ///////////////////////////////////////

  Future<void> getImagesFromGallery() async {
    isCompressing = true;
    notifyListeners();
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    for (var pickedFile in pickedFiles) {
      await compressAndAddImage(pickedFile.path);
    }
    isCompressing = false;
    notifyListeners();
  }
////////////////////////////////////////// Image Compression ///////////////////////////////////////

  Future<void> compressAndAddImage(String imagePath) async {
    img.Image? image = img.decodeImage(File(imagePath).readAsBytesSync());

    img.Image compressedImage = img.copyResize(image!, width: 800);
    List<int> compressedImageData = img.encodeJpg(compressedImage, quality: 85);

    String compressedImagePath = await saveCompressedImage(compressedImageData);

    imagePaths.add(compressedImagePath);
    isCompressing = false;
    notifyListeners();
  }

  Future<String> saveCompressedImage(List<int> imageData) async {
    final tempDir = await getTemporaryDirectory();
    final tempFile = await File(
            '${tempDir.path}/compressed_image_${DateTime.now().millisecondsSinceEpoch}.jpg')
        .create();

    await tempFile.writeAsBytes(imageData);

    return tempFile.path;
  }
////////////////////////////////////////// Get Vedio  ///////////////////////////////////////

  Future<void> getVediosFromGallery(context) async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFiles != null) {
      // Check file size before compression
      File videoFile = File(pickedFiles.path);
      int fileSizeInBytes = await videoFile.length();
      int fileSizeInMB = fileSizeInBytes ~/ (1024 * 1024);

      if (fileSizeInMB > 2) {
        showSnackBar(context, "Selected video file size exceeds 2 MB.");
        return;
      }

      vedioPath = pickedFiles.path;
      notifyListeners();
    }
  }

  // Future<void> _compressVideo(String videoPath) async {
  //   final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
  //   Directory tempDir = await getTemporaryDirectory();
  //   String outputFileName =
  //       'compressed_video_${DateTime.now().millisecondsSinceEpoch}.mp4'; // Unique output file name
  //   String outputFilePath =
  //       '${tempDir.path}/$outputFileName'; // Output file path in the temporary directory

  //   // Compression command
  //   String command =
  //       '-i $videoPath -b:v 500K $outputFilePath'; // Set video bitrate to 1M (1 megabit per second)

  //   // Run FFmpeg command
  //   int returnCode = await _flutterFFmpeg.execute(command);

  //   if (returnCode == 0) {
  //     print(
  //         'Video compression successful. Compressed video saved at: $outputFilePath');
  //     setState(() {
  //       vedioPath = outputFilePath;
  //     });
  //   } else {
  //     print('Video compression failed.');
  //   }
  // }
}
