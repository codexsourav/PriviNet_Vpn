import 'package:csv/csv.dart';
import 'package:http/http.dart' as http;
import 'package:vpn_basic_project/models/Vpn_list.dart';

class Api {
  static Future getVPNServers() async {
    try {
      List vpnList = [];
      final res =
          await http.get(Uri.parse('http://www.vpngate.net/api/iphone/'));
      final csvString = res.body.split("#")[1].replaceAll('*', '');
      List<List<dynamic>> list = const CsvToListConverter().convert(csvString);
      final header = list[0];

      for (int i = 1; i < list.length - 1; ++i) {
        Map<String, dynamic> tempJson = {};
        for (int j = 0; j < header.length; ++j) {
          tempJson.addAll({header[j].toString(): list[i][j]});
        }
        vpnList.add(tempJson);
      }
      vpnList.shuffle();
      return vpnList;
    } catch (e) {
      print(e);
      return [];
    }
  }
}
