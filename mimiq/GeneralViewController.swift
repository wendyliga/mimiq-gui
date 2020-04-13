//
//  GeneralViewController.swift
//  mimiq
//
//  Created by Wendy Liga on 13/04/20.
//  Copyright © 2020 Wendy Liga. All rights reserved.
//

import Cocoa

final class GeneralViewController: NSViewController {
    
    let textField = NSTextField()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        title = "General"
//        titleText.string = "General"
//        textField.isBezeled = false
//        textField.drawsBackground = false
//        textField.isEditable = false
//        textField.isSelectable = false
//        textField.stringValue = "General"
        
//        view.addSubview(titleText)
//        titleText.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            titleText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            titleText.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
      self.view = NSView()
    }
}
