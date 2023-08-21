import 'package:get/get.dart';
import 'package:vpn_basic_project/Controllers/VpnState.dart';

class VpnStatus {
  VpnStatus(
      {this.duration,
      this.lastPacketReceive,
      this.byteIn,
      this.byteOut,
      this.online = false});

  String? duration;
  String? lastPacketReceive;
  String? byteIn;
  String? byteOut;
  bool online;
  factory VpnStatus.fromJson(Map<String, dynamic> json) {
    final VpnState vpnState = Get.put(VpnState());
    vpnState.vpnEnginState(
        int.parse(json['duration'].toString().replaceAll(":", "").toString()) !=
            0);
    return VpnStatus(
        duration: json['duration'],
        lastPacketReceive: json['last_packet_receive'],
        byteIn: json['byte_in'],
        byteOut: json['byte_out'],
        online: int.parse(
                json['duration'].toString().replaceAll(":", "").toString()) !=
            0);
  }
  Map<String, dynamic> toJson() => {
        'duration': duration,
        'last_packet_receive': lastPacketReceive,
        'byte_in': byteIn,
        'byte_out': byteOut
      };
}
