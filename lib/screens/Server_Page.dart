import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpn_basic_project/Controllers/Storage.dart';
import 'package:vpn_basic_project/Widgets/VpnBox.dart';
import 'package:vpn_basic_project/res/Api.dart';

class ServerPage extends StatefulWidget {
  const ServerPage({super.key});
  @override
  State<ServerPage> createState() => _ServerPageState();
}

class _ServerPageState extends State<ServerPage> {
  var storage = LocStorage.instanse;

  var data = [];
  bool loading = true;
  getServers({load = false}) async {
    var vpnLocalData = storage.getStorage();
    if (vpnLocalData == null || vpnLocalData.isEmpty) {
      var res = await Api.getVPNServers();
      storage.setStorage(data: res, vkey: "vpn");
      setState(() {
        data = res;
        loading = false;
      });
    } else if (load) {
      var res = await Api.getVPNServers();
      storage.setStorage(data: res, vkey: "vpn");
      setState(() {
        data = res;
        loading = false;
      });
    } else {
      setState(() {
        data = vpnLocalData;
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getServers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'SELECT  VPN  LOCATION',
          style: TextStyle(fontWeight: FontWeight.w900, fontFamily: "Loto"),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 19,
            color: Color.fromARGB(169, 255, 255, 255),
          ),
        ),
      ),
      body: RefreshIndicator(
        backgroundColor: Colors.black,
        color: Colors.white,
        onRefresh: () async => await getServers(load: true),
        child: Builder(
          builder: (context) {
            if (loading) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            } else {
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return VpnBox(
                    vpn: data[index],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
