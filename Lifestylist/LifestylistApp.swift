//
//  LifestylistApp.swift
//  Lifestylist
//
//  Created by Jake Sanghavi on 2/12/25.
//

import SwiftUI
import FirebaseCore


#if os(iOS)
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}
#endif

@main
struct LifestylistApp: App {
    #if os(iOS)
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    #endif
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
