//
//  Simulator+Extension.swift
//  mimiq
//
//  Created by Wendy Liga on 30/10/20.
//  Copyright © 2020 Wendy Liga. All rights reserved.
//

import Cocoa
import mimiq_core
import Tagged

extension Simulator {
    typealias ID = Tagged<Self, UUID>
    
    /**
     Strong type for Simulator ID
     */
    var id: ID {
        ID(rawValue: udid)
    }
    
    /**
     Simulator id with prefix, for menu purpose
     */
    var menuItemId: MenuItem.ID {
        MenuItem.ID(rawValue: ("simulator-" + udid.uuidString))
    }
    
    func menuItem(needUDID: Bool) -> MenuItem {
//        let needUDID = latestSimulator
//            .compactMap { $0.name == simulator.name ? $0 : nil }
//            .count > 1

//        let item = NSMenuItem()
//        item.title = name + (needUDID ? " | \(udid.uuidString)" : "")
//        item.isEnabled = true
//
//        return item
        
        return MenuItem(
            id: menuItemId,
            title: name + (needUDID ? " | \(udid.uuidString)" : ""),
            isEnabled: true,
            keyEquivalent: nil,
            subMenuItems: []
        )
    }
}
