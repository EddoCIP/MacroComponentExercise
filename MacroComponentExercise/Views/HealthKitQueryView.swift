//
//  HealthKitQuery.swift
//  MacroComponentExercise
//
//  Created by Eddo Careera Iriyanto Putra on 12/10/22.
//

import SwiftUI
import HealthKit

struct HealthKitQueryView: View {
    @State private var selectedQuantityType : HKQuantityType = HKQuantityType(.stepCount)
    @State private var latestValue: Double = 0.0
    @State private var showExerciseThisWeek: Bool = false
    @State private var exercises: [MyExercise] = []
    @State private var selectedLabel: String = "Today Step"
    
    var body: some View {
        VStack {
            Menu {
                Button("Today Step") {
                    selectedQuantityType = HKQuantityType(.stepCount)
                    selectedLabel = "Today Step"
                    calculateTodaySteps()
                }
                Button("Height") {
                    selectedLabel = "Height"
                    selectedQuantityType = HKQuantityType(.height)
                    showHealthStaticData()
                }
                Button("Mass") {
                    selectedLabel = "Mass"
                    selectedQuantityType = HKQuantityType(.bodyMass)
                    showHealthStaticData()
                }
                Button("Today Duration") {
                    selectedLabel = "Today Duration"
                    getLatestStatisticsExercise()
                }
            } label: {
                Text(selectedLabel)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .controlSize(.regular)
            
            Text("\(latestValue.formatted())")
            
            Button("Show My exercise this week") {
                showStatisticsExercise(start: Date.mondayAt12AM(), end: Date().endOfDay)
                showExerciseThisWeek.toggle()
            }
            .buttonStyle(.borderless)
            .controlSize(.large)
            
            if showExerciseThisWeek {
                List {
                    ForEach(exercises) { exercise in
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Duration: \(exercise.duration.formatted()) minute(s)")
                            Text("Date: \(exercise.date.formatted())")
                        }
                    }
                }
            }
        }.onAppear {
            HealthStore.shared.requestAuthorization { success in
                print(success)
            }
        }
    }
    
    func calculateTodaySteps() {
        HealthStore.shared.calculateQuantityType(quantityType: selectedQuantityType) { statistics in
            guard let statistics = statistics else { return }
            
            statistics.enumerateStatistics(from: Date().startOfDay, to: Date()) { statistic, stop in
                guard let count = statistic.sumQuantity() else { return }
                latestValue = count.doubleValue(for: .count())
            }
        }
    }
    
    func showHealthStaticData() {
        HealthStore.shared.getLatestValue(quantityType: selectedQuantityType) { samples in
            if let samples = samples {
                if samples.isEmpty {
                    return
                }
                guard let currData:HKQuantitySample = samples[0] as? HKQuantitySample else { return }
                
                guard let quantityUnit = hkQuantityTypeUnit[selectedQuantityType] else { return }
                
                latestValue = currData.quantity.doubleValue(for: quantityUnit)
            }
        }
    }
    
    func showStatisticsExercise(start: Date, end: Date) {
        exercises = []
        HealthStore.shared.getStatisticsExercise(startDate: start, interval: DateComponents(day: 1)) { statisticsCollection in
            statisticsCollection.enumerateStatistics(from: start, to: end) { statistics, stop in
                
                let count = statistics.sumQuantity()?.doubleValue(for: .minute()) ?? 0.0
                let date = statistics.startDate
                
                let myExercise = MyExercise(duration: count, date: date)
                exercises.append(myExercise)
            }
        }
    }
    
    func getLatestStatisticsExercise() {
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        HealthStore.shared.getStatisticsExercise(startDate: startDate, interval: DateComponents(day: 1)) { statisticsCollection in
            statisticsCollection.enumerateStatistics(from: Date().startOfDay, to: Date().endOfDay) { statistics, stop in
                
                let count = statistics.sumQuantity()?.doubleValue(for: .minute()) ?? 0.0
                latestValue = count
            }
        }
    }
}

struct HealthKitQueryView_Previews: PreviewProvider {
    static var previews: some View {
        HealthKitQueryView()
    }
}
