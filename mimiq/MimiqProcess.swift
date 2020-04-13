//
//  MimiqProcess.swift
//  mimiq
//
//  Created by Wendy Liga on 12/04/20.
//  Copyright © 2020 Wendy Liga. All rights reserved.
//

import Foundation

struct Simulator: Decodable {
    let udid: UUID
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case udid, name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let rawUDID = try container.decode(String.self, forKey: .udid)
        guard let udid = UUID(uuidString: rawUDID) else {
            fatalError("Failed to initialize UUID, rawData \(rawUDID)")
        }
        
        self.udid = udid
        name = try container.decode(String.self, forKey: .name)
    }
}

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
    
    func startRecord(_ udid: String) {
        initProcess()
        process?.arguments = ["--udid", udid]
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
