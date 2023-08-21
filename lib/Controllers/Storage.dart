import 'package:localstorage/localstorage.dart';

class LocStorage {
  final LocalStorage storage = new LocalStorage('privinet');
  LocStorage._private();

  static LocStorage instanse = LocStorage._private();

  getStorage({vkey = "vpn"}) {
    return storage.getItem(vkey);
  }

  setStorage({vkey = "vpn", data}) async {
    await storage.setItem(vkey, data);
    return data;
  }
}
