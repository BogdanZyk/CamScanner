//
//  ContentView.swift
//  CamScanner
//
//  Created by Богдан Зыков on 23.07.2022.
//

import SwiftUI

struct ContentView: View {
    @State private var showScannerSheet: Bool = false
    @State private var texts: [ScanData] = []
    var body: some View {
        NavigationView{
            VStack{
                if !texts.isEmpty{
                    List{
                        ForEach(texts) { text in
                            NavigationLink {
                                ScrollView{Text(text.content)}
                            } label: {
                                Text(text.content)
                                    .lineLimit(1)
                            }

                        }
                    }
                }else{
                    Text("No documents")
                }
            }
            .navigationTitle("CamScanner")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showScannerSheet.toggle()
                    } label: {
                        Image(systemName: "doc.text.viewfinder")
                            .font(.title3)
                    }
                }
            }
            .sheet(isPresented: $showScannerSheet) {
                makeScannerView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension ContentView{
    
    
    private func makeScannerView() -> ScannerView{
        ScannerView { textPerPage in
            if let outputText = textPerPage?.joined(separator: "\n").trimmingCharacters(in: .whitespaces){
                let newScanDate = ScanData(content: outputText)
                self.texts.append(newScanDate)
            }
            self.showScannerSheet = false
        }
    }
}
