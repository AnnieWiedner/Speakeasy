import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    let window = UIWindow(frame: UIScreen.main.bounds)
    window.backgroundColor = UIColor.black
    window.rootViewController = TutorialViewController() //CardsViewController()
    window.makeKeyAndVisible()
    self.window = window
    
    return true
  }
}


