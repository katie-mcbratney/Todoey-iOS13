import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        do {
            _ = try Realm()
        }catch {
            print("Error initializing realm \(error)")
        }
        
        return true
    }
    
    // MARK: - Core Data stack
    
 
    
    // MARK: - Core Data Saving support




}
