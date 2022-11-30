//
//  AnimationOnboarding.swift
//  MacroComponentExercise
//
//  Created by Eddo Careera Iriyanto Putra on 19/11/22.
//

import SwiftUI

struct AnimationOnboarding: View {
    @State var happyFaceOffset = UIScreen.main.bounds.width / 2
    @State var happyFaceRotation = 0.0
    @State var sadFaceOffset: CGFloat = 0
    @State var sadFaceRotation = 0.0
    
    let rotationRate = 360 * (1.5/90)
    
    let timer = Timer.publish(every: (3.0/180), on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack(alignment: .center) {
            Image("SadFace")
                .resizable()
                .frame(maxWidth: UIScreen.main.bounds.width / 3, maxHeight: UIScreen.main.bounds.width / 3)
                .scaledToFit()
                .rotationEffect(.degrees(sadFaceRotation))
                .offset(x: sadFaceOffset)
                .if(happyFaceOffset == 0) { view in
                    view.hidden()
                }
            Image("HappyFace")
                .resizable()
                .frame(maxWidth: UIScreen.main.bounds.width / 3, maxHeight: UIScreen.main.bounds.width / 3)
                .scaledToFit()
                .rotationEffect(.degrees(happyFaceRotation))
                .offset(x: happyFaceOffset)
        }
        .onReceive(timer) { _ in
            withAnimation {
                if happyFaceOffset > 0 {
                    happyFaceRotation -= rotationRate
                    happyFaceOffset -= (UIScreen.main.bounds.width / 2) * (2.0/240)
                    
                    if happyFaceOffset <= UIScreen.main.bounds.width / 3 {
                        sadFaceOffset -= (UIScreen.main.bounds.width / 2) * (2.0/240)
                        sadFaceRotation -= rotationRate
                    }
                }
            }
        }
    }
}

struct AnimationOnboarding_Previews: PreviewProvider {
    static var previews: some View {
        AnimationOnboarding()
    }
}
