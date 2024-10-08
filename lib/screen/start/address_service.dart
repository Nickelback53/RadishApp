import 'package:dio/dio.dart';
import 'package:radish_app/data/address_point_model.dart';
import 'package:radish_app/utils/logger.dart';
import 'package:radish_app/constants/keys.dart';
import 'package:radish_app/data/address_Model.dart';

class AddressService {
  Future<AddressModel> SearchAddressByStr(String text) async {
    final formData = {
      'key': VWORLD_KEY,
      'request': 'search',
      'type': 'ADDRESS',
      'category': 'ROAD',
      'query': text,
      'size': 30,
    };

    final response = await Dio().get(
        'https://api.vworld.kr/req/search', 
        queryParameters: formData)
        .catchError((e){
      logger.e(e.message);
    });

    logger.d(response);
    logger.d(response.data["response"]['result']);

    AddressModel addressModel = 
    AddressModel.fromJson(response.data["response"]);
    logger.d(addressModel);
    
    return addressModel;
  }

  Future<List<AddressPointModel>> findAddressByCoordinate({required double log, required double lat}) async {


    final List<Map<String, dynamic>> formDatas = <Map<String, dynamic>> [];

    formDatas.add({
      'key' :VWORLD_KEY,
      'service' :'address',
      'request' : 'GetAddress',
      'type' : 'PARCEL',
      'point' : '$log,$lat'
    });

    formDatas.add({
      'key' :VWORLD_KEY,
      'service' :'address',
      'request' : 'GetAddress',
      'type' : 'PARCEL',
      'point' : '${log+0.01},$lat'
    });
    
    formDatas.add({
      'key' :VWORLD_KEY,
      'service' :'address',
      'request' : 'GetAddress',
      'type' : 'PARCEL',
      'point' : '${log-0.01},$lat'
    });
    
    formDatas.add({
      'key' :VWORLD_KEY,
      'service' :'address',
      'request' : 'GetAddress',
      'type' : 'PARCEL',
      'point' : '$log,${lat+0.01}'
    });
    
    formDatas.add({
      'key' :VWORLD_KEY,
      'service' :'address',
      'request' : 'GetAddress',
      'type' : 'PARCEL',
      'point' : '$log,${lat-0.01}'
    });
    // final Map<String , dynamic> formData = {
    //   'key' :VWORLD_KEY,
    //   'service' :'address',
    //   'request' : 'GetAddress',
    //   'type' : 'PARCEL',
    //   'point' : '$log,$lat'
    // };

    List<AddressPointModel> addresses = [];

    for(Map<String, dynamic> formData in formDatas){
      final response = await Dio()
          .get(
            'https://api.vworld.kr/req/address',
            queryParameters: formData)
            .catchError((e){logger.e(e.message);
          });

      AddressPointModel addressModel = 
      AddressPointModel.fromJson(response.data["response"]);
      if(response.data['response']['status'] == 'OK') addresses.add(addressModel);
    }
    return addresses;
  }
}
