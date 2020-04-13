//
//  PreferencesViewController.swift
//  mimiq
//
//  Created by Wendy Liga on 13/04/20.
//  Copyright © 2020 Wendy Liga. All rights reserved.
//

import Cocoa

final class PreferencesWindowController: NSWindowController, NSWindowDelegate {
    convenience init() {
        let windowWidth: CGFloat = 450
        let windowHeight: CGFloat = 320
        let x = NSScreen.main?.frame.size.width ?? (windowWidth / 2) - (windowWidth / 2)
        let y = NSScreen.main?.frame.size.height ?? (windowHeight / 2) - (windowHeight / 2)
        
        self.init(window: NSWindow(contentRect: NSRect(x: x, y: y, width: windowWidth, height: windowHeight), styleMask: [.titled, .closable], backing: .buffered, defer: false))
        window?.delegate = self
        window?.title = "Preferences"
        
        NSApp.setActivationPolicy(.regular)
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
    func windowWillClose(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
    }
}

final class PreferencesViewController: NSViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
