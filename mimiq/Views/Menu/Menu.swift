//
//  Menu.swift
//  mimiq
//
//  Created by Wendy Liga on 27/10/20.
//  Copyright © 2020 Wendy Liga. All rights reserved.
//

import Cocoa
import Foundation
import Tagged

struct Menu {
    typealias ID = Tagged<Self, String>
    
    let id: ID
    let title: String
    let isEnabled: Bool
    let keyEquivalent: String?
}

extension Menu {
    static var separator: Self {
        .init(id: "separator", title: "", isEnabled: false, keyEquivalent: nil)
    }
    
    static var availableSimulatorTitle: Self {
        .init(id: "", title: "Available Simulators", isEnabled: false, keyEquivalent: nil)
    }
    static var preferences: Self {
        .init(id: "preferences", title: "Preferences", isEnabled: true, keyEquivalent: ",")
    }
    
    static var checkForUpdate: Self {
        .init(id: "check-for-update", title: "Check for Update", isEnabled: true, keyEquivalent: nil)
    }
    
    static var quit: Self {
        .init(id: "quit", title: "Quit", isEnabled: true, keyEquivalent: "q")
    }
}

extension Menu {
    var nsMenuItem: NSMenuItem {
        // handle separator
        guard id != Menu.separator.id else {
            return NSMenuItem.separator()
        }
        
        // handle default menu
        let menu = NSMenuItem()
        menu.title = title
        menu.isEnabled = isEnabled
        menu.keyEquivalent = keyEquivalent ?? ""
        
        return menu
    }
}
