//
//  HealthStatistic.swift
//  MacroComponentExercise
//
//  Created by Eddo Careera Iriyanto Putra on 16/10/22.
//

import Foundation
import HealthKit

struct HealthStatistic {
    var id = UUID()
    var date : Date
    var stats : HKQuantity?
}
