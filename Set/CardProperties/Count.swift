//
//  Count.swift
//  Set
//
//  Created by comp05A on 9/13/18.
//  Copyright © 2018 Universidad Autonoma de Baja California. All rights reserved.
//

import Foundation

enum Count {
    case one, two, three
    
    public var number: Int {
        switch self {
        case .one :
            return 1
        case .two:
            return 2
        case .three:
            return 3
        }
    }
}
