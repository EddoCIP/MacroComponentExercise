//
//  CustomPicker.swift
//  MacroComponentExercise
//
//  Created by Eddo Careera Iriyanto Putra on 18/10/22.
//

import SwiftUI

struct CustomPicker: View {
    let selections : [String] = [
        "Senin", "Selasa", "Rabu", "Kamis", "Jum'at", "Sabtu", "Minggu"
    ]
    @State private var selected: String = ""
    @State private var selectedDay: String = ""
    
    let preferenceDays : [String] = [
        "Senin", "Jum'at"
    ]
    
    var body: some View {
        VStack {
            Picker("", selection: $selected) {
                ForEach(selections, id: \.self) { item in
                    Text(item.prefix(1))
                }
            }.pickerStyle(.segmented)
            
            HStack {
                let selectedIndex = selections.firstIndex(of: selectedDay) ?? -1
                ForEach(selections, id: \.self) { item in
                    let index = selections.firstIndex(of: item) ?? -1
                    let isAvailable = preferenceDays.firstIndex(of: item) ?? -1 != -1
                    Button {
                        print("Selected \(item)")
                        selectedDay = item
                    } label: {
                        VStack(spacing: -10) {
                            Text(item.prefix(1))
                                .foregroundColor(
                                    isAvailable ?
                                    Color.orange :
                                        Color.gray
                                )
                            Text(".")
                                .foregroundColor(Color.orange)
                                .if(!isAvailable || index == -1 || index != selectedIndex) { view in
                                    view.hidden()
                                }
                        }
                    }.disabled(!isAvailable)
                    
                    if index != (selections.count - 1) {
                        Spacer()
                    }
                }
            }
            .padding(.horizontal)
        }
        
        
    }
}

struct CustomPicker_Previews: PreviewProvider {
    static var previews: some View {
        CustomPicker()
    }
}

extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
