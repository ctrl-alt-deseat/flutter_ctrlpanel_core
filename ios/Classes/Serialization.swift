import CtrlpanelCore
import Foundation

extension CtrlpanelAccount {
    func toDictionary() -> [String: AnyObject?] {
        return [
            "handle": self.handle as AnyObject?,
            "hostname": self.hostname as AnyObject?,
            "password": self.password as AnyObject?,
            "otpauth": self.otpauth as AnyObject?,
        ]
    }

    static func fromDictionary(_ dict: [String: AnyObject?]) -> CtrlpanelAccount {
        return CtrlpanelAccount(
            handle: dict["handle"] as! String,
            hostname: dict["hostname"] as! String,
            password: dict["password"] as! String,
            otpauth: (dict["otpauth"] as? String).map { URL(string: $0)! }
        )
    }
}

extension CtrlpanelInboxEntry {
    func toDictionary() -> [String: AnyObject?] {
        return [
            "hostname": self.hostname as AnyObject?,
            "email": self.email as AnyObject?,
        ]
    }

    static func fromDictionary(_ dict: [String: AnyObject?]) -> CtrlpanelInboxEntry {
        return CtrlpanelInboxEntry(
            hostname: dict["hostname"] as! String,
            email: dict["email"] as! String
        )
    }
}

extension CtrlpanelParsedEntries {
    func toDictionary() -> [String: AnyObject?] {
        return [
            "accounts": Dictionary(uniqueKeysWithValues: accounts.map { ($0.0.uuidString.lowercased(), $0.1.toDictionary()) }) as AnyObject?,
            "inbox": Dictionary(uniqueKeysWithValues: inbox.map { ($0.0.uuidString.lowercased(), $0.1.toDictionary()) }) as AnyObject?,
        ]
    }
}

extension CtrlpanelAccountMatch {
    func toDictionary() -> [String: AnyObject?] {
        return [
            "id": self.id.uuidString.lowercased() as AnyObject?,
            "score": self.score as AnyObject?,
            "handle": self.account.handle as AnyObject?,
            "hostname": self.account.hostname as AnyObject?,
            "password": self.account.password as AnyObject?,
            "otpauth": self.account.otpauth as AnyObject?,
        ]
    }
}

extension CtrlpanelPaymentInformation {
    static func fromDictionary(_ dict: [String: AnyObject?]) -> CtrlpanelPaymentInformation {
        switch (dict["type"] as! String) {
            case "apple": return .apple(transactionIdentifier: dict["transactionIdentifier"] as! String)
            case "stripe": return .stripe(email: dict["email"] as! String, plan: dict["plan"] as! String, token: dict["token"] as! String)
            default: fatalError("Unknown CtrlpanelPaymentInformation type: \(dict["type"] as! String)")
        }
    }
}
