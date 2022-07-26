//
//  ScannerViewModel.swift
//  CamScanner
//
//  Created by Богдан Зыков on 24.07.2022.
//

import SwiftUI
import Foundation


final class ScannerViewModel: ObservableObject {
    
    let textRecognizer = TextRecognizer.instance
    
    @Published var currentScan: ScanModel?
    @Published var showLoader: Bool = false
    @Published var scanText: String = ""
    
    
//    @Published var mockScan: ScanModel? = ScanModel(name: "SCAN-\(Date().formatted(.dateTime))", scannedPages: [UIImage(systemName: "sun.haze.fill")!, UIImage(systemName: "cloud.drizzle.fill")!, UIImage(systemName: "cloud.drizzle.fill")!, UIImage(systemName: "cloud.drizzle.fill")!], content: "Test content!")
//
    

    
    public func deleteImage(index: Int){
        currentScan?.scannedPages?.remove(at: index)
    }
    
    public func createScanModel(scannedPages: [UIImage]?){
        if let scannedPages = scannedPages{
            let scan = ScanModel(name: "SCAN-\(Date().formatted(.dateTime))", scannedPages: scannedPages, content: nil)
            currentScan = scan
        }
    }
    
    public func textRecognize(completion: @escaping () -> Void){
        guard let images = currentScan?.scannedPages else {return}
        showLoader = true
        textRecognizer.recognizeTextFromImages(images: images) { [weak self] returnedText in
            guard let self = self else {return}
            self.currentScan?.content = returnedText
            self.scanText = returnedText ?? ""
            self.showLoader = false
            completion()
        }
    }
    
    public func saveRecognizeText(){
        currentScan?.content = scanText
    }
    
   
}





