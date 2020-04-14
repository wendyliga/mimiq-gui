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
        
        let image = NSImage(named: "AppIcon")?.resizeTo(NSSize(width: 200, height: 200))
        image?.resizingMode = .stretch
        
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
    
    let titleDescriptionText: NSTextField = {
        let view = NSTextField()
        view.isBezeled = false
        view.drawsBackground = false
        view.isEditable = false
        view.isSelectable = false
        view.stringValue = "Version \(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")!) © 2020 Wendy Liga"
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let mimiqDescriptionText: NSTextField = {
        let view = NSTextField()
        view.isBezeled = false
        view.drawsBackground = false
        view.isEditable = false
        view.isSelectable = false
        view.stringValue = "Mimiq is a simple Xcode Simulator GIF recoder. Mimiq is created because i have too many precious time to spend on converting MOV to GIF manually on web. I hope you guys can find mimiq useful."
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let dividerView: NSView = {
        let view = NSView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.gray.withAlphaComponent(0.3).cgColor
        
        return view
    }()
    
    lazy var reportBugButton: NSButton = { [weak self] in
        let view = NSButton(title: "Report Bug", target: self, action: #selector(openReportBug))
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var contributionButton: NSButton = { [weak self] in
        let view = NSButton(title: "Contribute", target: self, action: #selector(openContribution))
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var githubButton: NSButton = { [weak self] in
        let view = NSButton(title: "GitHub", target: self, action: #selector(openGithub))
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var twitterButton: NSButton = { [weak self] in
        let view = NSButton(title: "Check My Twitter", target: self, action: #selector(openTwitter))
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        title = "About"
        
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
        view.addSubview(logoImage)
        view.addSubview(titleText)
        view.addSubview(titleDescriptionText)
        view.addSubview(mimiqDescriptionText)
        view.addSubview(dividerView)
        view.addSubview(reportBugButton)
        view.addSubview(contributionButton)
        view.addSubview(githubButton)
        view.addSubview(twitterButton)
        
        NSLayoutConstraint.activate([
            logoImage.topAnchor.constraint(equalTo: view.topAnchor, constant: -24),
            logoImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            logoImage.widthAnchor.constraint(equalToConstant: 200),
            logoImage.heightAnchor.constraint(equalToConstant: 200),
            
            titleText.leadingAnchor.constraint(equalTo: logoImage.trailingAnchor),
            titleText.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleText.centerYAnchor.constraint(equalTo: logoImage.centerYAnchor, constant: -20),
            
            titleDescriptionText.topAnchor.constraint(equalTo: titleText.bottomAnchor, constant: 0),
            titleDescriptionText.leadingAnchor.constraint(equalTo: logoImage.trailingAnchor, constant: 0),
            titleDescriptionText.widthAnchor.constraint(equalToConstant: 300),
            titleDescriptionText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            mimiqDescriptionText.topAnchor.constraint(equalTo: titleDescriptionText.bottomAnchor, constant: 16),
            mimiqDescriptionText.leadingAnchor.constraint(equalTo: logoImage.trailingAnchor),
            mimiqDescriptionText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            dividerView.topAnchor.constraint(equalTo: mimiqDescriptionText.bottomAnchor, constant: 16),
            dividerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            dividerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            
            reportBugButton.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 16),
            reportBugButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            reportBugButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            
            contributionButton.topAnchor.constraint(equalTo: reportBugButton.topAnchor),
            contributionButton.leadingAnchor.constraint(equalTo: reportBugButton.trailingAnchor, constant: 16),
            contributionButton.bottomAnchor.constraint(equalTo: reportBugButton.bottomAnchor),
            
            githubButton.topAnchor.constraint(equalTo: reportBugButton.topAnchor),
            githubButton.leadingAnchor.constraint(equalTo: contributionButton.trailingAnchor, constant: 16),
            githubButton.bottomAnchor.constraint(equalTo: reportBugButton.bottomAnchor),
            
            twitterButton.topAnchor.constraint(equalTo: reportBugButton.topAnchor),
            twitterButton.leadingAnchor.constraint(equalTo: githubButton.trailingAnchor, constant: 16),
            twitterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            twitterButton.bottomAnchor.constraint(equalTo: reportBugButton.bottomAnchor)
        ])
    }
    
    @objc
    private func openReportBug() {
        NSWorkspace.shared.open(URL(string: "https://github.com/wendyliga/mimiq-gui/issues")!)
    }
    
    @objc
       private func openContribution() {
           NSWorkspace.shared.open(URL(string: "https://github.com/wendyliga/mimiq-gui")!)
       }
    
    @objc
    private func openGithub() {
        NSWorkspace.shared.open(URL(string: "https://github.com/wendyliga/mimiq-gui")!)
    }
    
    @objc
    private func openTwitter() {
        NSWorkspace.shared.open(URL(string: "https://twitter.com/wendyliga")!)
    }
}
