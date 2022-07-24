//
//  ScannerViewModel.swift
//  CamScanner
//
//  Created by Богдан Зыков on 24.07.2022.
//

import SwiftUI
import Foundation


final class ScannerViewModel: ObservableObject {
    
    
    @Published var currentScan: ScanModel?
    
    
//    @Published var mockScan: ScanModel? = ScanModel(name: "SCAN-\(Date().formatted(.dateTime))", scannedPages: [UIImage(systemName: "sun.haze.fill")!, UIImage(systemName: "cloud.drizzle.fill")!, UIImage(systemName: "cloud.drizzle.fill")!, UIImage(systemName: "cloud.drizzle.fill")!], content: "Test content!")
    
    
    
    public func deleteImage(index: Int){
        currentScan?.scannedPages?.remove(at: index)
    }
}




struct ScanModel: Identifiable{
    var id = UUID()
    var name: String?
    var scannedPages: [UIImage]?
    var content: String?
}
