//
//  String+Extension.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/07.
//

import UIKit

extension String {
    static func setText(_ text: TextSet) -> String {
        return text.rawValue
    }
    
    var withHypen: String {
        var stringWithHypen: String = self.replacingOccurrences(of: "-", with: "")

        switch stringWithHypen.count {
        case ..<4: break
        case ..<7:
            stringWithHypen.insert("-", at: stringWithHypen.index(stringWithHypen.startIndex, offsetBy: 3))
        case ..<11:
            stringWithHypen.insert("-", at: stringWithHypen.index(stringWithHypen.startIndex, offsetBy: 3))
            stringWithHypen.insert("-", at: stringWithHypen.index(stringWithHypen.startIndex, offsetBy: 7))
        case 11:
            stringWithHypen.insert("-", at: stringWithHypen.index(stringWithHypen.startIndex, offsetBy: 3))
            stringWithHypen.insert("-", at: stringWithHypen.index(stringWithHypen.endIndex, offsetBy: -4))
        default:
            break
        }
        
        return stringWithHypen
    }
}
