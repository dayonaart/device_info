import Flutter
import UIKit

public class SwiftDeviceInfoPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "device_info", binaryMessenger: registrar.messenger())
    let instance = SwiftDeviceInfoPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
   if(call.method == "getInformations"){
                    let modelName = UIDevice.modelName
                    let ipAddress = getPublicIPAddress()
                    let systemVersion = UIDevice.current.systemVersion
                    let uuid = UIDevice.current.identifierForVendor?.uuidString
                    let uuidRes = uuid!.replacingOccurrences(of: "-", with: "")
                    let deviceData = """
                    {
                        "device_type": "\(String(modelName))",
                        "ip_address": "\(ipAddress.description)",
                        "os_version":"\(systemVersion)",
                        "app_version_code":"\(Bundle.main.releaseVersionNumber ?? "release_version")",
                        "app_build_code":"\(Bundle.main.buildVersionNumber ?? "app_version_code")",
                        "uuid":"\(uuidRes.prefix(20))"
                    }
                    """
                    result(deviceData)
                }else if(call.method == "getPublicIp"){
                    let ipAddress = getPublicIPAddress()
                    result(ipAddress.description)
                }else if(call.method=="getUUID"){
                        let uuid = UIDevice.current.identifierForVendor?.uuidString
                    if(uuid != nil){
                        let uuidRes = uuid!.replacingOccurrences(of: "-", with: "")
                        result(uuidRes.prefix(20))
                    }else{
                        let rand=getRandomNumbers(maxNumber: 9, listSize: 7)
                        let timestamp="\(Date().millisecondsSince1970)"
                        result("\(timestamp)\(rand)")
                    }

                } else {
                    result(FlutterMethodNotImplemented)
                    return
                  }
  }

}
private func getPublicIPAddress()->String {
    var publicIP = ""
    do {
        try publicIP = String(contentsOf: URL(string: "https://www.bluewindsolution.com/tools/getpublicip.php")!, encoding: String.Encoding.utf8)
        publicIP = publicIP.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    catch {
      return  "Error: \(error)"

    }
  return publicIP
}
extension Bundle {
  var releaseVersionNumber: String? {
      return infoDictionary?["CFBundleShortVersionString"] as? String
  }
  var buildVersionNumber: String? {
      return infoDictionary?["CFBundleVersion"] as? String
  }
}

extension Date {
    var millisecondsSince1970: Int64 {
        Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}

func getRandomNumbers(maxNumber: Int, listSize: Int)-> String {
    var randomNumbers = Set<Int>()
    while randomNumbers.count < listSize {
        let randomNumber = Int(arc4random_uniform(UInt32(maxNumber+1)))
        randomNumbers.insert(randomNumber)
    }

    return randomNumbers.compactMap { Int in
        "\(Int)"
    }.joined(separator: "")
}
