//
//  Process.swift
//  mimiq
//
//  Created by Wendy Liga on 30/10/20.
//  Copyright © 2020 Wendy Liga. All rights reserved.
//

import Foundation
import mimiq_core

final class MimiqProcess {
    static let shared = MimiqProcess()
    
    var process: Process?
    var stdoutPipe: Pipe?
    var stderrPipe: Pipe?
    
    func initProcess() {
        process = Process()
        stdoutPipe = Pipe()
        stderrPipe = Pipe()
        
        process?.standardOutput = stdoutPipe
        process?.standardError = stderrPipe
        
        guard let launchPath = Bundle.main.path(forResource: "mimiq", ofType: nil) else {
            fatalError("Unable to find mimiq executable")
        }
        
        process?.launchPath = launchPath
    }
    
    func simulatorList() -> [Simulator] {
        initProcess()
        process?.arguments = ["list", "--json"]
        process?.launch()
        self.process?.waitUntilExit()
        
        guard
            let data = stdoutPipe?.fileHandleForReading.readDataToEndOfFile(),
            let output = String(data: data, encoding: String.Encoding.utf8)
        else {
            return []
        }
        
        return (try? JSONDecoder().decode([Simulator].self, from: output.data(using: .utf8)!)) ?? []
    }
}
