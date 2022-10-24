//
//  CustomProgressView.swift
//  MacroComponentExercise
//
//  Created by Eddo Careera Iriyanto Putra on 18/10/22.
//

import SwiftUI

struct CustomProgressView: View {
    let screenWidth = UIScreen.main.bounds.width
    let percentage = 0.5
    @State private var stepValue = 0.0
    
    init() {
        UISlider.appearance().thumbTintColor = UIColor(Color.red)
        UISlider.appearance().maximumTrackTintColor = UIColor(Color.red)
        UISlider.appearance().minimumTrackTintColor = UIColor(Color.yellow)
        UISlider.appearance().setMinimumTrackImage(UIImage(systemName: "circle.fill"), for: .normal)
        UISlider.appearance().setMaximumTrackImage(UIImage(systemName: "rectangle.fill"), for: .normal)
        UISlider.appearance().setThumbImage(UIImage(systemName: "heart.fill"), for: .normal)
        UISlider.appearance().setThumbImage(UIImage(systemName: "house.fill"), for: .highlighted)
    }
    
    var body: some View {
        let safeWidth = screenWidth * 0.9
        VStack {
            ZStack {
//                Color.blue.ignoresSafeArea()
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.white.opacity(0.2))
    //                Capsule()
    //                    .fill(Color.white.opacity(0.2))
    //                    .padding(8)
                    HStack {
    //                    Capsule()
    //                        .fill(Color.red)
                        Color.red
                            .clipShape(Capsule())
                            .frame(width: safeWidth * percentage)
                        Spacer()
                    }
                }
                .frame(width: safeWidth, height: 32, alignment: .center)
                .padding()
    //            .opacity(isAnimating ? 1 : 0)
    //            .offset(y: isAnimating ? 0 : 40)
    //            .animation(.easeOut(duration: 1), value: isAnimating)
            }
            Slider(value: $stepValue, in: 1...7, step: 1.0) {
                Text("\(stepValue)")
            }
            Text("\(stepValue)")
        }
    }
}

struct CustomProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CustomProgressView()
    }
}
