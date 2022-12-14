//
//  HealthKitStoreService.swift
//  MacroComponentExercise
//
//  Created by Eddo Careera Iriyanto Putra on 12/10/22.
//

import Foundation
import HealthKit

// MARK: Get Statistics Query
// Query statistic
// HK

class HealthStore {
    static var shared: HealthStore = HealthStore()
    
    var healthStore: HKHealthStore?
    var query: HKStatisticsCollectionQuery?
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }
    
    static let allTypes = Set([
        HKQuantityType(.appleExerciseTime),
        HKQuantityType(.activeEnergyBurned),
        HKQuantityType(.distanceWalkingRunning),
        HKQuantityType(.stepCount),
        HKQuantityType(.height),
        HKQuantityType(.bodyMass)
    ])
    
    static var quantityTypeList: [HKQuantityType] = [
        HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!,
        HKQuantityType.quantityType(forIdentifier: .height)!,
        HKQuantityType.quantityType(forIdentifier: .bodyMass)!,
        HKQuantityType(.appleExerciseTime)
    ]
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        guard let healthStore = self.healthStore else { return completion(false) }
        let sampleTypes: Set<HKSampleType> = [.workoutType(),
                                              .quantityType(forIdentifier: .heartRate)!,
                                              .quantityType(forIdentifier: .activeEnergyBurned)!,
                                              .quantityType(forIdentifier: .distanceCycling)!,
                                              .quantityType(forIdentifier: .distanceWalkingRunning)!,
                                              .quantityType(forIdentifier: .distanceWheelchair)!]
        
//        healthStore.requestAuthorization(toShare: [], read: [stepType, .workoutType(), HKSeriesType.workoutType(), HKSeriesType.activitySummaryType(), heightType, bodyMassType, HKQuantityType(.appleExerciseTime), dateOfBirthType]) { success, error in
//            completion(success)
//        }
        
        healthStore.requestAuthorization(toShare: sampleTypes, read: HealthStore.allTypes) { success, error in
            completion(success)
        }
    }
    
    func loadWorkout(workout: HKWorkoutActivityType, startDate: Date, endDate: Date = Date(), completion: @escaping ([HKWorkout]?) -> Void) {
        let workoutPredicate = HKQuery.predicateForWorkoutActivities(workoutActivityType: workout)
        
        let sourcePredicate = HKQuery.predicateForObjects(from: .default())
        
        let compound = NSCompoundPredicate(andPredicateWithSubpredicates:
          [workoutPredicate, sourcePredicate])
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate,
                                              ascending: true)
        
        let query = HKSampleQuery(
          sampleType: .workoutType(),
          predicate: compound,
          limit: 0,
          sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            DispatchQueue.main.async {
              //4. Cast the samples as HKWorkout
              guard
                let samples = samples as? [HKWorkout],
                error == nil
                else {
                  completion(nil)
                return
              }
                                      
              completion(samples)
            }
        }
        
        HKHealthStore().execute(query)
    }
    
//    func getDateOfBirth(completion: @escaping (DateComponents) -> Void) {
//        guard let healthStore = self.healthStore else { return }
//        
//        completion(try! healthStore.dateOfBirthComponents())
//    }
    
    func getStatisticsExercise(startDate: Date, endDate: Date = Date().endOfMonth, interval: DateComponents, completion: @escaping (HKStatisticsCollection) -> Void) {
        let exerciseType = HKQuantityType(.appleExerciseTime)
        let anchorDate = Date.mondayAt12AM()
        
//        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())
        
//        let daily = DateComponents(day: 1)
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        let query = HKStatisticsCollectionQuery(quantityType: exerciseType, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: interval)
        
        query.initialResultsHandler = { query, statisticCollection, error in
            guard let statisticCollection = statisticCollection else { return }
            completion(statisticCollection)
        }
        
        if let healthStore = healthStore {
            healthStore.execute(query)
        }
    }
    
    func getLatestValue(quantityType: HKQuantityType, completion: @escaping ([HKSample]?) -> Void) {
        let queryDescriptor = HKQueryDescriptor(sampleType: quantityType, predicate: nil)
        let sampleQuery = HKSampleQuery(queryDescriptors: [queryDescriptor], limit: 0, sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]) { query, samples, error in
            
            guard let samples = samples else {
                return
            }
            completion(samples)
        }
        
        if let healthStore = healthStore {
            healthStore.execute(sampleQuery)
        }
    }
    
    func calculateQuantityType(quantityType: HKQuantityType, completion: @escaping (HKStatisticsCollection?) -> Void) {
        
        let stepType = quantityType
        
        let anchorDate = Date.mondayAt12AM()
        
        let daily = DateComponents(day: 1)
        
        let predicate = HKQuery.predicateForSamples(withStart: anchorDate, end: Date(), options: .strictStartDate)
        
        query = HKStatisticsCollectionQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: daily)
        
        query!.initialResultsHandler = { query, statisticCollection, error in
            completion(statisticCollection)
        }
        
        if let healthStore = healthStore, let query = self.query {
            healthStore.execute(query)
        }
    }
    
    // MARK: From academy
    func requestHealthStatistic(by category: String, completion: @escaping ([HKStatisticsCollection]) -> Void) {
        guard let _ = healthStore, let type = HKObjectType.quantityType(forIdentifier: typeByCategory(category: category)) else { return }
        
    }
    
    func typeByCategory(category: String) -> HKQuantityTypeIdentifier {
        switch category {
        case "activeEnergyBurn":
            return .activeEnergyBurned
        case "exerciseTime":
            return .appleExerciseTime
        case "distanceWalkingRunning":
            return .distanceWalkingRunning
        default:
            return .stepCount
        }
    }
    
    //    func getLatestValue(quantityType: HKQuantityType, completion: @escaping (HKStatistics?) -> Void) {
    //        let queryDescriptor = HKQueryDescriptor(sampleType: quantityType, predicate: nil)
    //        let sampleQuery = HKSampleQuery(queryDescriptors: [queryDescriptor], limit: 1) { query, samples, error in
    //            guard let samples = samples else {
    //                return
    //            }
    //
    //            print(samples)
    //            completion(samples)
    //        }
    //
    //        let sQuery = HKStatisticsQuery(quantityType: quantityType, quantitySamplePredicate: nil) { query, statisticOrNil, errorOrNil in
    //            guard let statistic = statisticOrNil else {
    //                return
    //            }
    //
    //            print(statistic)
    //
    //            completion(statistic)
    //        }
    //
    //        if let healthStore = healthStore {
    //            healthStore.execute(sQuery)
    //        }
    //    }
}
