import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:latlng/latlng.dart';
import 'package:radish_app/constants/data_keys.dart';
import 'package:radish_app/data/item_model.dart';

import '../utils/logger.dart';

class ItemService {
  static final ItemService _itemService = ItemService._internal();
  factory ItemService() => _itemService;
  ItemService._internal();

  Future createNewItem(
    ItemModel itemModel, String itemKey, String userKey) async {
    DocumentReference<Map<String, dynamic>> documentReference =
      FirebaseFirestore.instance.collection(COL_ITEMS).doc(itemKey);
    DocumentReference<Map<String, dynamic>> userItemDocReference =
      FirebaseFirestore.instance
      .collection(COL_USERS)
      .doc(userKey)
      .collection(COL_USER_ITEMS)
      .doc(itemKey);
    final DocumentSnapshot documentSnapshot = await documentReference.get();

    if(!documentSnapshot.exists) {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(documentReference, itemModel.toJson());
        transaction.set(userItemDocReference, itemModel.toMinJson());
      });
    }
  }

  Future<ItemModel> getItem(String itemKey) async {
    if(itemKey[0] == ':'){
      itemKey = itemKey.substring(1);
    }
    DocumentReference<Map<String, dynamic>> documentReference =
    FirebaseFirestore.instance.collection(COL_ITEMS).doc(itemKey);
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
    await documentReference.get();
    ItemModel itemModel = ItemModel.fromSnapshot(documentSnapshot);
    return itemModel;
  }

  Future<List<ItemModel>> getItems() async{
    //컬랙션 접근
    CollectionReference<Map<String, dynamic>> collectionReference =
    FirebaseFirestore.instance.collection(COL_ITEMS);
    //컬랙션 받기
    QuerySnapshot<Map<String, dynamic>>  snapshots = 
      await collectionReference.get();
    //받아온 데이터 아이템 모델로 저장
    List<ItemModel> items = [];
    for(int i=0;i<snapshots.size;i++){
      ItemModel itemModel = ItemModel.fromQuerySnapshot(snapshots.docs[i]);
      items.add(itemModel);
    }

    return items;
  }

  Future<List<ItemModel>> getUserItems(String userKey,
      {String? itemKey}) async {
    CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance
            .collection(COL_USERS)
            .doc(userKey)
            .collection(COL_USER_ITEMS);
    QuerySnapshot<Map<String, dynamic>> snapshots =
        await collectionReference.get();
    List<ItemModel> items = [];
    for (int i = 0; i < snapshots.size; i++) {
      ItemModel itemModel = ItemModel.fromQuerySnapshot(snapshots.docs[i]);
      if (!(itemKey != null && itemKey == itemModel.itemKey))
        items.add(itemModel);
    }
    return items;
  }

  Future<List<ItemModel>> getNearByItems(String userKey, LatLng latLng) async {
    final geo = GeoFlutterFire();
    final itemCol = FirebaseFirestore.instance.collection(COL_ITEMS);
    GeoFirePoint center = geo.point(latitude: latLng.latitude, longitude: latLng.longitude);
    double radius = 10;
    var field = 'geoFirePoint';

    List<ItemModel> items = [];
    List<DocumentSnapshot<Object?>> snapshots = await geo
        .collection(collectionRef: itemCol)
        .within(center: center, radius: radius, field: field)
        .first
        ;
        logger.d('upload finished - ${snapshots.toString()}');
    // for (int i = 0; i < snapshots.length; i++) {
    //   //ItemModel itemModel = ItemModel.fromSnapshot(snapshots[i]);
    //   // todo: remove my own item
    //   items.add(itemModel);
    // }
    return items;
  }

}