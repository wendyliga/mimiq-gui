//
//  GeneralViewController.swift
//  mimiq
//
//  Created by Wendy Liga on 13/04/20.
//  Copyright © 2020 Wendy Liga. All rights reserved.
//

import Cocoa
import Sparkle

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
    
    let generatedPathExplanationText: NSTextField = {
        let view = NSTextField()
        view.isBezeled = false
        view.drawsBackground = false
        view.isEditable = false
        view.isSelectable = false
        view.stringValue = "This is the part mimiq will used to stored generated GIF"
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alphaValue = 0.5
        view.font = NSFont.systemFont(ofSize: 10, weight: .light)
        
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
    
    let dividerView: NSView = {
        let view = NSView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.gray.withAlphaComponent(0.3).cgColor
        
        return view
    }()
    
    let miscellaneousTitleText: NSTextField = {
        let view = NSTextField()
        view.isBezeled = false
        view.drawsBackground = false
        view.isEditable = false
        view.isSelectable = false
        view.stringValue = "Miscellaneous"
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        return view
    }()
    
    lazy var automaticallyStartOnStartupButton: NSButton = { [weak self] in
        let view = NSButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setButtonType(.switch)
        view.title = "Launch Mimiq on Login"
        view.target = self
        view.action = #selector(setLaunchOnLogin)
        view.state = UserDefaults.standard.bool(forKey: UserDefaultsKey.startOnLogin.rawValue) ? .on : .off
        
        return view
    }()
    
    lazy var checkForAutomaticUpdateButton: NSButton = { [weak self] in
        let view = NSButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setButtonType(.switch)
        view.title = "Check Update Automatically"
        view.target = self
        view.action = #selector(setAutomaticallyCheckUpdate)
        view.state = UserDefaults.standard.bool(forKey: UserDefaultsKey.automaticCheckForUpdate.rawValue) ? .on : .off
        
        return view
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        title = "General"
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
      view = NSView()
    }
    
    // MARK: - Function
    
    private func setupView() {
        view.addSubview(generatedPathText)
        view.addSubview(generatedPathTextField)
        view.addSubview(generatedPathExplanationText)
        view.addSubview(changePathButton)
        view.addSubview(dividerView)
        view.addSubview(miscellaneousTitleText)
        view.addSubview(automaticallyStartOnStartupButton)
        view.addSubview(checkForAutomaticUpdateButton)
        
        let constraints: [NSLayoutConstraint] = [
            generatedPathText.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            generatedPathText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            generatedPathTextField.leadingAnchor.constraint(equalTo: generatedPathText.trailingAnchor, constant: 16),
            generatedPathTextField.trailingAnchor.constraint(equalTo: changePathButton.leadingAnchor, constant: -16),
            generatedPathTextField.centerYAnchor.constraint(equalTo: generatedPathText.centerYAnchor, constant: 0),
            
            changePathButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            changePathButton.centerYAnchor.constraint(equalTo: generatedPathText.centerYAnchor, constant: 0),
            
            generatedPathExplanationText.leadingAnchor.constraint(equalTo: generatedPathTextField.leadingAnchor),
            generatedPathExplanationText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            generatedPathExplanationText.topAnchor.constraint(equalTo: generatedPathTextField.bottomAnchor, constant: 8),
            generatedPathExplanationText.bottomAnchor.constraint(equalTo: dividerView.topAnchor, constant: -16),
            
            dividerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dividerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            
            miscellaneousTitleText.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 16),
            miscellaneousTitleText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            miscellaneousTitleText.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -48),
            
            automaticallyStartOnStartupButton.topAnchor.constraint(equalTo: miscellaneousTitleText.topAnchor),
            automaticallyStartOnStartupButton.leadingAnchor.constraint(equalTo: generatedPathTextField.leadingAnchor),
            automaticallyStartOnStartupButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            automaticallyStartOnStartupButton.centerYAnchor.constraint(equalTo: miscellaneousTitleText.centerYAnchor),
            
            checkForAutomaticUpdateButton.topAnchor.constraint(equalTo: automaticallyStartOnStartupButton.bottomAnchor, constant: 16),
            checkForAutomaticUpdateButton.leadingAnchor.constraint(equalTo: generatedPathTextField.leadingAnchor),
            checkForAutomaticUpdateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc
    private func changeGIFPath() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        
        panel.runModal()
        
        let selectedPath = panel.directoryURL?.absoluteString.replacingOccurrences(of: "file://", with: "")
        
        // save to user default
        UserDefaults.standard.set(selectedPath, forKey: UserDefaultsKey.defaultPath.rawValue)
        
        generatedPathTextField.stringValue = UserDefaults.standard.string(forKey: UserDefaultsKey.defaultPath.rawValue) ?? "~/Desktop"
    }
    
    @objc
    private func setLaunchOnLogin() {
        var value = UserDefaults.standard.bool(forKey: UserDefaultsKey.startOnLogin.rawValue)
        value.toggle()
        UserDefaults.standard.set(value, forKey: UserDefaultsKey.startOnLogin.rawValue)
    }
    
    @objc
    private func setAutomaticallyCheckUpdate() {
        var value = UserDefaults.standard.bool(forKey: UserDefaultsKey.automaticCheckForUpdate.rawValue)
        value.toggle()
        UserDefaults.standard.set(value, forKey: UserDefaultsKey.automaticCheckForUpdate.rawValue)
        
        let updater = SUUpdater()
        updater.automaticallyChecksForUpdates = value
    }
}
