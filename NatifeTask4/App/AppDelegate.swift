//
//  AppDelegate.swift
//  NatifeTask4
//
//  Created by Nazar on 01.04.2026.
//

import FirebaseCore
import UIKit

#if DEBUG
import DebugSwift
#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp
            .configure()
        
#if DEBUG
        let debugSwift = DebugSwift()
        debugSwift.setup()
        debugSwift.show()
#endif
        
        return true
    }
}
