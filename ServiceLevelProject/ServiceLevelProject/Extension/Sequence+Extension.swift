//
//  Sequence+Extension.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/24.
//

import Foundation

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
