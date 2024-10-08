import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:radish_app/utils/logger.dart';


class ImageStorage {
  static Future<List<String>> uploadImages(List<Uint8List>images, String itemKey) async {

    //이미지저장 DB타입 
    var metaData = SettableMetadata(contentType: 'image/jpeg');
    //다운로드 링크 리스트
    List<String> downloadUrls = [];
    //이미지 저장 경로지정
    for (int i = 0; i < images.length; i++) {
      Reference ref = FirebaseStorage.instance.ref('images/$itemKey/$i.jpg');
      if (images.isNotEmpty) {
        await ref.putData(images[i], metaData).catchError((onError) {
          logger.e(onError.toString());
        });

        downloadUrls.add(await ref.getDownloadURL());
      }
    }

    return downloadUrls;
  }
}