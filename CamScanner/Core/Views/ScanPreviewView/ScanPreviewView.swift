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
    @Binding var isShowScannerView: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            if let images = scanVM.currentScan?.scannedPages{
                VStack(spacing: 0){
                    imageTabView(images: images)
                    imagesViewSection(images: images)
                    saveCancelButtons
                }
                //.padding(.bottom, getRect().height / 10)
            }
               
        }
        .background(Color.lightGray)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(scanVM.currentScan?.name ?? "NO NAME")
                    .font(.headline)
                    .foregroundColor(.black)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    
                } label: {
                    Image(systemName: "square.and.pencil")
                        .foregroundColor(.accent)
                }

            }
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
                        .background{
                            ZStack{
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.white)
                                    .shadow(color: .black.opacity(0.1), radius: 15, x: 0, y: 0)
                                RoundedRectangle(cornerRadius: 5).stroke(lineWidth: 3).foregroundColor( index == currenImageIndex ? Color.accent : Color.clear)
                            }
                        }
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
