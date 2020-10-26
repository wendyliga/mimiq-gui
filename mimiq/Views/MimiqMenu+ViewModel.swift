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
    var menus: ([NSMenuItem]) -> Void { get }
}

typealias MimiqMenuViewModel = MimiqMenuViewModelInput & MimiqMenuViewModelOutput

final class DefaultMimiqMenuViewModel: MimiqMenuViewModel {
    var menus: (_ menus: [NSMenuItem]) -> Void = { _ in}
    
    init() {}
    
    func load() {
        menus([])
    }
}
