import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpn_basic_project/Controllers/Storage.dart';
import 'package:vpn_basic_project/models/Vpn_list.dart';
import 'package:vpn_basic_project/models/vpn_config.dart';
import 'package:vpn_basic_project/screens/Server_Page.dart';

import '../services/vpn_engine.dart';

class VpnState extends GetxController {
  RxMap slectVpn = {}.obs;
  RxBool vpnEngin = false.obs;
  RxString state = VpnEngine.vpnDisconnected.obs;
  vpnEnginState(val) {
    vpnEngin.value = val;
  }

  setStateVpn(vpnstate) {
    state.value = vpnstate;
  }

  Future setSelect(vpn) async {
    await LocStorage.instanse.setStorage(vkey: "selectVpn", data: vpn);
    slectVpn.value = vpn;
  }

  void connectClick(on) {
    if (slectVpn.isEmpty) {
      Get.to(ServerPage());
    } else {
      var vpnInfo = VpnList.fromJson(slectVpn);
      final data = Base64Decoder().convert(vpnInfo.openVPNConfigDataBase64);
      final config = Utf8Decoder().convert(data);
      var vpn = VpnConfig(
          country: vpnInfo.countryLong,
          username: 'vpn',
          password: 'vpn',
          config: config);
      if (on) {
        VpnEngine.startVpn(vpn);
      } else {
        VpnEngine.stopVpn();
        vpnEngin.value = false;
        state.value = VpnEngine.vpnDisconnected;
      }
    }
  }
}
