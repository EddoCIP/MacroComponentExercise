//
//  Last30SummaryViews.swift
//  MacroComponentExercise
//
//  Created by Eddo Careera Iriyanto Putra on 15/10/22.
//

import SwiftUI

struct Last30SummaryViews: View {
    @State private var summaryExercise = SummaryExercise()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Your last 30 days summary")
                .font(.headline)

            HStack {
                Text("Total Exercise")
                Text("\(summaryExercise.totalDuration.formatted()) minute(s)")
            }
            HStack {
                Text("Average Exercise")
                Text("\(summaryExercise.averageActiveDuration.formatted()) minute(s)")
            }
            
            VStack(alignment: .leading) {
                Text("Your recommend day")
                    .font(.largeTitle)
                HStack {
                    ForEach(summaryExercise.filteredMajorDay, id: \.self) { item in
                        Text(item)
                    }
                }
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
            List {
                ForEach(summaryExercise.exercises) { exercise in
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Duration: \(exercise.duration.formatted()) minute(s)")
                        Text("Date: \(exercise.date.formatted())")
                    }
                }
            }
            Spacer()
        }
        .onAppear {
            getSummary()
        }
    }
    
    func getSummary() {
        let startDate = Calendar.current.date(byAdding: .day, value: -30, to: Date())!
        
        HealthStore.shared.getStatisticsExercise(startDate: startDate, endDate: Date(), interval: DateComponents(day: 1)) { statistics in
            summaryExercise.exercises = []
            
            statistics.enumerateStatistics(from: startDate, to: Date()) { statistic, stop in
                
                let count = statistic.sumQuantity()?.doubleValue(for: .minute()) ?? 0.0
                let date = statistic.startDate
                
                let myExercise = MyExercise(duration: count, date: date)
                
                summaryExercise.exercises.append(myExercise)
            }
        }
    }
}

struct Last30SummaryViews_Previews: PreviewProvider {
    static var previews: some View {
        Last30SummaryViews()
    }
}
