//
//  EditScanTextView.swift
//  CamScanner
//
//  Created by Богдан Зыков on 24.07.2022.
//

import SwiftUI

struct EditScanTextView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var scanVM: ScannerViewModel
    @State private var isChange: Bool = false
    var body: some View {
        VStack{
            navigationView
            TextEditor(text: $scanVM.scanText)
        }
        .onChange(of: scanVM.scanText) { _ in
            isChange = true
        }
    }
}

struct EditScanTextView_Previews: PreviewProvider {
    static var previews: some View {
        EditScanTextView(scanVM: ScannerViewModel())
    }
}


extension EditScanTextView{
    private var navigationView: some View{
        VStack{
            HStack{
                Button("Cancel", role: .cancel, action: {dismiss()})
                Spacer()
                Text("Edit text")
                    .font(.title3).bold()
                Spacer()
                Button("Save", action: {
                    scanVM.saveRecognizeText()
                    dismiss()
                })
                .disabled(!isChange)
                
            }
            .padding(.horizontal)
            Divider()
            
        }
        .padding(.top, 20)
        .background(Color.lightGray)
        
    }
}
