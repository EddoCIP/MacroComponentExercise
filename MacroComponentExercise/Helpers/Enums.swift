//
//  Enums.swift
//  MacroComponentExercise
//
//  Created by Eddo Careera Iriyanto Putra on 14/10/22.
//

import Foundation
import HealthKit

enum HKQuantityEnum: String, CaseIterable {
    case stepCount = "Step Count", height = "Height", weight = "Weight"
}

func getHKQuantity(hkQuantityLabel: String) -> HKQuantityType {
    switch hkQuantityLabel {
    case HKQuantityEnum.stepCount.rawValue:
        return HKQuantityType(.stepCount)
    case HKQuantityEnum.height.rawValue:
        return HKQuantityType(.height)
    case HKQuantityEnum.weight.rawValue:
        return HKQuantityType(.bodyMass)
    default:
        return HKQuantityType(.height)
    }
}

var hkQuantityTypeUnit : [HKQuantityType : HKUnit] = [
    HKQuantityType(.stepCount) : HKUnit.count(),
    HKQuantityType(.height) : HKUnit.meterUnit(with: .centi),
    HKQuantityType(.bodyMass) : HKUnit.gramUnit(with: .kilo),
    HKQuantityType(.appleExerciseTime) : HKUnit.minute()
]
