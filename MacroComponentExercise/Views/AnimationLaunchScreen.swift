//
//  AnimationLaunchScreen.swift
//  MacroComponentExercise
//
//  Created by Eddo Careera Iriyanto Putra on 19/11/22.
//

import SwiftUI

struct AnimationLaunchScreen: View {
    @State var offsetX = 0.0
    @State var offsetY = 0.0
    @State var showText = false
    @State var imageWidth = UIScreen.main.bounds.width / 4
    @State var imageHeight = UIScreen.main.bounds.width / 9
    
    let decreaseXRate = (UIScreen.main.bounds.width / 2) * (2.0/120)
    let decreaseYRate = (UIScreen.main.bounds.height / 2) * (2.0/120)
    let timer = Timer.publish(every: (2/120), on: .main, in: .common).autoconnect()
    
    var body: some View {
        if showText {
            VStack {
                HStack(spacing: 0) {
                    Text("Buah ")
                        .font(.system(size: 22))
                    Image("MagerLogo")
                        .resizable()
                        .scaledToFit()
                    Text("angga rasanya")
                        .font(.system(size: 22))
                    Spacer()
                }
                .frame(maxHeight: 20)
                HStack {
                    Text("segerrrr...")
                        .font(.system(size: 22))
                    Spacer()
                }
                Spacer()
                Button("Cakeep") {
                    
                }
            }
            .padding()
        } else {
            ZStack(alignment: .center) {
                Image("MagerLogo")
                    .resizable()
                    .frame(maxWidth: imageWidth, maxHeight: imageHeight)
                    .offset(x: offsetX, y: offsetY)
            }
            .onReceive(timer) { _ in
                withAnimation {
                    if offsetX >= (-UIScreen.main.bounds.width / 2.4) {
                        offsetX -= decreaseXRate
                        offsetY -= decreaseYRate
                        imageWidth -= imageWidth / 60
                        imageHeight -= imageHeight / 40
                    } else {
                        showText = true
                    }
                }
            }
        }
    }
}

struct AnimationLaunchScreen_Previews: PreviewProvider {
    static var previews: some View {
        AnimationLaunchScreen()
    }
}
