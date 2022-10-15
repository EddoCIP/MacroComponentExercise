//
//  ExerciseSummaryView.swift
//  MacroComponentExercise
//
//  Created by Eddo Careera Iriyanto Putra on 14/10/22.
//

import SwiftUI
import HealthKit

struct ExerciseSummaryView: View {
    @State private var totalMonthly: Double = 0.0
    @State private var summaryExercise : SummaryExercise = SummaryExercise()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Exercise Summary")
            
            HStack {
                Text("Total Exercise This Month")
                Text("\(summaryExercise.totalDuration.formatted()) minute(s)")
            }
            HStack {
                Text("Average Exercise This Month")
                Text("\(summaryExercise.averageActiveDuration.formatted()) minute(s)")
            }
            VStack(alignment: .leading, spacing: 5) {
                Text("Total Duration Per Day")
                ForEach(summaryExercise.summarizePerDay.indices, id: \.self) { index in
                    let item = summaryExercise.summarizePerDay[index]
                    HStack {
                        Text("\(Calendar.current.weekdaySymbols[item.key - 1])")
                        Text("\(item.value.formatted()) minute(s)")
                    }
                }
            }
            VStack(alignment: .leading) {
                Text("Your recommend day")
                HStack {
                    ForEach(summaryExercise.filteredMajorDay, id: \.self) { item in
                        Text(item)
                    }
                }
            }
        }
        .onAppear {
            getThisMonthExercise()
        }
    }
    
    func getThisMonthExercise() {
        summaryExercise = SummaryExercise()
        
        let startDate = Date().startOfMonth
        HealthStore.shared.getStatisticsExercise(startDate: startDate, interval: DateComponents(day: 1)) { statistics in
            statistics.enumerateStatistics(from: startDate, to: Date().endOfMonth) { statistic, stop in
                
                let count = statistic.sumQuantity()?.doubleValue(for: .minute()) ?? 0.0
                let date = statistic.startDate
                
                let myExercise = MyExercise(duration: count, date: date)
                
                summaryExercise.exercises.append(myExercise)
            }
        }
    }
}

struct ExerciseSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseSummaryView()
    }
}
