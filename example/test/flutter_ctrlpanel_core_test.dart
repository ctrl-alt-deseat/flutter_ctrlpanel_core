import 'dart:convert' show jsonEncode;

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ctrlpanel_core/ctrlpanel_core.dart';
import 'package:uuid/uuid.dart';

final uuid = Uuid();

const handle = '07CB-VKRXYJ-FK5N9N-4E77DV-X6SR';
const secretKey = '4A34-ZX3YSS-70WNEA-38MRJ0-0KVM';
const masterPassword = 'vain 3 coward huff rile';
const syncToken = '07CBVKRXYJFK5N9N4E77DVX6SR4A34ZX3YSS70WNEA38MRJ00KVM';

void main() {
  test('everything works', () async {
    int updatedCount = 0;
    final core = await CtrlpanelCore.asyncInit();
    core.onUpdate.listen((_) { updatedCount++; });

    final accountID = uuid.v4();
    final accountData = CtrlpanelAccount(handle: "Test", hostname: "example.com", password: "secret");

    expect(core.locked, true);
    expect(core.hasAccount, false);
    expect(updatedCount, 0);

    await core.login(handle: handle, secretKey: secretKey, masterPassword: masterPassword, saveDevice: false);
    await Future.delayed(new Duration(milliseconds: 10));

    expect(core.locked, false);
    expect(core.hasAccount, true);
    expect(updatedCount, 1);

    await core.createAccount(id: accountID, data: accountData);
    await Future.delayed(new Duration(milliseconds: 10));

    expect(core.locked, false);
    expect(core.hasAccount, true);
    expect(core.parsedEntries.accounts[accountID], accountData);
    expect(updatedCount, 2);

    await core.deleteAccount(id: accountID);
    await Future.delayed(new Duration(milliseconds: 10));

    expect(core.locked, false);
    expect(core.hasAccount, true);
    expect(core.parsedEntries.accounts[accountID], null);
    expect(updatedCount, 3);

    await core.lock();
    await Future.delayed(new Duration(milliseconds: 10));

    expect(core.locked, true);
    expect(core.hasAccount, true);
    expect(core.parsedEntries, null);
    expect(updatedCount, 4);

    await core.unlock(masterPassword: masterPassword);
    await Future.delayed(new Duration(milliseconds: 10));

    expect(core.locked, false);
    expect(core.hasAccount, true);
    expect(core.parsedEntries != null, true);
    expect(updatedCount, 5);
  });

  test('accounts for hostname', () async {
    final core = await CtrlpanelCore.asyncInit();

    final account0ID = uuid.v4();
    final account0Data = CtrlpanelAccount(handle: "A", hostname: "example.com", password: "x");

    final account1ID = uuid.v4();
    final account1Data = CtrlpanelAccount(handle: "C", hostname: "login.example.com", password: "x");

    final account2ID = uuid.v4();
    final account2Data = CtrlpanelAccount(handle: "B", hostname: "example.net", password: "x");

    await core.login(handle: handle, secretKey: secretKey, masterPassword: masterPassword, saveDevice: false);

    try {
      await core.createAccount(id: account0ID, data: account0Data);
      try {
        await core.createAccount(id: account1ID, data: account1Data);
        try {
          await core.createAccount(id: account2ID, data: account2Data);

          final list = await core.accountsForHostname("example.com");

          expect(list[0].id, account0ID);
          expect(list[0].score, 1.0);
          expect(list[0].account, account0Data);

          expect(list[1].id, account1ID);
          expect(list[1].score, 0.8);
          expect(list[1].account, account1Data);

          expect(list[2].id, account2ID);
          expect(list[2].score, 0.4);
          expect(list[2].account, account2Data);
        } finally {
          await core.deleteAccount(id: account2ID);
        }
      } finally {
        await core.deleteAccount(id: account1ID);
      }
    } finally {
      await core.deleteAccount(id: account0ID);
    }
  });

  test('payment information encodable', () async {
    final appleInfo =CtrlpanelApplePaymentInformation(transactionIdentifier: 'x');
    final stripeInfo =CtrlpanelStripePaymentInformation(email: 'x', plan: 'y', token: 'z');

    expect(jsonEncode(appleInfo), '{"type":"apple","transactionIdentifier":"x"}');
    expect(jsonEncode(stripeInfo), '{"type":"stripe","email":"x","plan":"y","token":"z"}');
  });

  test('inbox entries', () async {
    int updatedCount = 0;
    final core = await CtrlpanelCore.asyncInit();
    core.onUpdate.listen((_) { updatedCount++; });

    final inboxEntryID = uuid.v4();
    final inboxEntryData = CtrlpanelInboxEntry(hostname: "example.com", email: "linus@example.com");

    expect(core.locked, true);
    expect(core.hasAccount, false);
    expect(updatedCount, 0);

    await core.login(handle: handle, secretKey: secretKey, masterPassword: masterPassword, saveDevice: false);
    await Future.delayed(new Duration(milliseconds: 10));

    expect(core.locked, false);
    expect(core.hasAccount, true);
    expect(updatedCount, 1);

    await core.createInboxEntry(id: inboxEntryID, data: inboxEntryData);
    await Future.delayed(new Duration(milliseconds: 10));

    expect(core.parsedEntries.inbox[inboxEntryID], inboxEntryData);
    expect(updatedCount, 2);

    await core.deleteInboxEntry(id: inboxEntryID);
    await Future.delayed(new Duration(milliseconds: 10));

    expect(core.parsedEntries.inbox[inboxEntryID], null);
    expect(updatedCount, 3);
  });

  test('signup', () async {
    int updatedCount = 0;
    final core = await CtrlpanelCore.asyncInit();
    core.onUpdate.listen((_) { updatedCount++; });

    final handle = await core.randomHandle();
    final secretKey = await core.randomSecretKey();
    final masterPassword = await core.randomMasterPassword();

    expect(core.locked, true);
    expect(core.hasAccount, false);
    expect(updatedCount, 0);

    await core.signup(handle: handle, secretKey: secretKey, masterPassword: masterPassword, saveDevice: false);
    await Future.delayed(new Duration(milliseconds: 10));

    expect(core.locked, false);
    expect(core.hasAccount, true);
    expect(updatedCount, 1);

    await core.setPaymentInformation(CtrlpanelApplePaymentInformation(transactionIdentifier: "x"));
    await Future.delayed(new Duration(milliseconds: 10));

    expect(core.locked, false);
    expect(core.hasAccount, true);
    expect(updatedCount, 2);

    await core.deleteUser();
    await Future.delayed(new Duration(milliseconds: 10));

    expect(core.locked, true);
    expect(core.hasAccount, false);
    expect(updatedCount, 3);
  });
}
