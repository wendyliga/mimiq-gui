//
//  MimiqMenuEnvironment.swift
//  mimiq
//
//  Created by Wendy Liga on 30/10/20.
//  Copyright © 2020 Wendy Liga. All rights reserved.
//

import Foundation
import mimiq_core

final class MimiqMenuEnvironment {
    // MARK: - Interface
    
    typealias LoadSimulatorCompletion = ([Simulator]) -> Void
    
    var loadSimulator: (_ simulators: @escaping LoadSimulatorCompletion) -> Void
    
    // only support recording 1 at a time
    var recording: (_ type: RecordType, _ simulatorId: Simulator.ID) -> Void
    var stopRecording: () -> Void
    
    // MARK: - Values
    
    private lazy var recordProcess = MimiqRecordProcess()
    
    // MARK: - Life Cycle
    
    init(
        loadSimulator: @escaping (@escaping MimiqMenuEnvironment.LoadSimulatorCompletion) -> Void,
        recording: @escaping (RecordType, Simulator.ID) -> Void,
        stopRecording: @escaping () -> Void
    ) {
        self.loadSimulator = loadSimulator
        self.recording = recording
        self.stopRecording = stopRecording
    }
    
    convenience init() {
        self.init(
            loadSimulator: { completion in
                DispatchQueue.global(qos: .background).async {
                    let latestSimulators = MimiqProcess.shared.simulatorList()
                    
                    DispatchQueue.main.async {
                        completion(latestSimulators)
                    }
                }
            },
            recording: { _,_ in},
            stopRecording: {}
        )
        
        // need self reference, set after self.init
        self.recording = { [unowned self] type, id in
            self.recordProcess.startRecord(id, type: type)
        }
        
        self.stopRecording = { [unowned self] in
            self.recordProcess.stopRecord(beforeSendInteruption: {}, completion: { _,_,_ in
                
            })
        }
    }
}
