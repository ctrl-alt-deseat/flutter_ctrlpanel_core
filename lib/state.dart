import 'dart:ui' show hashValues;

import 'package:flutter/foundation.dart' show required;

class CtrlpanelAccount {
  final String handle;
  final String hostname;
  final String password;
  final String otpauth;

  CtrlpanelAccount({@required this.handle, @required this.hostname, @required this.password, this.otpauth});

  CtrlpanelAccount.fromJson(Map<String, dynamic> data):
    this.handle = data['handle'],
    this.hostname = data['hostname'],
    this.password = data['password'],
    this.otpauth = data['otpauth'];

  Map<String, dynamic> toJson() => (
    otpauth == null
      ? {'handle': handle, 'hostname': hostname, 'password': password}
      : {'handle': handle, 'hostname': hostname, 'password': password, 'otpauth': otpauth}
  );

  bool operator ==(o) => o is CtrlpanelAccount && o.handle == handle && o.hostname == hostname && o.password == password && o.otpauth == otpauth;
  int get hashCode => hashValues(handle, hostname, password, otpauth);
}

class CtrlpanelInboxEntry {
  final String hostname;
  final String email;

  CtrlpanelInboxEntry({@required this.hostname, @required this.email});

  CtrlpanelInboxEntry.fromJson(Map<String, dynamic> data):
    this.hostname = data['hostname'],
    this.email = data['email'];

  Map<String, dynamic> toJson() => {'hostname': hostname, 'email': email};

  bool operator ==(o) => o is CtrlpanelInboxEntry && o.hostname == hostname && o.email == email;
  int get hashCode => hashValues(hostname, email);
}

class CtrlpanelParsedEntries {
  final Map<String, CtrlpanelAccount> accounts;
  final Map<String, CtrlpanelInboxEntry> inbox;

  CtrlpanelParsedEntries({this.accounts = const {}, this.inbox = const {}});

  CtrlpanelParsedEntries.fromJson(Map<String, dynamic> data):
    this.accounts = (data['accounts'] as Map<String, dynamic>).map((key, value) { return MapEntry(key, CtrlpanelAccount.fromJson(value)); }),
    this.inbox = (data['inbox'] as Map<String, dynamic>).map((key, value) { return MapEntry(key, CtrlpanelInboxEntry.fromJson(value)); });

  Map<String, dynamic> toJson() => {'accounts': accounts, 'inbox': inbox};

  bool operator ==(o) => o is CtrlpanelParsedEntries && o.accounts == accounts && o.inbox == inbox;
  int get hashCode => hashValues(accounts, inbox);
}

class CtrlpanelAccountMatch {
  final String id;
  final double score;
  final CtrlpanelAccount account;

  CtrlpanelAccountMatch({@required this.id, @required this.score, @required this.account});

  CtrlpanelAccountMatch.fromJson(Map<String, dynamic> data):
    this.id = data['id'],
    this.score = (data['score'] as num).toDouble(),
    this.account = CtrlpanelAccount.fromJson(data);

  Map<String, dynamic> toJson() => {'id': id, 'score': score}..addAll(account.toJson());

  bool operator ==(o) => o is CtrlpanelAccountMatch && o.id == id && o.score == score && o.account ==account;
  int get hashCode => hashValues(id, score, account);
}

abstract class CtrlpanelPaymentInformation {
  static CtrlpanelPaymentInformation fromJson(Map<String, dynamic> data) {
    if (data['type'] == 'apple') return CtrlpanelApplePaymentInformation.fromJson(data);
    if (data['type'] == 'stripe') return CtrlpanelStripePaymentInformation.fromJson(data);
    assert(false);
    return null;
  }
}

class CtrlpanelApplePaymentInformation extends CtrlpanelPaymentInformation {
  final String transactionIdentifier;

  CtrlpanelApplePaymentInformation({@required this.transactionIdentifier});

  CtrlpanelApplePaymentInformation.fromJson(Map<String, dynamic> data):
    assert(data['type'] == 'apple'),
    this.transactionIdentifier = data['transactionIdentifier'];

  Map<String, dynamic> toJson() => {'type': 'apple', 'transactionIdentifier': transactionIdentifier};

  bool operator ==(o) => o is CtrlpanelApplePaymentInformation && o.transactionIdentifier == transactionIdentifier;
  int get hashCode => transactionIdentifier.hashCode;
}

class CtrlpanelStripePaymentInformation extends CtrlpanelPaymentInformation {
  final String email;
  final String plan;
  final String token;

  CtrlpanelStripePaymentInformation({@required this.email, @required this.plan, @required this.token});

  CtrlpanelStripePaymentInformation.fromJson(Map<String, dynamic> data):
    assert(data['type'] == 'stripe'),
    this.email = data['email'],
    this.plan = data['plan'],
    this.token = data['token'];

  Map<String, dynamic> toJson() => {'type': 'stripe', 'email': email, 'plan': plan, 'token': token};

  bool operator ==(o) => o is CtrlpanelStripePaymentInformation && o.email == email && o.plan == plan && o.token == token;
  int get hashCode => hashValues(email, plan, token);
}
