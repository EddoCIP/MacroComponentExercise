//
//  ContentView.swift
//  MacroComponentExercise
//
//  Created by Eddo Careera Iriyanto Putra on 12/10/22.
//

import SwiftUI

struct ContentView: View {
    @State private var selectionIndex = 0
    var body: some View {
        TabView(selection: $selectionIndex) {
            BackgroundTimer()
                .tabItem {
                    Image(systemName: "heart.rectangle.fill")
                    Text("HealthKit Query")
                }
                .tag(0)
            ExerciseSummaryView()
                .tabItem {
                    Image(systemName: "heart.rectangle")
                    Text("This Month Summary")
                }
                .tag(1)
            Last30SummaryViews()
                .tabItem {
                    Image(systemName: "calendar.circle.fill")
                    Text("30 Days Summary")
                }
                .tag(2)
            CustomProgressView()
                .tabItem {
                    Image(systemName: "calendar.circle.fill")
                    Text("Custom Progress View")
                }
                .tag(3)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
