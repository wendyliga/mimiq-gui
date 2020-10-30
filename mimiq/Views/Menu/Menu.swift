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
    static var prefixRecordGifMenu: String {
        "record-gif-"
    }
    
    static var prefixRecordMovMenu: String {
        "record-mov-"
    }
    
    static var prefixRecordMp4Menu: String {
        "record-mp4-"
    }
    
    static func recordGIF(for simulatorId: Simulator.ID) -> Self {
        .init(
            id: MenuItem.ID(rawValue: prefixRecordGifMenu + String(simulatorId.rawValue.uuidString)),
            title: "Record GIF",
            isEnabled: true,
            keyEquivalent: "1",
            subMenuItems: []
        )
    }
    
    static func recordMov(for simulatorId: Simulator.ID) -> Self {
        .init(
            id: MenuItem.ID(rawValue: prefixRecordMovMenu + String(simulatorId.rawValue.uuidString)),
            title: "Record Mov",
            isEnabled: true,
            keyEquivalent: "2",
            subMenuItems: []
        )
    }
    
    static func recordMp4(for simulatorId: Simulator.ID) -> Self {
        .init(
            id: MenuItem.ID(rawValue: prefixRecordMp4Menu + String(simulatorId.rawValue.uuidString)),
            title: "Record Mp4",
            isEnabled: true,
            keyEquivalent: "3",
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
        menu.identifier = NSUserInterfaceItemIdentifier(id.rawValue)
        menu.title = title
        menu.isEnabled = isEnabled
        menu.keyEquivalent = keyEquivalent ?? ""
        
        return menu
    }
}
