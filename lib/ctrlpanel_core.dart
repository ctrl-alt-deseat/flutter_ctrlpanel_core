library flutter_ctrlpanel_core;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_jsbridge/jsbridge.dart';

import './js_source.dart';
import './state.dart';

export './state.dart';

class UpdatedEvent {}

class CtrlpanelCore {
  static Future<CtrlpanelCore> asyncInit({String apiHost, String deseatmeApiHost, String syncToken}) async {
    final bridge = JSBridge(libraryCode);

    await bridge.call("Ctrlpanel.boot", [apiHost, deseatmeApiHost]);
    final state = await bridge.call("Ctrlpanel.init", [syncToken]);

    return CtrlpanelCore._internal(bridge, state);
  }

  final JSBridge _bridge;
  Map<String, dynamic> _state;
  final StreamController<UpdatedEvent> _stream;
  CtrlpanelCore._internal(this._bridge, this._state):
    _stream = StreamController.broadcast();

  void _updateState(Map<String, dynamic> state) {
    this._state = state;
    this._stream.add(UpdatedEvent());
  }

  Stream<UpdatedEvent> get onUpdate { return _stream.stream; }

  String get handle { return _state['handle']; }
  String get secretKey { return _state['secretKey']; }
  String get syncToken { return _state['syncToken']; }

  bool get hasAccount { return _state['kind'] != 'empty'; }
  bool get locked { return _state['kind'] == 'empty' || _state['kind'] == 'locked'; }

  CtrlpanelParsedEntries get parsedEntries { return _state['parsedEntries'] != null ? CtrlpanelParsedEntries.fromJson(_state['parsedEntries']) : null; }

  Future<String> randomAccountPassword() async {
    return await _bridge.call("Ctrlpanel.randomAccountPassword", []);
  }

  Future<String> randomHandle() async {
    return await _bridge.call("Ctrlpanel.randomHandle", []);
  }

  Future<String> randomMasterPassword() async {
    return await _bridge.call("Ctrlpanel.randomMasterPassword", []);
  }

  Future<String> randomSecretKey() async {
    return await _bridge.call("Ctrlpanel.randomSecretKey", []);
  }

  Future<void> lock() async {
    _updateState(await _bridge.call("Ctrlpanel.lock", []));
  }

  Future<void> reset({@required String syncToken}) async {
    _updateState(await _bridge.call("Ctrlpanel.init", [syncToken]));
  }

  Future<void> signup({@required String handle, @required String secretKey, @required String masterPassword, @required bool saveDevice}) async {
    _updateState(await _bridge.call("Ctrlpanel.signup", [handle, secretKey, masterPassword, saveDevice]));
  }

  Future<void> login({@required String handle, @required String secretKey, @required String masterPassword, @required bool saveDevice}) async {
    _updateState(await _bridge.call("Ctrlpanel.login", [handle, secretKey, masterPassword, saveDevice]));
  }

  Future<void> unlock({@required String masterPassword}) async {
    _updateState(await _bridge.call("Ctrlpanel.unlock", [masterPassword]));
  }

  Future<void> connect() async {
    _updateState(await _bridge.call("Ctrlpanel.connect", []));
  }

  Future<void> sync() async {
    _updateState(await _bridge.call("Ctrlpanel.sync", []));
  }

  Future<void> setPaymentInformation(CtrlpanelPaymentInformation paymentInformation) async {
    _updateState(await _bridge.call("Ctrlpanel.setPaymentInformation", [paymentInformation]));
  }

  Future<List<CtrlpanelAccountMatch>> accountsForHostname(String hostname) async {
    final List<dynamic> result = await _bridge.call("Ctrlpanel.accountsForHostname", [hostname]);
    return List.unmodifiable(result.map((data) { return CtrlpanelAccountMatch.fromJson(data); }));
  }

  Future<void> createAccount({@required String id, @required CtrlpanelAccount data}) async {
    _updateState(await _bridge.call("Ctrlpanel.createAccount", [id, data]));
  }

  Future<void> deleteAccount({@required String id}) async {
    _updateState(await _bridge.call("Ctrlpanel.deleteAccount", [id]));
  }

  Future<void> updateAccount({@required String id, @required CtrlpanelAccount data}) async {
    _updateState(await _bridge.call("Ctrlpanel.updateAccount", [id, data]));
  }

  Future<void> createInboxEntry({@required String id, @required CtrlpanelInboxEntry data}) async {
    _updateState(await _bridge.call("Ctrlpanel.createInboxEntry", [id, data]));
  }

  Future<void> deleteInboxEntry({@required String id}) async {
    _updateState(await _bridge.call("Ctrlpanel.deleteInboxEntry", [id]));
  }

  Future<void> updateInboxEntry({@required String id, @required CtrlpanelInboxEntry data}) async {
    _updateState(await _bridge.call("Ctrlpanel.updateInboxEntry", [id, data]));
  }

  Future<void> importFromDeseatme({@required String exportToken}) async {
    _updateState(await _bridge.call("Ctrlpanel.importFromDeseatme", [exportToken]));
  }

  Future<void> clearStoredData() async {
    _updateState(await _bridge.call("Ctrlpanel.clearStoredData", []));
  }

  Future<void> deleteUser() async {
    _updateState(await _bridge.call("Ctrlpanel.deleteUser", []));
  }
}
