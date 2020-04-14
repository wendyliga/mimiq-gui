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
        window?.level = .floating
        
        NSApp.setActivationPolicy(.regular)

        self.contentViewController = PreferencesTabViewController()
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
    func windowWillClose(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
    }
}

final class PreferencesTabViewController: NSTabViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        tabStyle = .toolbar
        let generalItem = NSTabViewItem(viewController: GeneralViewController())
        let aboutItem = NSTabViewItem(viewController: AboutViewController())
        aboutItem.image = NSImage(named: "AppIcon")
        
        addTabViewItem(generalItem)
        addTabViewItem(aboutItem)
        
        selectedTabViewItemIndex = 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    private lazy var tabViewSizes: [NSTabViewItem: NSSize] = [:]
//
//    override func tabView(_ tabView: NSTabView, didSelect tabViewItem: NSTabViewItem?) {
//        super.tabView(tabView, didSelect: tabViewItem)
//
//        if let tabViewItem = tabViewItem {
//            view.window?.title = tabViewItem.label
//            resizeWindowToFit(tabViewItem: tabViewItem)
//        }
//    }
//
//    override func tabView(_ tabView: NSTabView, willSelect tabViewItem: NSTabViewItem?) {
//        super.tabView(tabView, willSelect: tabViewItem)
//
//        // Cache the size of the tab view.
//        if let tabViewItem = tabViewItem, let size = tabViewItem.view?.frame.size {
//            tabViewSizes[tabViewItem] = size
//        }
//    }
//
//    /// Resizes the window so that it fits the content of the tab.
//    private func resizeWindowToFit(tabViewItem: NSTabViewItem) {
//        guard let size = tabViewSizes[tabViewItem], let window = view.window else {
//            return
//        }
//
//        let contentRect = NSRect(x: 0, y: 0, width: size.width, height: size.height)
//        let contentFrame = window.frameRect(forContentRect: contentRect)
//        let toolbarHeight = window.frame.size.height - contentFrame.size.height
//        let newOrigin = NSPoint(x: window.frame.origin.x, y: window.frame.origin.y + toolbarHeight)
//        let newFrame = NSRect(origin: newOrigin, size: contentFrame.size)
//        window.setFrame(newFrame, display: false, animate: true)
//    }
}
