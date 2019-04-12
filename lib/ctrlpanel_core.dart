library flutter_ctrlpanel_core;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import './src/state.dart';

export './src/state.dart';

class UpdatedEvent {}

class CtrlpanelCore {
  static const MethodChannel _channel = const MethodChannel('flutter_ctrlpanel_core');

  static Future<CtrlpanelCore> asyncInit({String apiHost, String deseatmeApiHost, String syncToken}) async {
    final state = await _channel.invokeMethod('init', <String, dynamic>{'apiHost': apiHost, 'deseatmeApiHost': deseatmeApiHost, 'syncToken': syncToken});

    return CtrlpanelCore._internal(state);
  }

  Map<dynamic, dynamic> _state;
  final StreamController<UpdatedEvent> _stream;
  CtrlpanelCore._internal(this._state) : _stream = StreamController.broadcast();

  void _updateState(Map<dynamic, dynamic> state) {
    this._state = state;
    this._stream.add(UpdatedEvent());
  }

  Stream<UpdatedEvent> get onUpdate => _stream.stream;

  String get _id => _state['_id'];
  String get handle => _state['handle'];
  String get secretKey => _state['secretKey'];
  String get syncToken => _state['syncToken'];
  bool get hasAccount => _state['hasAccount'];
  bool get locked => _state['locked'];

  CtrlpanelParsedEntries get parsedEntries {
    return _state['parsedEntries'] != null ? CtrlpanelParsedEntries.fromJson(Map<String, dynamic>.from(_state['parsedEntries'])) : null;
  }

  Future<String> randomAccountPassword() async {
    return await _channel.invokeMethod("randomAccountPassword", <String, dynamic>{'_id': _id}) as String;
  }

  Future<String> randomHandle() async {
    return await _channel.invokeMethod("randomHandle", <String, dynamic>{'_id': _id}) as String;
  }

  Future<String> randomMasterPassword() async {
    return await _channel.invokeMethod("randomMasterPassword", <String, dynamic>{'_id': _id}) as String;
  }

  Future<String> randomSecretKey() async {
    return await _channel.invokeMethod("randomSecretKey", <String, dynamic>{'_id': _id}) as String;
  }

  Future<void> lock() async {
    _updateState(await _channel.invokeMethod("lock", <String, dynamic>{'_id': _id}));
  }

  Future<void> reset({@required String syncToken}) async {
    _updateState(await _channel.invokeMethod("reset", <String, dynamic>{'_id': _id, 'syncToken': syncToken}));
  }

  Future<void> signup({@required String handle, @required String secretKey, @required String masterPassword, @required bool saveDevice}) async {
    _updateState(await _channel.invokeMethod("signup", <String, dynamic>{
      '_id': _id,
      'handle': handle,
      'secretKey': secretKey,
      'masterPassword': masterPassword,
      'saveDevice': saveDevice,
    }));
  }

  Future<void> login({@required String handle, @required String secretKey, @required String masterPassword, @required bool saveDevice}) async {
    _updateState(await _channel.invokeMethod("login", <String, dynamic>{
      '_id': _id,
      'handle': handle,
      'secretKey': secretKey,
      'masterPassword': masterPassword,
      'saveDevice': saveDevice,
    }));
  }

  Future<void> unlock({@required String masterPassword}) async {
    _updateState(await _channel.invokeMethod("unlock", <String, dynamic>{'_id': _id, 'masterPassword': masterPassword}));
  }

  Future<void> connect() async {
    _updateState(await _channel.invokeMethod("connect", <String, dynamic>{'_id': _id}));
  }

  Future<void> sync() async {
    _updateState(await _channel.invokeMethod("sync", <String, dynamic>{'_id': _id}));
  }

  Future<void> setPaymentInformation(CtrlpanelPaymentInformation paymentInformation) async {
    _updateState(await _channel.invokeMethod("setPaymentInformation", <String, dynamic>{'_id': _id, 'paymentInformation': paymentInformation.toJson()}));
  }

  Future<List<CtrlpanelAccountMatch>> accountsForHostname(String hostname) async {
    final List<dynamic> result = await _channel.invokeMethod("accountsForHostname", <String, dynamic>{'_id': _id, 'hostname': hostname});
    return List.unmodifiable(result.map((data) {
      return CtrlpanelAccountMatch.fromJson(Map<String, dynamic>.from(data));
    }));
  }

  Future<void> createAccount({@required String id, @required CtrlpanelAccount data}) async {
    _updateState(await _channel.invokeMethod("createAccount", <String, dynamic>{'_id': _id, 'id': id, 'data': data.toJson()}));
  }

  Future<void> deleteAccount({@required String id}) async {
    _updateState(await _channel.invokeMethod("deleteAccount", <String, dynamic>{'_id': _id, 'id': id}));
  }

  Future<void> updateAccount({@required String id, @required CtrlpanelAccount data}) async {
    _updateState(await _channel.invokeMethod("updateAccount", <String, dynamic>{'_id': _id, 'id': id, 'data': data.toJson()}));
  }

  Future<void> createInboxEntry({@required String id, @required CtrlpanelInboxEntry data}) async {
    _updateState(await _channel.invokeMethod("createInboxEntry", <String, dynamic>{'_id': _id, 'id': id, 'data': data.toJson()}));
  }

  Future<void> deleteInboxEntry({@required String id}) async {
    _updateState(await _channel.invokeMethod("deleteInboxEntry", <String, dynamic>{'_id': _id, 'id': id}));
  }

  Future<void> importFromDeseatme({@required String exportToken}) async {
    _updateState(await _channel.invokeMethod("importFromDeseatme", <String, dynamic>{'_id': _id, 'exportToken': exportToken}));
  }

  Future<void> clearStoredData() async {
    _updateState(await _channel.invokeMethod("clearStoredData", <String, dynamic>{'_id': _id}));
  }

  Future<void> deleteUser() async {
    _updateState(await _channel.invokeMethod("deleteUser", <String, dynamic>{'_id': _id}));
  }
}
