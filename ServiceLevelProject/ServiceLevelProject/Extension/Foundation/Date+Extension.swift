//
//  Date+Extension.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/12.
//

import Foundation

extension Date {
    static let dateformatter = DateFormatter()
    
    var separateDate: (String, String, String) {
        let date: Date = self
        let formatter = Date.dateformatter
        
        formatter.dateFormat = "yyyy"
        let year = formatter.string(from: date)
        formatter.dateFormat = "MM"
        let month = formatter.string(from: date)
        formatter.dateFormat = "dd"
        let day = formatter.string(from: date)
        
        return (year, month, day)
    }
    
    var dateFormat: String {
        let date: Date = self
        let formatter = Date.dateformatter
        
        if Calendar.current.isDateInToday(date) {
            formatter.dateFormat = "a hh:mm"
        } else {
            formatter.dateFormat = "MM/dd a hh:mm"
        }
        
        return formatter.string(from: date)
    }
}
