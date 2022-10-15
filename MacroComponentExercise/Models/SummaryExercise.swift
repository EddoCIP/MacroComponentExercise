//
//  SummaryExercise.swift
//  MacroComponentExercise
//
//  Created by Eddo Careera Iriyanto Putra on 14/10/22.
//

import Foundation

struct SummaryExercise {
    var exercises: [MyExercise] = []
    
    var totalDuration : Double {
        if exercises.isEmpty {
            return 0.0
        }
        
        return self.exercises.reduce(0.0) { partialResult, exercise in
            partialResult + exercise.duration
        }
    }
    
    var averageActiveDuration : Double {
        if exercises.isEmpty {
            return 0.0
        }
        
        let filteredExercise = self.exercises.filter { exercise in
            exercise.duration > 0
        }
        
        let totalDuration = filteredExercise.reduce(0.0) { partialResult, exercise in
            partialResult + exercise.duration
        }
        
        return totalDuration / Double(filteredExercise.count)
    }
    
    var summarizePerDay: [Dictionary<Int, Double>.Element] {
        var result = [Int: Double]()
        let dictionary = Dictionary(grouping: exercises) { $0.date.getWeekDay }
        
        for key in dictionary.keys {
            let filteredRecord = exercises.filter { $0.date.getWeekDay == key }
            result[key] = filteredRecord.map {Double($0.duration)}.reduce(0, +)
        }
        
        return result.sorted { $0.value > $1.value}
    }
    
    var filteredMajorDay: [String] {
        let total = summarizePerDay.reduce(0.0) { partialResult, item in
            partialResult + item.value
        }
        
        let average : Double = total / 7
        
        let filtered = summarizePerDay.filter { item in
            item.value > average
        }
        
        return filtered.map { item in
            Calendar.current.weekdaySymbols[item.key - 1]
        }
    }
}
