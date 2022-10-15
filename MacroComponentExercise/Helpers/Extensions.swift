//
//  Extensions.swift
//  MacroComponentExercise
//
//  Created by Eddo Careera Iriyanto Putra on 12/10/22.
//

import Foundation

extension Date {
    static func mondayAt12AM() -> Date {
        return Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
    }
    
    static func lastMonthStartDate() -> Date {
        return Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.year, .day], from: Calendar.current.date(byAdding: .month, value: -1, to: Date())!))!
    }
    
    //    static func startOfDay() -> Date {
    //        return Calendar.current.startOfDay(for: self)
    //    }
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    var startOfMonth: Date {
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)
        
        return calendar.date(from: components)!
    }
    
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!
    }
    
    var startOfLastMonth: Date {
        var components = DateComponents()
        components.month = -1
        
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!
    }
    
    var endOfLastMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfLastMonth)!
    }
    
    func isMonday() -> Bool {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.weekday], from: self)
        return components.weekday == 2
    }
    
    var getWeekDay: Int {
        return Calendar(identifier: .gregorian).dateComponents([.weekday], from: self).weekday!
    }
    
    var formatCurrentTimezone: String {
        let format = DateFormatter()
        format.timeZone = .current
        format.dateFormat = "dd-MMM-yyyy"
         
        return format.string(from: self)
    }
}
