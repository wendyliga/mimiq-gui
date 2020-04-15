//
//  AppDelegate.swift
//  mimiqHelper
//
//  Created by Wendy Liga on 15/04/20.
//  Copyright © 2020 Wendy Liga. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let mainAppIdentifier = "com.wendyliga.mimiq"
        
        // Ensure the app is not already running
        guard NSRunningApplication.runningApplications(withBundleIdentifier: mainAppIdentifier).isEmpty else {
            NSApp.terminate(nil)
            return
        }
        
        let path = Bundle.main.bundlePath as NSString
        var components = path.pathComponents
        components.removeLast()
        components.removeLast()
        components.removeLast()
        components.append("MacOS")
        components.append("mimiq")

        let newPath = NSString.path(withComponents: components)

        NSWorkspace.shared.launchApplication(newPath)
        NSApp.terminate(nil)

    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

