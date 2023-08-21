import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:vpn_basic_project/Controllers/Storage.dart';
import 'package:vpn_basic_project/models/Vpn_list.dart';
import '../Controllers/VpnState.dart';
import '../models/vpn_status.dart';
import '../services/vpn_engine.dart';
import 'Server_Page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final VpnState vpnState = Get.put(VpnState());

  setSelectVpn() async {
    var res = LocStorage.instanse.getStorage(vkey: "selectVpn");
    await vpnState.setSelect(res ?? {});
  }

  @override
  void initState() {
    super.initState();
    setSelectVpn();
    VpnEngine.vpnStageSnapshot().listen((event) {
      vpnState.setStateVpn(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          var data = vpnState.state;

          return Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 100, bottom: 60),
                child: Text(
                  'PriviNet',
                  style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Loto'),
                ),
              ),
              FlutterSwitch(
                width: 170.0,
                height: 85.0,
                valueFontSize: 25.0,
                toggleSize: 70.0,
                value: (data != VpnEngine.vpnDisconnected ||
                    vpnState.vpnEngin == true),
                borderRadius: 50.0,
                padding: 10.0,
                duration: Duration(milliseconds: 300),
                activeToggleColor: Colors.white,
                toggleColor: Colors.white,
                inactiveColor: Color.fromARGB(255, 29, 29, 29),
                activeColor: Color.fromARGB(255, 54, 141, 80),
                onToggle: (val) {
                  vpnState.connectClick(val);
                },
              ),
              Container(
                margin: EdgeInsets.only(top: 40),
                child: Column(
                  children: [
                    Text(
                      vpnState.vpnEngin != true
                          ? data.toString().replaceAll('_', ' ').toUpperCase()
                          : VpnEngine.vpnConnected.toUpperCase(),
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Lato",
                        letterSpacing: 0.9,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      width: 245,
                      child: Text(
                        (data.toString() == VpnEngine.vpnConnected ||
                                vpnState.vpnEngin == true)
                            ? 'Your Conection is Secured Now'.toUpperCase()
                            : 'Your Conection Not Secured!'.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Mont",
                          letterSpacing: 0.9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
      bottomNavigationBar: Container(
        height: 200,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Internet Spped Miter
            StreamBuilder<VpnStatus?>(
                initialData: VpnStatus(),
                stream: VpnEngine.vpnStatusSnapshot(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: (snapshot.data!.online == true &&
                              snapshot.data!.online != null)
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // This IS Download Speed
                                Row(
                                  children: [
                                    Icon(Icons.arrow_drop_down_rounded),
                                    Text(
                                      "${snapshot.data!.byteIn}",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: "mont",
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                // rhis is Upload Speed
                                Row(
                                  children: [
                                    Text(
                                      snapshot.data!.byteOut.toString(),
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: "Mont",
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Icon(Icons.arrow_drop_up_rounded),
                                  ],
                                ),
                              ],
                            )
                          : SizedBox(),
                    );
                  } else {
                    return SizedBox();
                  }
                }),

            SizedBox(height: 10),
            GestureDetector(
              onTap: () => Get.to(ServerPage()),
              child: Obx(() {
                Map vpn = vpnState.slectVpn;
                var vpnData = VpnList.fromJson(vpn);

                return Container(
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Builder(
                            builder: (context) {
                              if (vpn.isNotEmpty) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset(
                                    'assets/flags/${vpnData.countryShort.toLowerCase()}.png',
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              } else {
                                return SizedBox();
                              }
                            },
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 25),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  vpn.isEmpty
                                      ? 'Please Select  a Vpn'
                                      : vpnData.countryLong,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: "Loto",
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 7),
                                Text(
                                  vpn.isEmpty
                                      ? 'Vpn Servers'
                                      : vpnData.countryShort,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 15),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 18,
                          color: const Color.fromARGB(82, 255, 255, 255),
                        ),
                      )
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
