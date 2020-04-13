//
//  AppDelegate.swift
//  mimiq
//
//  Created by Wendy Liga on 12/04/20.
//  Copyright © 2020 Wendy Liga. All rights reserved.
//

import Cocoa
import SwiftKit

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarItem: NSStatusItem!
    lazy var menu = MimiqMenu(statusItem: statusBarItem)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let statusBar = NSStatusBar.system
        statusBarItem = statusBar.statusItem(withLength: NSStatusItem.variableLength)
        statusBarItem.button?.image = NSImage(named: "status_icon")
        statusBarItem.button?.imagePosition = .imageLeft
        statusBarItem.menu = menu
    }
}
