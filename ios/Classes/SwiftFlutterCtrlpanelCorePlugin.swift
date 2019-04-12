import CtrlpanelCore
import Flutter
import Foundation
import JSBridge
import PromiseKit

func flutterState(_ id: String, _ core: CtrlpanelCore) -> [String: AnyObject?] {
    return [
        "_id": id as AnyObject?,
        "handle": core.handle as AnyObject?,
        "secretKey": core.secretKey as AnyObject?,
        "syncToken": core.syncToken as AnyObject?,
        "hasAccount": core.hasAccount as AnyObject?,
        "locked": core.locked as AnyObject?,
        "parsedEntries": core.parsedEntries?.toDictionary() as AnyObject?,
    ]
}

extension Promise {
    func flutter(_ result: @escaping FlutterResult) {
        self.done {
            result($0)
        }.catch {
            if let err = $0 as? JSError {
                result(FlutterError(code: err.code ?? "EUNKNOWN", message: err.message, details: nil))
            } else {
                result(FlutterError(code: "EUNKNOWN", message: $0.localizedDescription, details: nil))
            }
        }
    }
}

public class SwiftFlutterCtrlpanelCorePlugin: NSObject, FlutterPlugin {
    static var cores = Dictionary<String, CtrlpanelCore>()

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_ctrlpanel_core", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterCtrlpanelCorePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
            case "init":
                let id = UUID().uuidString
                let apiHost = ((call.arguments as! Dictionary<String, AnyObject>)["apiHost"] as? String).map { URL(string: $0)! }
                let deseatmeApiHost = ((call.arguments as! Dictionary<String, AnyObject>)["deseatmeApiHost"] as? String).map { URL(string: $0)! }
                let syncToken = (call.arguments as! Dictionary<String, AnyObject>)["syncToken"] as? String

