//
//  MimiqMenu+ViewModel.swift
//  mimiq
//
//  Created by Wendy Liga on 26/10/20.
//  Copyright © 2020 Wendy Liga. All rights reserved.
//

import Cocoa
import mimiq_core

struct MimiqMenuEnvironment {
    typealias LoadSimulatorCompletion = ([Simulator]) -> Void
    var loadSimulator: (_ simulators: @escaping LoadSimulatorCompletion) -> Void
    
    static var live: Self {
        MimiqMenuEnvironment(loadSimulator: { completion in
            DispatchQueue.global(qos: .background).async {
                let latestSimulators = MimiqProcess.shared.simulatorList()

                DispatchQueue.main.async {
                    completion(latestSimulators)
                }
            }
        })
    }
}

protocol MimiqMenuViewModelInput {
    func load()
    func menuWillOpen()
}

protocol MimiqMenuViewModelOutput {
    var menus: (IdentifiedArrayOf<MenuItem>) -> Void { get set }
}

typealias MimiqMenuViewModel = MimiqMenuViewModelInput & MimiqMenuViewModelOutput

final class DefaultMimiqMenuViewModel: MimiqMenuViewModel {
    // values
    let environment: MimiqMenuEnvironment
    
    // output
    var menus: (_ menus: IdentifiedArrayOf<MenuItem>) -> Void = { _ in}
    
    init(environment: MimiqMenuEnvironment) {
        self.environment = environment
    }
    
    // input
    func load() {
        refreshMenu()
    }
    
    func menuWillOpen() {
        refreshMenu()
    }
}

extension DefaultMimiqMenuViewModel {
    func refreshMenu() {
        var _menus: IdentifiedArrayOf<MenuItem> = []
        
        func updateMenu() {
            menus(_menus)
        }
        
        fetch_initial_menu: do {
            _menus = [
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
                _menus.safelyRemove(id: MenuItem.emptySimulator.id)
                
                let simulatorMenuTitleIndex = _menus.firstIndex(where: { $0.id == MenuItem.availableSimulatorTitle.id })!
                _menus.insert(.fetchingSimulatorStatus, at: simulatorMenuTitleIndex + 1)
                
                // apply update
                updateMenu()
            }
            
            func addSimulatorMenuToMainMenu(_ simulatorMenus: IdentifiedArrayOf<MenuItem>) {
                // remove fetching status if available
                _menus.safelyRemove(id: MenuItem.fetchingSimulatorStatus.id)
                
                // remove none status if available
                _menus.safelyRemove(id: MenuItem.emptySimulator.id)
                
                // insert simulators menu below section title
                let simulatorMenuTitleIndex = _menus.firstIndex(where: { $0.id == MenuItem.availableSimulatorTitle.id })!
                _menus.insert(contentsOf: simulatorMenus, at: simulatorMenuTitleIndex + 1)
                
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
                            MenuItem.recordGIF(for: element.id)
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
