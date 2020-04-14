//
//  PreferencesViewController.swift
//  mimiq
//
//  Created by Wendy Liga on 13/04/20.
//  Copyright © 2020 Wendy Liga. All rights reserved.
//

import Cocoa

final class PreferencesWindowController: NSWindowController {
    convenience init() {
        let windowWidth: CGFloat = 450
        let windowHeight: CGFloat = 320
        let x = NSScreen.main?.frame.size.width ?? (windowWidth / 2) - (windowWidth / 2)
        let y = NSScreen.main?.frame.size.height ?? (windowHeight / 2) - (windowHeight / 2)
        
        self.init(window: NSWindow(contentRect: NSRect(x: x, y: y, width: windowWidth, height: windowHeight), styleMask: [.titled, .closable], backing: .buffered, defer: false))
        window?.level = .floating
        
        NSApp.setActivationPolicy(.regular)

        self.contentViewController = PreferencesTabViewController()
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
    }
}

final class PreferencesTabViewController: NSTabViewController, NSWindowDelegate {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        tabStyle = .toolbar
        let generalItem = NSTabViewItem(viewController: GeneralViewController())
        let aboutItem = NSTabViewItem(viewController: AboutViewController())
        
        let isDarkMode = UserDefaults.standard.string(forKey: "AppleInterfaceStyle") == "Dark"
        let itemTintColor = isDarkMode ? NSColor.white : NSColor.black
        
        generalItem.image = NSImage(named: "weekend")?.tint(color: itemTintColor)
        aboutItem.image = NSImage(named: "love")?.tint(color: itemTintColor)
        
        addTabViewItem(generalItem)
        addTabViewItem(aboutItem)
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        view.window?.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func windowWillClose(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
    }
}
