//
//  RecordProcess.swift
//  mimiq
//
//  Created by Wendy Liga on 12/04/20.
//  Copyright © 2020 Wendy Liga. All rights reserved.
//

import Foundation
import mimiq_core

final class MimiqRecordProcess {
    var process: Process?
    var stdoutPipe: Pipe?
    var stderrPipe: Pipe?
    var stdinPipe: Pipe?
    
    func initProcess() {
        process = Process()
        stdoutPipe = Pipe()
        stderrPipe = Pipe()
        stdinPipe = Pipe()
        
        process?.standardOutput = stdoutPipe
        process?.standardError = stderrPipe
        process?.standardInput = stdinPipe
        
        guard let launchPath = Bundle.main.path(forResource: "mimiq", ofType: nil) else {
            fatalError("Unable to find mimiq executable")
        }
        
        process?.launchPath = launchPath
    }
    
    func startRecord(_ simulatorId: Simulator.ID, type: RecordType) {
        initProcess()
        
        guard let ffmpegPath = Bundle.main.resourcePath else {
            fatalError("Unable to find bundle resource path")
        }
        
        process?.arguments = [
            "--udid", simulatorId.rawValue.uuidString,
            "--output", type.rawValue,
            "--path", UserDefaults.standard.string(forKey: "generate_gif_path") ?? "\(NSHomeDirectory())/Desktop",
            "--custom-ffmpeg", ffmpegPath
        ]
        process?.launch()
    }
    
    func stopRecord(
        beforeSendInteruption: () -> Void,
        completion: @escaping (Int32?, String?, String?
    ) -> Void) {
        beforeSendInteruption()
        stdinPipe?.fileHandleForWriting.write("\n".data(using: .utf8)!)
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.process?.waitUntilExit()
            guard
                let stdoutPipe = self?.stdoutPipe,
                let stderrPipe = self?.stderrPipe
            else { return }
            
            let data = stdoutPipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: data, encoding: String.Encoding.utf8)
            
            let errorData = stderrPipe.fileHandleForReading.readDataToEndOfFile()
            let errorOuput = String(data: errorData, encoding: String.Encoding.utf8)
            
            DispatchQueue.main.async { [weak self] in
                completion(self?.process?.terminationStatus, output, errorOuput)
            }
        }
    }
}
