//
//  ExerciseView.swift
//  MacroComponentExercise
//
//  Created by Eddo Careera Iriyanto Putra on 05/11/22.
//

import SwiftUI

struct ExerciseView: View {
    var body: some View {
        VStack {
            Button {
                WorkoutManager.shared.start()
            } label: {
                Text("Start")
        }
            Button {
                WorkoutManager.shared.stop()
            } label: {
                Text("Stop")
            }
        }
        .onAppear {
            HealthStore.shared.requestAuthorization { success in
                print(success)
            }
        }
    }
}

struct ExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseView()
    }
}
