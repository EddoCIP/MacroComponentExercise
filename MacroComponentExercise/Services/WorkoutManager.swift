//
//  WorkoutManager.swift
//  MacroComponentExercise
//
//  Created by Eddo Careera Iriyanto Putra on 05/11/22.
//

import Foundation
import HealthKit

class WorkoutManager {
    static var shared = WorkoutManager()
    var healthStore: HKHealthStore = HealthStore.shared.healthStore ?? HKHealthStore()
    var workoutBuilder: HKWorkoutBuilder?
    
    func start() {
        HealthStore.shared.requestAuthorization { success in
            if success {
                self.beginWorkout()
            }
        }
    }
    
    private func beginWorkout() {
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.locationType = .outdoor
        workoutConfiguration.activityType = .running
        self.workoutBuilder = HKWorkoutBuilder(healthStore: healthStore, configuration: workoutConfiguration, device: .local())
        workoutBuilder?.beginCollection(withStart: Date(), completion: { success, error in
            print(success)
            if success {
                print("Success")
            }
        })
    }
    
    func stop() {
        workoutBuilder?.endCollection(withEnd: Date(), completion: { success, error in
            if success {
                self.workoutBuilder?.finishWorkout(completion: { workout, error in
                    guard let workout = workout else { return }
                    print(workout)
                    self.healthStore.save(workout) { success, error in
                        print("success")
                    }
                })
            }
        })
    }
}
