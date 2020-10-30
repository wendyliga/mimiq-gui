//
//  Menu.swift
//  mimiq
//
//  Created by Wendy Liga on 27/10/20.
//  Copyright © 2020 Wendy Liga. All rights reserved.
//

import Cocoa
import Foundation
import mimiq_core
import Tagged

/**
 Value type of NSMenuItem
 */
struct MenuItem: Identifiable {
    typealias ID = Tagged<Self, String>
    
    let id: ID
    var title: String
    var isEnabled: Bool
    var keyEquivalent: String?
    var subMenuItems: IdentifiedArrayOf<Self>
}

extension MenuItem {
    static var separator: Self {
        .init(id: "separator", title: "", isEnabled: false, keyEquivalent: nil, subMenuItems: [])
    }
  
    static var currentRecordingTitle: Self {
        .init(id: "current-recording-title", title: "Currently Recording", isEnabled: false, keyEquivalent: nil, subMenuItems: [])
    }
    
    static var emptyRecording: Self {
        .init(id: "empty-recording", title: "None", isEnabled: false, keyEquivalent: nil, subMenuItems: [])
    }
    
    static var availableSimulatorTitle: Self {
        .init(id: "available-simulator-title", title: "Available Simulators", isEnabled: false, keyEquivalent: nil, subMenuItems: [])
    }
    
    static var fetchingSimulatorStatus: Self {
        .init(id: "fetching-simulator-status", title: "Fetching...", isEnabled: false, keyEquivalent: nil, subMenuItems: [])
    }
    
    static var emptySimulator: Self {
        .init(id: "empty-simulator", title: "None", isEnabled: false, keyEquivalent: nil, subMenuItems: [])
    }
    
    static var preferences: Self {
        .init(id: "preferences", title: "Preferences", isEnabled: true, keyEquivalent: ",", subMenuItems: [])
    }
    
    static var checkForUpdate: Self {
        .init(id: "check-for-update", title: "Check for Update", isEnabled: true, keyEquivalent: nil, subMenuItems: [])
    }
    
    static var quit: Self {
        .init(id: "quit", title: "Quit", isEnabled: true, keyEquivalent: "q", subMenuItems: [])
    }
}

extension MenuItem {
    static var recordGIFMenuPrefix: String {
        "record-gif-"
    }
    static func recordGIF(for simulatorId: Simulator.ID) -> Self {
        .init(
            id: MenuItem.ID(rawValue: recordGIFMenuPrefix + String(simulatorId.rawValue.uuidString)),
            title: "Record GIF",
            isEnabled: true,
            keyEquivalent: "g",
            subMenuItems: []
        )
    }
}

extension MenuItem {
    var nsMenuItem: NSMenuItem {
        // handle separator
        guard id != MenuItem.separator.id else {
            return NSMenuItem.separator()
        }
        
        // handle default menu
        let menu = NSMenuItem()
        menu.title = title
        menu.isEnabled = isEnabled
        menu.keyEquivalent = keyEquivalent ?? ""
        menu.submenu = { () -> NSMenu? in
            var subMenu: NSMenu? = nil
            
            if !subMenuItems.isEmpty {
                subMenu = NSMenu()
                
                subMenuItems.forEach { menuItem in
                    subMenu?.addItem(menuItem.nsMenuItem)
                }
            }
            
            return subMenu
        }()
        
        return menu
    }
}
