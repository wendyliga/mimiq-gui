//
//  AppDelegate.swift
//  mimiq
//
//  Created by Wendy Liga on 12/04/20.
//  Copyright © 2020 Wendy Liga. All rights reserved.
//

import Cocoa
import Sparkle
import SwiftKit
import ServiceManagement

extension Notification.Name {
    static let killLauncher = Notification.Name("kill_launcher")
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarItem: NSStatusItem!
    
    lazy var applicationName: String = {
        guard let bundleName = Bundle.main.object(forInfoDictionaryKey:"CFBundleName"), let bundleNameAsString = bundleName as? String else {
            return "Apple"
        }
        
        return bundleNameAsString
    }()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let statusBar = NSStatusBar.system
        statusBarItem = statusBar.statusItem(withLength: NSStatusItem.variableLength)
        statusBarItem.button?.image = NSImage(named: "status_icon")
        statusBarItem.button?.imagePosition = .imageLeft
        statusBarItem.menu = MimiqMenu(statusItem: statusBarItem)
        
        NSApp.setActivationPolicy(.accessory)
        populateMainMenu()
        
        if UserDefaults.standard.bool(forKey: UserDefaultsKey.didSetupDefaultValue.rawValue) == false {
            // set default value
            UserDefaults.standard.set(true, forKey: UserDefaultsKey.startOnLogin.rawValue)
            UserDefaults.standard.set(true, forKey: UserDefaultsKey.didSetupDefaultValue.rawValue)
            
            let updater = SUUpdater()
            updater.automaticallyChecksForUpdates = false
            updater.automaticallyDownloadsUpdates = false
        }
        
        // sync check for update value from `SUUpdater`
        UserDefaults.standard.set(SUUpdater().automaticallyChecksForUpdates, forKey: UserDefaultsKey.automaticCheckForUpdate.rawValue)
        
        if UserDefaults.standard.bool(forKey: UserDefaultsKey.startOnLogin.rawValue) {
            // set auto launch on login
            SMLoginItemSetEnabled("com.wendyliga.mimiqHelper" as CFString, true)
        }
        
        #warning("add notification when generate gif success")
    }
    
    func populateMainMenu() {
        let mainMenu = NSMenu(title: "MainMenu")
        
        // The titles of the menu items are for identification purposes only and shouldn't be localized.
        // The strings in the menu bar come from the submenu titles,
        // except for the application menu, whose title is ignored at runtime.
        var menuItem = mainMenu.addItem(withTitle: "Application", action: nil, keyEquivalent: "")
        var submenu = NSMenu(title: "Application")
        populateApplicationMenu(submenu)
        mainMenu.setSubmenu(submenu, for: menuItem)

        menuItem = mainMenu.addItem(withTitle: "File", action: nil, keyEquivalent: "")
        submenu = NSMenu(title: NSLocalizedString("File", comment: "File menu"))
        populateFileMenu(submenu)
        mainMenu.setSubmenu(submenu, for: menuItem)
        
        // NSApplication will make a copy of your menu,
        // so if you need to access the mainMenu after this point,
        // your current menu reference won't work anymore,
        // and you need to get a new reference from NSApp.mainMenu
        NSApp.mainMenu = mainMenu
    }
    
    func populateApplicationMenu(_ menu:NSMenu) {
        var title = NSLocalizedString("About", comment: "About menu item") + " " + applicationName
        var menuItem = menu.addItem(withTitle:title, action:#selector(NSApplication.orderFrontStandardAboutPanel(_:)), keyEquivalent:"")
        menuItem.target = NSApp
        
        menu.addItem(NSMenuItem.separator())
        
        title = NSLocalizedString("Hide", comment: "Hide menu item") + " " + applicationName
        menuItem = menu.addItem(withTitle:title, action:#selector(NSApplication.hide(_:)), keyEquivalent:"h")
        menuItem.target = NSApp
        
        title = NSLocalizedString("Hide Others", comment:"Hide Others menu item")
        menuItem = menu.addItem(withTitle:title, action:#selector(NSApplication.hideOtherApplications(_:)), keyEquivalent:"h")
        menuItem.keyEquivalentModifierMask = [.command, .option]
        menuItem.target = NSApp
        
        title = NSLocalizedString("Show All", comment:"Show All menu item")
        menuItem = menu.addItem(withTitle:title, action:#selector(NSApplication.unhideAllApplications(_:)), keyEquivalent:"")
        menuItem.target = NSApp
        
        menu.addItem(NSMenuItem.separator())
        
        title = NSLocalizedString("Quit", comment:"Quit menu item") + " " + applicationName
        menuItem = menu.addItem(withTitle:title, action:#selector(NSApplication.terminate(_:)), keyEquivalent:"q")
        menuItem.target = NSApp
    }

    func populateFileMenu(_ menu: NSMenu) {
        let title = NSLocalizedString("Close Window", comment: "Close Window menu item")
        menu.addItem(withTitle:title, action:#selector(NSWindow.performClose(_:)), keyEquivalent:"w")
    }
}
