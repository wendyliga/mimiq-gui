//
//  GeneralViewController.swift
//  mimiq
//
//  Created by Wendy Liga on 13/04/20.
//  Copyright © 2020 Wendy Liga. All rights reserved.
//

import Cocoa

final class GeneralViewController: NSViewController {
    
    let titleText: NSTextField = {
        let view = NSTextField()
        view.isBezeled = false
        view.drawsBackground = false
        view.isEditable = false
        view.isSelectable = false
        view.stringValue = "Mimiq"
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = NSFont.systemFont(ofSize: 28, weight: .bold)
        
        return view
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        title = "General"
        
        view.addSubview(titleText)
        
        NSLayoutConstraint.activate([
            titleText.leadingAnchor.constraint(equalTo: view.trailingAnchor),
            titleText.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleText.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            titleText.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
      self.view = NSView()
    }
}
