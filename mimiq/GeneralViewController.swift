//
//  GeneralViewController.swift
//  mimiq
//
//  Created by Wendy Liga on 13/04/20.
//  Copyright © 2020 Wendy Liga. All rights reserved.
//

import Cocoa

final class GeneralViewController: NSViewController {
    
    let generatedPathText: NSTextField = {
        let view = NSTextField()
        view.isBezeled = false
        view.drawsBackground = false
        view.isEditable = false
        view.isSelectable = false
        view.stringValue = "GIF Generated Path"
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        return view
    }()
    
    let generatedPathTextField: NSTextField = {
        let view = NSTextField()
        view.isBezeled = true
        view.drawsBackground = false
        view.isEditable = false
        view.isSelectable = true
        view.isEnabled = false
        view.stringValue = UserDefaults.standard.string(forKey: "generate_gif_path") ?? "~/Desktop"
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        return view
    }()
    
    lazy var changePathButton: NSButton = { [weak self] in
        let view = NSButton(title: "Change", target: self, action: #selector(changeGIFPath))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        return view
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        title = "General"
        
        view.addSubview(generatedPathText)
        view.addSubview(generatedPathTextField)
        view.addSubview(changePathButton)
        
        let constraints: [NSLayoutConstraint] = [
            generatedPathText.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            generatedPathText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            generatedPathTextField.leadingAnchor.constraint(equalTo: generatedPathText.trailingAnchor, constant: 16),
            generatedPathTextField.trailingAnchor.constraint(equalTo: changePathButton.leadingAnchor, constant: -16),
            generatedPathTextField.centerYAnchor.constraint(equalTo: generatedPathText.centerYAnchor, constant: 0),
            
            changePathButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            changePathButton.centerYAnchor.constraint(equalTo: generatedPathText.centerYAnchor, constant: 0),
            changePathButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
      view = NSView()
    }
    
    @objc
    private func changeGIFPath() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        
        panel.runModal()
        
        let selectedPath = panel.directoryURL?.absoluteString.replacingOccurrences(of: "file://", with: "")
        // save to user default
        UserDefaults.standard.set(selectedPath, forKey: "generate_gif_path")
        
        generatedPathTextField.stringValue = UserDefaults.standard.string(forKey: "generate_gif_path") ?? "~/Desktop"
    }
}
