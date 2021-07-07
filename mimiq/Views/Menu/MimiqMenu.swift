//
//  MimiqStatusItem.swift
//  mimiq
//
//  Created by Wendy Liga on 13/04/20.
//  Copyright © 2020 Wendy Liga. All rights reserved.
//

import Cocoa
import mimiq_core
import Sparkle

final class MimiqMenu: NSMenu {
    private var viewModel: MimiqMenuViewModel
    
    /**
     Simulator Menu Item
     */
//    var simulatorChild: [NSMenuItem] {
//        /// set child to enable or disabled based on `selectedSimulatorIndexToRecord`
//        /// if no recording right now
//        let currentSimulatorChildEnable = self.selectedSimulatorToRecord == nil
//
//        return latestSimulator.enumerated().map{ (index, simulator) -> NSMenuItem in
//            let needUDID = latestSimulator
//                .compactMap { $0.name == simulator.name ? $0 : nil }
//                .count > 1
//
//            let item = NSMenuItem()
//            item.title = simulator.name + (needUDID ? " | \(simulator.udid.uuidString)" : "")
//            item.action = #selector(self.record)
//            item.isEnabled = currentSimulatorChildEnable
//            item.target = self
//            item.keyEquivalent = String(index + 1)
//
//            return item
//        }
//    }
    
    // MARK: - Values
    
    let defaultStatusItem: NSStatusItem!
    
    // MARK: - Life Cycle
    
    init(statusItem: NSStatusItem) {
        defaultStatusItem = statusItem
        viewModel = DefaultMimiqMenuViewModel(environment: .init())
        
        super.init(title: "Mimiq")
        
        delegate = self
        autoenablesItems = false
        
        bindViewModel()
        viewModel.load()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
    
    /**
     Bind view model to UI
     */
    private func bindViewModel() {
        viewModel.menus = { [unowned self] menus in
            // TODO: apply diffing for neccessary update only
            // remove previous menu
            removeAllItems()
            
            menus.forEach { menu in
                self.addItem(nsMenuItemWithSelectorFor(menu))
            }
        }
    }
    
    /**
     Generate `NSMenuItem` from value type `MenuItem`.
     This function will also set the respective `#selector`
     
     - Parameter menuItem: `MenuItem`
     - Returns: generated `NSMenuItem` with alocated `#selector`
     */
    private func nsMenuItemWithSelectorFor(_ menuItem: MenuItem) -> NSMenuItem {
        let nsMenuItem = menuItem.nsMenuItem
        nsMenuItem.target = self
        nsMenuItem.action = self.selectorFor(menuItem.id)
        nsMenuItem.submenu = { () -> NSMenu? in
            var subMenu: NSMenu? = nil
            
            if !menuItem.subMenuItems.isEmpty {
                subMenu = NSMenu()
                
                menuItem.subMenuItems.forEach { menuItem in
                    // recursive set subitem nsmenu with selector
                    let nsMenuItem = self.nsMenuItemWithSelectorFor(menuItem)
                    subMenu?.addItem(nsMenuItem)
                }
            }
            
            return subMenu
        }()
        
        return nsMenuItem
    }
    
    /**
     Get appropriate `#selector` for `MenuItem`
     
     - Parameter menuId: `MenuItem` `ID`
     - Returns: a selector for MenuItem
     */
    private func selectorFor(_ menuId: MenuItem.ID) -> Selector? {
        // handle record gif menu id,
        // because the menu id contains simulator UUID, so can pass uuid simulator to selector, only check if menu id contains prefix menu
        if menuId.rawValue.contains(MenuItem.prefixRecordGifMenu) {
            return #selector(recordGIF)
        }
        
        if menuId.rawValue.contains(MenuItem.prefixRecordMovMenu) {
            return #selector(recordMov)
        }
        
        if menuId.rawValue.contains(MenuItem.prefixRecordMp4Menu) {
            return #selector(recordMp4)
        }
        
        switch menuId {
        case MenuItem.preferences.id:
            return #selector(openPreferences)
        case MenuItem.checkForUpdate.id:
            return #selector(checkForUpdate)
        case MenuItem.quit.id:
            return #selector(quitApp)
        default:
            return nil
        }
    }
    
//    @objc
//    func record(_ sender: NSMenuItem) {
//        guard
//            let itemIndex = items.firstIndex(of: sender),
//            let simulator = latestSimulator[safe: itemIndex - topMenu.count],
//            selectedSimulatorToRecord == nil
//        else { return }
//
//        selectedSimulatorToRecord = simulator
//
//        mimiqRecordProcess.startRecord(simulator.udid.uuidString)
//        recordingState(.recording(title: sender.title))
//    }
//
//    @objc
//    func stopRecord(_ sender: NSMenuItem) {
//        mimiqRecordProcess.stopRecord(beforeSendInteruption: {
//            recordingState(.processing)
//        }) { [weak self] (terminationCode, ouput, errorOutput) in
//            defer {
//                self?.recordingState(.none)
//            }
//
//            guard let errorOutput = errorOutput, terminationCode == 1 else {
//                let notification = NSUserNotification()
//                notification.title = "Record Success"
//                notification.informativeText = "Grab your Gif at \(UserDefaults.standard.string(forKey: "generate_gif_path") ?? "\(NSHomeDirectory())/Desktop")"
//                notification.soundName = NSUserNotificationDefaultSoundName
//                NSUserNotificationCenter.default.deliver(notification)
//
//                return
//            }
//
//            let alert = NSAlert()
//            alert.messageText = "Failed to record, mimiq process fail with error"
//            alert.informativeText = errorOutput
//            alert.addButton(withTitle: "OK")
//            alert.runModal()
//        }
//    }
//
    
    /**
     Extract Simulator UUID from NSMenuItem identifier, set only on record menu item
     
     - Parameter menuItem: `NSMenuItem` from sender `#selector`
     - Returns: Optional Simulator ID
     */
    private func getSimulatorIdFrom(_ menuItem: NSMenuItem?) -> Simulator.ID? {
        var menuId = menuItem?.identifier?.rawValue
        menuId?.removeFirst(MenuItem.prefixRecordGifMenu.count)
        
        guard let uuid = UUID(uuidString: menuId ?? "") else { return nil }
        return Simulator.ID(rawValue: uuid)
    }
    
    @objc
    private func recordGIF(_ sender: NSMenuItem?) {
        guard let simulatorId = getSimulatorIdFrom(sender) else { return }
        viewModel.record(.gif, simulatorId: simulatorId)
    }
    
    @objc
    func recordMov(_ sender: NSMenuItem?) {
        guard let simulatorId = getSimulatorIdFrom(sender) else { return }
        viewModel.record(.mov, simulatorId: simulatorId)
    }
    
    @objc
    func recordMp4(_ sender: NSMenuItem?) {
        guard let simulatorId = getSimulatorIdFrom(sender) else { return }
        viewModel.record(.mp4, simulatorId: simulatorId)
    }
    
    @objc
    func openPreferences() {
        let window = PreferencesWindowController()
        window.showWindow(NSApp)
    }

    @objc
    func checkForUpdate() {
        let updater = SUUpdater()
        updater.checkForUpdates(self)
    }

    @objc
    func quitApp() {
        NSApp.terminate(self)
    }
}

extension MimiqMenu: NSMenuDelegate {
    func menuWillOpen(_ menu: NSMenu) {
        viewModel.menuWillOpen()
    }
}
