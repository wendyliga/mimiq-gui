//
//  MimiqMenu+ViewModel.swift
//  mimiq
//
//  Created by Wendy Liga on 26/10/20.
//  Copyright © 2020 Wendy Liga. All rights reserved.
//

import Cocoa

protocol MimiqMenuViewModelInput {
    func load()
}

protocol MimiqMenuViewModelOutput {
    var menus: ([Menu]) -> Void { get set } 
}

typealias MimiqMenuViewModel = MimiqMenuViewModelInput & MimiqMenuViewModelOutput

final class DefaultMimiqMenuViewModel: MimiqMenuViewModel {
    var menus: (_ menus: [Menu]) -> Void = { _ in}
    
    init() {}
    
    func load() {
        let _menus: [Menu] = [
            .availableSimulatorTitle,
            .separator,
            .checkForUpdate,
            .preferences,
            .separator,
            .quit
        ]
        
        menus(_menus)
    }
}
