//
//  UserDefaultKey.swift
//  mimiq
//
//  Created by Wendy Liga on 15/04/20.
//  Copyright © 2020 Wendy Liga. All rights reserved.
//

import Foundation

internal enum UserDefaultsKey: String {
    case didSetupDefaultValue
    case defaultPath
    case startOnLogin
    case automaticCheckForUpdate
    
    var rawValue: String {
        switch self {
        case .didSetupDefaultValue:
            return "did_setup_default_value"
        case .defaultPath:
            return "generate_gif_path"
        case .startOnLogin:
            return "start_on_login"
        case .automaticCheckForUpdate:
            return "automaticCheckForUpdate"
        }
    }
}
