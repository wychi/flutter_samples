import 'dart:async';
import 'dart:convert';
import 'dart:io';

class Api {
  HttpClient client = new HttpClient();

  static Api _sInstance;
  Api._();
  factory Api() {
    return _sInstance ??= new Api._();
  }

  Future<List<Map<String, dynamic>>> requestData({page, limit}) async {
    print("Api requestData");
    try {
      var qs = {
        "page": "0",
        "limit": "5",
      };
      var uri = Uri.parse('https://api.ratingtoken.io/token/ICORankList')
          .replace(queryParameters: qs);
      var request = await client.getUrl(uri);

      var response = await request.close();
      var responseBody = await response.transform(utf8.decoder).join();

      var list = json.decode(responseBody)['data']['list'] as List<dynamic>;

      var stage = "PreSale";
      var startTs = DateTime.now();

      return list.take(10).cast<Map<String, dynamic>>().map((mapData) {
        return {
          "name": mapData['currency'],
          "symbol": mapData['symbol'],
          "stage": stage,
          "startTs": startTs,
        };
      }).toList(growable: false);
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
