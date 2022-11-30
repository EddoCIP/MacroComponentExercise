//
//  CustomButton.swift
//  MacroComponentExercise
//
//  Created by Eddo Careera Iriyanto Putra on 23/11/22.
//

import SwiftUI

struct CustomButton: View {
    var body: some View {
        ZStack(alignment: .trailingFirstTextBaseline) {
            HStack {
                Button {
                } label: {
                    Image(systemName: "person")
                        .foregroundColor(Color.white)
                }
                .padding(8)
                .background(Color.gray)
                .cornerRadius(36)
            }
            Circle()
                .frame(width: 10, height: 10)
                .padding(.bottom)
        }
    }
}

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton()
    }
}
