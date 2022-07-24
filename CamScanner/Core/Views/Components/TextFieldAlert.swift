//
//  TextFieldAlert.swift
//  CamScanner
//
//  Created by Богдан Зыков on 24.07.2022.
//

import SwiftUI

struct TextFieldAlert<Presenting>: View where Presenting: View {

    @Binding var isShowing: Bool
    @Binding var text: String
    let presenting: Presenting
    let title: String
    let saveAction: () -> Void
    var body: some View {
        GeometryReader { (deviceSize: GeometryProxy) in
            ZStack {
                self.presenting
                    .disabled(isShowing)
                VStack {
                    Text(title)
                        .font(.title3)
                        .bold()
                    TextField("", text: $text)
                        .padding(5)
                        .background(Color.white, in: RoundedRectangle(cornerRadius: 10))
                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 0)
                    Divider()
                    HStack(spacing: 0) {
                        Button(action: {
                            
                            withAnimation(.easeOut(duration: 0.2)){
                                isShowing.toggle()
                            }
                        }) {
                            Text("Cancel")
                        }
                        Spacer()
                        Button(action: {
                            saveAction()
                            withAnimation(.easeOut(duration: 0.2)){
                                isShowing.toggle()
                            }
                        }) {
                            Text("Save")
                                .bold()
                        }
                    }
                    .font(.body)
                    .foregroundColor(.accent)
                    .padding(.horizontal, 40)
                }
                .padding()
                .background{
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.15), radius: 40, x: 0, y: 0)
                }
                .frame(
                    width: deviceSize.size.width*0.7,
                    height: deviceSize.size.height*0.7
                )
                .opacity(self.isShowing ? 1 : 0)
            }
        }
    }

}
