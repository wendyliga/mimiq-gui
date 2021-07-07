//
//  MimiqMenu+ViewModel.swift
//  mimiq
//
//  Created by Wendy Liga on 26/10/20.
//  Copyright © 2020 Wendy Liga. All rights reserved.
//

import Cocoa
import mimiq_core

enum RecordType: String {
    case gif
    case mov
    case mp4
}

protocol MimiqMenuViewModelInput {
    func load()
    func menuWillOpen()
    func record(_ type: RecordType, simulatorId: Simulator.ID)
    func stopRecording()
}

protocol MimiqMenuViewModelOutput {
    var menus: (IdentifiedArrayOf<MenuItem>) -> Void { get set }
}

typealias MimiqMenuViewModel = MimiqMenuViewModelInput & MimiqMenuViewModelOutput

final class DefaultMimiqMenuViewModel: MimiqMenuViewModel {
    // MARK: - Values
    
    private let environment: MimiqMenuEnvironment
    private var currentMenus: IdentifiedArrayOf<MenuItem> = []
    
    // MARK: - Output
    
    var menus: (_ menus: IdentifiedArrayOf<MenuItem>) -> Void = { _ in}
    
    init(environment: MimiqMenuEnvironment) {
        self.environment = environment
    }
    
    // MARK: - Input
    
    func load() {
        refreshMenu()
    }
    
    func menuWillOpen() {
        refreshMenu()
    }
    
    func record(_ type: RecordType, simulatorId: Simulator.ID) {
        environment.recording(type, simulatorId)
    }
    
    func stopRecording() {
        environment.stopRecording()
    }
    
    private func refreshMenu() {
        func updateMenu() {
            menus(currentMenus)
        }
        
        fetch_initial_menu: do {
            currentMenus = [
                .currentRecordingTitle,
                .emptyRecording,
                .separator,
                .availableSimulatorTitle,
                .separator,
                .checkForUpdate,
                .preferences,
                .separator,
                .quit
            ]
            
            // set initial menu, while fetching list simulator
            updateMenu()
        }
        
        fetch_simulators_menu: do {
            func addFetchingStatus() {
                // remove none status if available
                currentMenus.safelyRemove(id: MenuItem.emptySimulator.id)
                
                let simulatorMenuTitleIndex = currentMenus.firstIndex(where: { $0.id == MenuItem.availableSimulatorTitle.id })!
                currentMenus.insert(.fetchingSimulatorStatus, at: simulatorMenuTitleIndex + 1)
                
                // apply update
                updateMenu()
            }
            
            func addSimulatorMenuToMainMenu(_ simulatorMenus: IdentifiedArrayOf<MenuItem>) {
                // remove fetching status if available
                currentMenus.safelyRemove(id: MenuItem.fetchingSimulatorStatus.id)
                
                // remove none status if available
                currentMenus.safelyRemove(id: MenuItem.emptySimulator.id)
                
                // insert simulators menu below section title
                let simulatorMenuTitleIndex = currentMenus.firstIndex(where: { $0.id == MenuItem.availableSimulatorTitle.id })!
                currentMenus.insert(contentsOf: simulatorMenus, at: simulatorMenuTitleIndex + 1)
                
                // apply update
                updateMenu()
            }
            
            // set fetching status
            addFetchingStatus()
            
            // fetch simulator
            environment.loadSimulator { simulators in
                let simulators = zip(simulators.indices, simulators)
                    .map{ (offset, element) -> MenuItem in
                        /// this will create O(n)^2, maybe better approach to check double name ?
                        let needUDID = simulators
                            .filter { $0.name == element.name }
                            .count > 1
                        
                        var menu = element.menuItem(needUDID: needUDID)
                        menu.subMenuItems = [
                            MenuItem.recordGIF(for: element.id),
                            MenuItem.recordMov(for: element.id),
                            MenuItem.recordMp4(for: element.id)
                        ]
                        
                        return menu
                    }
                
                // set none if empty
                guard simulators.isNotEmpty else {
                    addSimulatorMenuToMainMenu(IdentifiedArray([.emptySimulator]))
                    return
                }
                
                // add to main menu
                addSimulatorMenuToMainMenu(IdentifiedArray(simulators))
            }
        }
    }
}
