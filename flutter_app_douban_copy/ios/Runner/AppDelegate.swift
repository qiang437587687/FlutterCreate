import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    var eventSink:FlutterEventSink?
    
    var comprehensiveFlutterViewController:FlutterViewController!
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController;
    let batteryChannel = FlutterMethodChannel.init(name: "samples.flutter.io/battery",
                                                   binaryMessenger: controller);
    
    batteryChannel.setMethodCallHandler({
        (call: FlutterMethodCall, result: FlutterResult) -> Void in
        if ("getBatteryLevel" == call.method) {
            receiveBatteryLevel(result: result);
            
        } else if ("jumpTest" == call.method) {
            jumpTest(result: result)
        }
        else {
            result(FlutterMethodNotImplemented);
        }
    });
    
    let eventChannel =  FlutterEventChannel.init(name: "samples.flutter.io/charging", binaryMessenger: controller);
    eventChannel.setStreamHandler(self);
    
    actionAfterSecond(sec: 5);
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

extension AppDelegate {
    
    func actionAfterSecond(sec:Int) {
        perform(#selector(action), with: nil, afterDelay: TimeInterval.init(sec));
    }
    
    @objc func action() {
        self.eventSink?("Second")
    }
}

func jumpTest(result: FlutterResult) {
    print("1");
    result(1);
}


private func receiveBatteryLevel(result: FlutterResult) {
    let device = UIDevice.current;
    device.isBatteryMonitoringEnabled = true;
    if (device.batteryState == UIDeviceBatteryState.unknown) {
        result(FlutterError.init(code: "UNAVAILABLE",
                                 message: "Battery info unavailable",
                                 details: nil));
    } else {
        result(Int(device.batteryLevel * 100));
    }
}

extension AppDelegate : FlutterStreamHandler {
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil;
        return nil;
    }
    
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events;
        
        return nil;
        
    }
    
}






