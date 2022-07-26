//
//  FileDetailsView.swift
//  CamScanner
//
//  Created by Богдан Зыков on 25.07.2022.
//

import SwiftUI

struct FileDetailsView: View {
    @StateObject private var fileVM = FileDetailsViewModel()
    @ObservedObject var homeVM: HomeViewModel
    @State private var showShare: Bool = false
    @State private var showEditTextView: Bool = false
    var body: some View {
        VStack(spacing: 0){
            if !fileVM.currentFileUIImages.isEmpty{
                ScrollView(.vertical, showsIndicators: true) {
                    ForEach(fileVM.currentFileUIImages.indices, id: \.self) { index in
                        Image(uiImage: fileVM.currentFileUIImages[index])
                            .resizable()
                            .frame(height: getRect().height / 1.5)
                    }
                    .padding(.top)
                }
            }
        }
        .overlay{
            if fileVM.showLoader || fileVM.showScanLoader{
                loaderView
            }
        }
        .sheet(isPresented: $showShare) {
            if let pdfURL = fileVM.pdfURL{
                ShareSheet(items: [pdfURL])
            }
        }
        .sheet(isPresented: $showEditTextView) {
            EditScanTextView(scanText: $fileVM.scanText)
        }
        .onAppear{
            fileVM.currentFile = homeVM.currentItem
            fileVM.unarchivedImageData()
        }
        .onChange(of: fileVM.showLoader, perform: { showLoader in
            if !showLoader{
                showShare = true
            }
        })
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                navigationTitle
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                editNavButton
            }
            ToolbarItem(placement: .bottomBar) {
                bottomBarContent
            }
        }
        .disabled(fileVM.showLoader || fileVM.showScanLoader)
    }
}

struct FileDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FileDetailsView(homeVM: HomeViewModel())
        }
    }
}


extension FileDetailsView{
    
    private var navigationTitle: some View{
        Text(homeVM.currentItem?.name ?? "No name")
            .font(.title3).bold()
    }
    
    private var editNavButton: some View{
        Button("Edit") {
            
        }
    }

    private var bottomBarContent: some View{
        HStack{
            TolbarActionButton(title: "Extract text", systemImage: "text.viewfinder") {
                fileVM.textRecognize {
                    showEditTextView.toggle()
                }
            }
            
            Spacer()
            
                TolbarActionButton(title: "Share", systemImage: "square.and.arrow.up.on.square") {
                    fileVM.createPdf()
                }
            
            
            Spacer()
            TolbarActionButton(title: "Create PDF", systemImage: "doc.badge.plus") {
                fileVM.createPdf()
            }
        }
        .padding(.top)
    }
    
    
    private var loaderView: some View{
        VStack(spacing: 20){
            ProgressView().scaleEffect(1.5)
            Text(fileVM.showScanLoader ? "Extract text" : "Create PDF")
        }
        .frame(width: 150, height: 150)
        .background(Color.lightGray, in: RoundedRectangle(cornerRadius: 20))
    }
}



struct TolbarActionButton: View{
    let title: String
    let systemImage: String
    let action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            VStack(spacing: 5){
                Image(systemName: systemImage)
                Text(title)
                    .font(.caption)
                    .bold()
            }
        }
    }
}
