//
//  AboutViewController.swift
//  mimiq
//
//  Created by Wendy Liga on 13/04/20.
//  Copyright © 2020 Wendy Liga. All rights reserved.
//

import Cocoa

final class AboutViewController: NSViewController {
    
    // MARK: - View
    
    let logoImage: NSImageView = {
        let view = NSImageView()
        
        let image = NSImage(named: "AppIcon")?.resizeTo(NSSize(width: 250, height: 250))
        image?.resizingMode = .stretch
        
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.black.cgColor
        
        view.image = image
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
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
        
        title = "About"
        
        view.addSubview(logoImage)
        view.addSubview(titleText)
        
        NSLayoutConstraint.activate([
            logoImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            logoImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            logoImage.widthAnchor.constraint(equalToConstant: 250),
            logoImage.heightAnchor.constraint(equalToConstant: 250),
            titleText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleText.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = NSView()
    }
}
