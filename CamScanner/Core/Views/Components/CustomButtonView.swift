//
//  CustomButtonView.swift
//  CamScanner
//
//  Created by Богдан Зыков on 24.07.2022.
//

import SwiftUI

struct CustomButtomView: View {
    var title: String
    var isDisabled: Bool = false
    var bgColor: Color = .accent
    var fonColor: Color = .white
    var action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            VStack{
                Text(title)
                    .font(.title3)
                    .foregroundColor(fonColor)
            }
            .hCenter()
            .frame(height: 45)
            .background(bgColor, in: RoundedRectangle(cornerRadius: 10))
        }
        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 0)
        .opacity(isDisabled ? 0.5 : 1)
        .disabled(isDisabled)
    }
}

struct CustomButtomView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CustomButtomView(title: "Next", action: {})
        }
        .padding()
    }
}
