//
//  MimiqStatusItem.swift
//  mimiq
//
//  Created by Wendy Liga on 13/04/20.
//  Copyright © 2020 Wendy Liga. All rights reserved.
//

import Cocoa
import Sparkle

final class MimiqMenu: NSMenu {
    enum SimulatorPlaceholderState {
        case empty
        case fetching
        case exist
    }
    
    enum RecordingState {
        case none
        case recording(title: String)
        case processing
    }
    
    // MARK: - Menu Item
    
    let currentRecordingTitleMenuItem: NSMenuItem = {
        let item = NSMenuItem()
        item.title = "Current Recording"
        item.isEnabled = false
        
        return item
    }()
    
    lazy var currentRecordingChildMenuItem: NSMenuItem = { [weak self] in
        let item = NSMenuItem()
        item.title = "iPhone 8 - Stop Recording"
        item.isHidden = true
        item.action = #selector(stopRecord)
        item.target = self
        item.keyEquivalent = "+"
        
        return item
    }()
    
    let simulatorTitleMenuItem: NSMenuItem = {
        let item = NSMenuItem()
        item.title = "Available Simulators"
        item.isEnabled = false
        
        return item
    }()
    
    let simulatorPlaceholderChildMenuItem: NSMenuItem = {
        let item = NSMenuItem()
        item.title = "None"
        item.isEnabled = false
        
        return item
    }()
    
    /**
     Simulator Menu Item
     */
    var simulatorChild: [NSMenuItem] {
        /// set child to enable or disabled based on `selectedSimulatorIndexToRecord`
        /// if no recording right now
        let currentSimulatorChildEnable = self.selectedSimulatorToRecord == nil
        
        return latestSimulator.enumerated().map{ (index, simulator) -> NSMenuItem in
            let needUDID = latestSimulator
                .compactMap { $0.name == simulator.name ? $0 : nil }
                .count > 1

            let item = NSMenuItem()
            item.title = simulator.name + (needUDID ? " | \(simulator.udid.uuidString)" : "")
            item.action = #selector(self.record)
            item.isEnabled = currentSimulatorChildEnable
            item.target = self
            item.keyEquivalent = String(index + 1)
            
            return item
        }
    }
    
    lazy var preferencesMenuItem: NSMenuItem = { [weak self] in
        let item = NSMenuItem()
        item.title = "Preferences"
        item.action = #selector(openPreferences)
        item.target = self
        item.keyEquivalent = ","
        
        return item
    }()
    
    lazy var checkForUpdateItem: NSMenuItem = { [weak self] in
        let item = NSMenuItem()
        item.title = "Check for Update"
        item.action = #selector(checkForUpdate)
        item.target = self
        
        return item
    }()
    
    lazy var exitMenuItem: NSMenuItem = { [weak self] in
        let item = NSMenuItem()
        item.title = "Quit"
        item.action = #selector(quitApp)
        item.target = self
        item.keyEquivalent = "q"
        
        return item
    }()
    
    lazy var topMenu = [currentRecordingTitleMenuItem,
                   currentRecordingChildMenuItem,
                   NSMenuItem.separator(),
                   simulatorTitleMenuItem,
                   simulatorPlaceholderChildMenuItem]
    
    lazy var bottomMenu = [NSMenuItem.separator(),
                           checkForUpdateItem,
                           preferencesMenuItem,
                           NSMenuItem.separator(),
                           exitMenuItem]
    
    /**
     All Menu Item
     */
    var menuChild: [NSMenuItem] {
        return topMenu + simulatorChild + bottomMenu
    }
    
    // MARK: - Values
    
    var selectedSimulatorToRecord: Simulator?
    
    var latestSimulator = [Simulator]()
    
    let defaultStatusItem: NSStatusItem!
    
    let mimiqRecordProcess = MimiqRecordProcess()
    
    // MARK: - Life Cycle
    
    init(statusItem: NSStatusItem) {
        defaultStatusItem = statusItem
        
        super.init(title: "Mimiq")
        
        delegate = self
        autoenablesItems = false
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
    
    @objc
    func record(_ sender: NSMenuItem) {
        guard
            let itemIndex = items.firstIndex(of: sender),
            let simulator = latestSimulator[safe: itemIndex - topMenu.count],
            selectedSimulatorToRecord == nil
        else { return }
        
        selectedSimulatorToRecord = simulator
        
        mimiqRecordProcess.startRecord(simulator.udid.uuidString)
        recordingState(.recording(title: sender.title))
    }
    
    @objc
    func stopRecord(_ sender: NSMenuItem) {
        mimiqRecordProcess.stopRecord(beforeSendInteruption: {
            recordingState(.processing)
        }) { [weak self] (terminationCode, ouput, errorOutput) in
            defer {
                self?.recordingState(.none)
            }
            
            guard let errorOutput = errorOutput, terminationCode == 1 else {
                let notification = NSUserNotification()
                notification.title = "Record Success"
                notification.informativeText = "Grab your Gif at"
                notification.soundName = NSUserNotificationDefaultSoundName
                NSUserNotificationCenter.default.deliver(notification)
                
                return
            }
            
            let alert = NSAlert()
            alert.messageText = "Failed to record, mimiq process fail with error"
            alert.informativeText = errorOutput
            alert.addButton(withTitle: "OK")
            alert.runModal()
        }
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
    
    func refreshLayout() {
        removeAllItems()
        menuChild.forEach(addItem)
    }
    
    private func simulatorPlaceholderState(_ state: SimulatorPlaceholderState) {
        switch state {
        case .exist:
            simulatorPlaceholderChildMenuItem.isHidden = true
        case .empty:
            simulatorPlaceholderChildMenuItem.isHidden = false
            simulatorPlaceholderChildMenuItem.title = "None"
        case .fetching:
            simulatorPlaceholderChildMenuItem.isHidden = false
            simulatorPlaceholderChildMenuItem.title = "Fetching..."
        }
    }
    
    private func recordingState(_ state: RecordingState) {
        switch state {
        case .none:
            currentRecordingChildMenuItem.isHidden = true
            selectedSimulatorToRecord = nil
            defaultStatusItem.button?.title = ""
        case let .recording(title):
            currentRecordingChildMenuItem.isHidden = false
            currentRecordingChildMenuItem.isEnabled = true
            currentRecordingChildMenuItem.title = "Stop Recording " + title
            defaultStatusItem.button?.title = " Recording \(title)"
        case .processing:
            currentRecordingChildMenuItem.isHidden = false
            currentRecordingChildMenuItem.isEnabled = false
            currentRecordingChildMenuItem.title = "Processing"
            defaultStatusItem.button?.title = "Processing"
        }
    }
    
    @objc
    func fetchSimulator() {
        // remove previous simulator
        latestSimulator.removeAll()
        
        // set fetching status
        simulatorPlaceholderState(.fetching)
        refreshLayout()
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            
            self.latestSimulator = MimiqProcess.shared.simulatorList()
            
            DispatchQueue.main.async { [weak self] in
                guard !(self?.simulatorChild ?? []).isEmpty else {
                    self?.simulatorPlaceholderState(.empty)
                    self?.refreshLayout()
                    return
                }
                
                self?.simulatorPlaceholderState(.exist)
                self?.refreshLayout()
            }
        }
    }
}

extension MimiqMenu: NSMenuDelegate {
    func menuWillOpen(_ menu: NSMenu) {
        fetchSimulator()
    }
}
