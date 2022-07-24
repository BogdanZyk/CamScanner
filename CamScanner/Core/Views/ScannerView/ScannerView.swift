//
//  ScannerView.swift
//  CamScanner
//
//  Created by Богдан Зыков on 24.07.2022.
//

import SwiftUI

struct ScannerView: View {
    @StateObject var scanVM = ScannerViewModel()
    @ObservedObject var homeVM: HomeViewModel
    @Binding var isShowScannerView: Bool
    @State private var showScanPreviewView: Bool = false
    var body: some View {
        NavigationView {
            ZStack{
                makeScannerView()
                    .ignoresSafeArea()
                NavigationLink(isActive: $showScanPreviewView) {
                    ScanPreviewView(homeVM: homeVM, scanVM: scanVM, isShowScannerView: $isShowScannerView)
                } label: {
                    EmptyView()
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct ScannerView_Previews: PreviewProvider {
    static var previews: some View {
        ScannerView(homeVM: HomeViewModel(), isShowScannerView: .constant(true))
    }
}


extension ScannerView{
    private func makeScannerView() -> CameraScannerView{
        

        CameraScannerView { returnImages in
            if let images = returnImages{
                scanVM.createScanModel(scannedPages: images)
                showScanPreviewView = true
            }
        } didCancelScanning: {
            isShowScannerView = false
        }
    }
}
