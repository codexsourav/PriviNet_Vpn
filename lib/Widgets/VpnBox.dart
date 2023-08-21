import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:vpn_basic_project/models/Vpn_list.dart';
import 'package:vpn_basic_project/services/vpn_engine.dart';

import '../Controllers/VpnState.dart';

class VpnBox extends StatelessWidget {
  final vpn;
  VpnBox({super.key, required this.vpn});
  final VpnState vpnState = Get.put(VpnState());
  @override
  Widget build(BuildContext context) {
    final vpnInfo = VpnList.fromJson(vpn);

    String img =
        "assets/flags/${vpnInfo.countryShort.toString().toLowerCase()}.png";
    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
          border: Border.all(
            color: Color.fromARGB(15, 255, 255, 255),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(18)),
      child: GestureDetector(
        onTap: () {
          vpnState.setSelect(vpn).then((value) {
            if (vpnState.state == VpnEngine.vpnDisconnected ||
                vpnState.state == VpnEngine.vpnConnected) {
              vpnState.connectClick(true);
              Get.back();
            } else {
              VpnEngine.stopVpn();
              Get.back();
            }
          });
        },
        child: Container(
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      img,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vpnInfo.countryLong.toString(),
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Loto",
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 7),
                        Row(
                          children: [
                            Icon(
                              Icons.speed_rounded,
                              size: 15,
                              color: Colors.white,
                            ),
                            SizedBox(width: 5),
                            Text(
                              _formatBytes(vpnInfo.speed, 1),
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                child: Row(
                  children: [
                    Text(
                      vpnInfo.numVpnSessions.toString(),
                      style: TextStyle(
                          fontSize: 12,
                          fontFamily: "Mont",
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 12),
                    Icon(
                      Icons.laptop_chromebook_rounded,
                      size: 17,
                      color: const Color.fromARGB(158, 255, 255, 255),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String _formatBytes(int bytes, int decimals) {
    if (bytes <= 0) return "0 B";
    const suffixes = ['B/S', "KB/S", "MB/S", "GB/S", "TB/S"];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }
}
