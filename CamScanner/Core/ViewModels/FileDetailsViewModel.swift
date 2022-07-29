//
//  FileDetailsViewModel.swift
//  CamScanner
//
//  Created by Богдан Зыков on 26.07.2022.
//

import Foundation
import SwiftUI
import PDFKit

final class FileDetailsViewModel: ObservableObject{
    
    let textRecognizer = TextRecognizer.instance
    
    @Published var currentFile: Item?
    @Published var currentFileUIImages = [UIImage]()
    @Published var showLoader: Bool = false
    @Published var showScanLoader: Bool = false
    
    @Published var scanText: String = ""
    
    public var pdfURL: URL?
    
    
    public func unarchivedImageData(){
        guard let imagesData = currentFile?.images, let images = Helpers.unarchivedImageData(imageData: imagesData) else {return}
        self.currentFileUIImages.append(contentsOf: images)
    }
    
    
    public func createPdf(){
        showLoader = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.createPDFFile()
            self.showLoader = false
        }
    }
    
    

    
    private func createPDFFile(){
        
        let temporaryFolder = FileManager.default.temporaryDirectory
        let fileName = "\(currentFile?.name ?? "No name").pdf"
        let temporaryFileURL = temporaryFolder.appendingPathComponent(fileName)
            
        let pdf = currentFileUIImages.makePDF()
        
        do {
            try pdf?.write(to: temporaryFileURL, options: .atomic)
        } catch  {
            print(error.localizedDescription)
        }
        self.pdfURL = temporaryFileURL
    }
    
    
    
    public func textRecognize(completion: @escaping () -> Void){
        let images = currentFileUIImages
        showScanLoader = true
        textRecognizer.recognizeTextFromImages(images: images) { [weak self] returnedText in
            guard let self = self else {return}
            self.showScanLoader = false
            self.scanText = returnedText ?? ""
            self.showLoader = false
            completion()
        }
    }
    
}



