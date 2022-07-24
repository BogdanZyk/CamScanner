//
//  ScanPreviewView.swift
//  CamScanner
//
//  Created by Богдан Зыков on 24.07.2022.
//

import SwiftUI

struct ScanPreviewView: View {
    @ObservedObject var homeVM: HomeViewModel
    @ObservedObject var scanVM: ScannerViewModel
    @State private var currenImageIndex: Int = 0
    @State private var showEditTextView: Bool = false
    @Binding var isShowScannerView: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            if let images = scanVM.currentScan?.scannedPages{
                VStack(spacing: 0){
                    imageTabView(images: images)
                    imagesViewSection(images: images)
                }
            }
        }
        .background(Color.lightGray)
        .overlay{
            if scanVM.showLoader{
                loaderView
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                navigationTitle
            }
            ToolbarItemGroup(placement: .bottomBar) {
                bottomBarContent
                
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                changeFileNameButton
            }
        }
        .sheet(isPresented: $showEditTextView) {
            EditScanTextView(scanVM: scanVM)
        }
    }
}

struct ScanPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ScanPreviewView(homeVM: HomeViewModel(), scanVM: ScannerViewModel(), isShowScannerView: .constant(false))
        }
    }
}


extension ScanPreviewView{
    
    private var navigationTitle: some View{
        Text(scanVM.currentScan?.name ?? "NO NAME")
            .font(.headline)
            .foregroundColor(.black)
    }
 
    private var changeFileNameButton: some View{
        Button {
            
        } label: {
            Image(systemName: "square.and.pencil")
                .foregroundColor(.accent)
        }
    }
    
    private var bottomBarContent: some View{
        HStack(spacing: 0){
            closeButton
            Spacer()
            recognizeButton
            Spacer()
            saveButton
        }
    }
    private var closeButton: some View{
        Button {
            isShowScannerView = false
        } label: {
           Image(systemName: "xmark")
                .padding(5)
        }
        .buttonStyle(.borderedProminent)
        .tint(.secondaryGray.opacity(0.8))
    }
    
    private var recognizeButton: some View{
        Button {
            scanVM.textRecognize {
                showEditTextView.toggle()
            }
        } label: {
            VStack(spacing: 5){
                Image(systemName: "text.viewfinder")
                Text("Recognize text")
                    .font(.caption)
                    .bold()
            }
        }
        .disabled(scanVM.showLoader)
    }
    
    private var saveButton: some View{
        Button {
            if let scan = scanVM.currentScan{
                homeVM.addFile(scan: scan)
                isShowScannerView = false
            }
        } label: {
           Image(systemName: "checkmark")
                .padding(5)
        }
        .buttonStyle(.borderedProminent)
    }
    
    private var loaderView: some View{
        VStack(spacing: 15){
            ProgressView().scaleEffect(1.3)
            Text("Text recognition...")
                .font(.subheadline).bold()
        }
        .padding()
        .background{
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.lightGray)
                .shadow(color: .black.opacity(0.3), radius: 100, x: 0, y: 0)
        }
    }
}


extension ScanPreviewView{
    
    private func imageTabView(images: [UIImage]) -> some View{
        TabView(selection: $currenImageIndex) {
            ForEach(images.indices, id: \.self) { index in
                Image(uiImage: images[index])
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: getRect().height / 2)
                    .background{
                       RoundedRectangle(cornerRadius: 5)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.1), radius: 15, x: 0, y: 0)
                    }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .padding(.horizontal, 30)
    }
    
    private func imagesViewSection(images: [UIImage]) -> some View{
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15){
                ForEach(images.indices, id: \.self) { index in
                    Image(uiImage: images[index])
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 150)
                        .background(Color.white, in: RoundedRectangle(cornerRadius: 5))
                        .background( index == currenImageIndex ? Color.accent : Color.clear, in: RoundedRectangle(cornerRadius: 5).stroke(lineWidth: 5))
                        .overlay(alignment: .topTrailing){
                            Button {
                                withAnimation {
                                    scanVM.deleteImage(index: index)
                                }
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(Color.secondaryGray)
                            }
                            .padding(5)
                        }
                    
                        .onTapGesture {
                            withAnimation {
                                currenImageIndex = index
                            }
                        }
                }
            }
            .padding(.vertical)
            .padding(.horizontal, 30)
        }
    }
    
    private var saveCancelButtons: some View{
        HStack(spacing: 30){
            CustomButtomView(title: "Cancel", bgColor: .secondaryGray, action: {
                isShowScannerView = false
            })
            CustomButtomView(title: "Save", action: {
                if let scan = scanVM.currentScan{
                    homeVM.addFile(scan: scan)
                    isShowScannerView = false
                }
            })
        }
        .padding(.vertical)
        .padding(.horizontal, 30)
    }
    
}