                firstly {
                    CtrlpanelCore.asyncInit(apiHost: apiHost, deseatmeApiHost: deseatmeApiHost, syncToken: syncToken)
                }.done {
                    SwiftFlutterCtrlpanelCorePlugin.cores[id] = $0
                    result(flutterState(id, $0))
                }.catch {
                    result(FlutterError(code: "EUNKNOWN", message: $0.localizedDescription, details: nil))
                }
            case "randomAccountPassword":
                let _id = (call.arguments as! Dictionary<String, AnyObject>)["_id"] as! String
                let core = SwiftFlutterCtrlpanelCorePlugin.cores[_id]!
                core.randomAccountPassword().flutter(result)
            case "randomHandle":
                let _id = (call.arguments as! Dictionary<String, AnyObject>)["_id"] as! String
                let core = SwiftFlutterCtrlpanelCorePlugin.cores[_id]!
                core.randomHandle().flutter(result)
            case "randomMasterPassword":
                let _id = (call.arguments as! Dictionary<String, AnyObject>)["_id"] as! String
                let core = SwiftFlutterCtrlpanelCorePlugin.cores[_id]!
                core.randomMasterPassword().flutter(result)
            case "randomSecretKey":
                let _id = (call.arguments as! Dictionary<String, AnyObject>)["_id"] as! String
                let core = SwiftFlutterCtrlpanelCorePlugin.cores[_id]!
                core.randomSecretKey().flutter(result)
            case "lock":
                let _id = (call.arguments as! Dictionary<String, AnyObject>)["_id"] as! String
                let core = SwiftFlutterCtrlpanelCorePlugin.cores[_id]!
                core.lock().map({ _ in flutterState(_id, core) }).flutter(result)
            case "reset":
                let _id = (call.arguments as! Dictionary<String, AnyObject>)["_id"] as! String
                let syncToken = (call.arguments as! Dictionary<String, AnyObject>)["syncToken"] as! String
                let core = SwiftFlutterCtrlpanelCorePlugin.cores[_id]!
                core.reset(withSyncToken: syncToken).map({ _ in flutterState(_id, core) }).flutter(result)
            case "signup":
                let _id = (call.arguments as! Dictionary<String, AnyObject>)["_id"] as! String
                let handle = (call.arguments as! Dictionary<String, AnyObject>)["handle"] as! String
                let secretKey = (call.arguments as! Dictionary<String, AnyObject>)["secretKey"] as! String
                let masterPassword = (call.arguments as! Dictionary<String, AnyObject>)["masterPassword"] as! String
                let saveDevice = (call.arguments as! Dictionary<String, AnyObject>)["saveDevice"] as! Bool
                let core = SwiftFlutterCtrlpanelCorePlugin.cores[_id]!
                core.signup(handle: handle, secretKey: secretKey, masterPassword: masterPassword, saveDevice: saveDevice).map({ _ in flutterState(_id, core) }).flutter(result)
            case "login":
                let _id = (call.arguments as! Dictionary<String, AnyObject>)["_id"] as! String
                let handle = (call.arguments as! Dictionary<String, AnyObject>)["handle"] as! String
                let secretKey = (call.arguments as! Dictionary<String, AnyObject>)["secretKey"] as! String
                let masterPassword = (call.arguments as! Dictionary<String, AnyObject>)["masterPassword"] as! String
                let saveDevice = (call.arguments as! Dictionary<String, AnyObject>)["saveDevice"] as! Bool
                let core = SwiftFlutterCtrlpanelCorePlugin.cores[_id]!
                core.login(handle: handle, secretKey: secretKey, masterPassword: masterPassword, saveDevice: saveDevice).map({ _ in flutterState(_id, core) }).flutter(result)
            case "unlock":
                let _id = (call.arguments as! Dictionary<String, AnyObject>)["_id"] as! String
                let masterPassword = (call.arguments as! Dictionary<String, AnyObject>)["masterPassword"] as! String
                let core = SwiftFlutterCtrlpanelCorePlugin.cores[_id]!
                core.unlock(masterPassword: masterPassword).map({ _ in flutterState(_id, core) }).flutter(result)
            case "connect":
                let _id = (call.arguments as! Dictionary<String, AnyObject>)["_id"] as! String
                let core = SwiftFlutterCtrlpanelCorePlugin.cores[_id]!
                core.connect().map({ _ in flutterState(_id, core) }).flutter(result)
            case "sync":
                let _id = (call.arguments as! Dictionary<String, AnyObject>)["_id"] as! String
                let core = SwiftFlutterCtrlpanelCorePlugin.cores[_id]!
                core.sync().map({ _ in flutterState(_id, core) }).flutter(result)
            case "setPaymentInformation":
                let _id = (call.arguments as! Dictionary<String, AnyObject>)["_id"] as! String
                let paymentInformation = (call.arguments as! Dictionary<String, AnyObject>)["paymentInformation"] as! [String: AnyObject?]
                let core = SwiftFlutterCtrlpanelCorePlugin.cores[_id]!
                core.setPaymentInformation(CtrlpanelPaymentInformation.fromDictionary(paymentInformation)).map({ _ in flutterState(_id, core) }).flutter(result)
            case "accountsForHostname":
                let _id = (call.arguments as! Dictionary<String, AnyObject>)["_id"] as! String
                let hostname = (call.arguments as! Dictionary<String, AnyObject>)["hostname"] as! String
                let core = SwiftFlutterCtrlpanelCorePlugin.cores[_id]!
                core.accountsForHostname(hostname).map({ $0.map({ $0.toDictionary() }) }).flutter(result)
            case "createAccount":
                let _id = (call.arguments as! Dictionary<String, AnyObject>)["_id"] as! String
                let id = (call.arguments as! Dictionary<String, AnyObject>)["id"] as! String
                let data = (call.arguments as! Dictionary<String, AnyObject>)["data"] as! [String: AnyObject?]
                let core = SwiftFlutterCtrlpanelCorePlugin.cores[_id]!
                core.createAccount(id: UUID(uuidString: id)!, data: CtrlpanelAccount.fromDictionary(data)).map({ _ in flutterState(_id, core) }).flutter(result)
            case "deleteAccount":
                let _id = (call.arguments as! Dictionary<String, AnyObject>)["_id"] as! String
                let id = (call.arguments as! Dictionary<String, AnyObject>)["id"] as! String
                let core = SwiftFlutterCtrlpanelCorePlugin.cores[_id]!
                core.deleteAccount(id: UUID(uuidString: id)!).map({ _ in flutterState(_id, core) }).flutter(result)
            case "updateAccount":
                let _id = (call.arguments as! Dictionary<String, AnyObject>)["_id"] as! String
                let id = (call.arguments as! Dictionary<String, AnyObject>)["id"] as! String
                let data = (call.arguments as! Dictionary<String, AnyObject>)["data"] as! [String: AnyObject?]
                let core = SwiftFlutterCtrlpanelCorePlugin.cores[_id]!
                core.updateAccount(id: UUID(uuidString: id)!, data: CtrlpanelAccount.fromDictionary(data)).map({ _ in flutterState(_id, core) }).flutter(result)
            case "createInboxEntry":
                let _id = (call.arguments as! Dictionary<String, AnyObject>)["_id"] as! String
                let id = (call.arguments as! Dictionary<String, AnyObject>)["id"] as! String
                let data = (call.arguments as! Dictionary<String, AnyObject>)["data"] as! [String: AnyObject?]
                let core = SwiftFlutterCtrlpanelCorePlugin.cores[_id]!
                core.createInboxEntry(id: UUID(uuidString: id)!, data: CtrlpanelInboxEntry.fromDictionary(data)).map({ _ in flutterState(_id, core) }).flutter(result)
            case "deleteInboxEntry":
                let _id = (call.arguments as! Dictionary<String, AnyObject>)["_id"] as! String
                let id = (call.arguments as! Dictionary<String, AnyObject>)["id"] as! String
                let core = SwiftFlutterCtrlpanelCorePlugin.cores[_id]!
                core.deleteInboxEntry(id: UUID(uuidString: id)!).map({ _ in flutterState(_id, core) }).flutter(result)
            case "importFromDeseatme":
                let _id = (call.arguments as! Dictionary<String, AnyObject>)["_id"] as! String
                let exportToken = (call.arguments as! Dictionary<String, AnyObject>)["exportToken"] as! String
                let core = SwiftFlutterCtrlpanelCorePlugin.cores[_id]!
                core.importFromDeseatme(exportToken: exportToken).map({ _ in flutterState(_id, core) }).flutter(result)
            case "clearStoredData":
                let _id = (call.arguments as! Dictionary<String, AnyObject>)["_id"] as! String
                let core = SwiftFlutterCtrlpanelCorePlugin.cores[_id]!
                core.clearStoredData().map({ _ in flutterState(_id, core) }).flutter(result)
            case "deleteUser":
                let _id = (call.arguments as! Dictionary<String, AnyObject>)["_id"] as! String
                let core = SwiftFlutterCtrlpanelCorePlugin.cores[_id]!
                core.deleteUser().map({ _ in flutterState(_id, core) }).flutter(result)
            default:
                result(FlutterMethodNotImplemented)
        }
    }
}
