//
//  CustomSlider.swift
//  MacroComponentExercise
//
//  Created by Eddo Careera Iriyanto Putra on 18/10/22.
//

import SwiftUI

struct CustomSlider: View {
    @State private var value = 0.0
    let min: CGFloat = 1
    let max: CGFloat = 7
    let step: CGFloat = 1
    
    init() {
        UISlider.appearance().thumbTintColor = UIColor(Color.orange)
        UISlider.appearance().maximumTrackTintColor = UIColor(Color.gray)
        UISlider.appearance().minimumTrackTintColor = UIColor(Color.red)
//        UISlider.appearance().setMinimumTrackImage(UIImage(systemName: "circle.fill"), for: .normal)
//        UISlider.appearance().setMaximumTrackImage(UIImage(systemName: "rectangle.fill"), for: .normal)
//        UISlider.appearance().setThumbImage(UIImage(systemName: "circle.fill"), for: .normal)
//        UISlider.appearance().setThumbImage(UIImage(systemName: "circle.fill"), for: .highlighted)
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            HStack(spacing: 0) {
                ForEach(0..<Int(max)) { index in
                    VStack {
                        let isPassed = index < Int(value)
                        Circle()
                            .fill(isPassed ? Color.red : Color.gray)
                            .frame(width: 25, height: 25)
                    }
                    if index != Int(max - 1) {
                        Spacer()
                    }
                }
            }
            Slider(value: $value, in: min...max, step: step)
        }
    }
}

struct CustomSlider_Previews: PreviewProvider {
    static var previews: some View {
        CustomSlider()
    }
}
