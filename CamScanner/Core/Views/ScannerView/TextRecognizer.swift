//
//  TextRecognizer.swift
//  CamScanner
//
//  Created by Богдан Зыков on 23.07.2022.
//

import Foundation
import VisionKit
import Vision


final class TextRecognizer{
    
    let cameraScan: VNDocumentCameraScan
    
    init(cameraScan: VNDocumentCameraScan){
        self.cameraScan = cameraScan
    }
    
    private let queue = DispatchQueue(label: "scan_codes", qos: .default, attributes: [], autoreleaseFrequency: .workItem)
    
    func recognizeText(withCompletionHandler: @escaping ([String]?) -> Void){
        queue.async {
            
            var scannedPages = [UIImage]()
            
            let images: [CGImage] = (0..<self.cameraScan.pageCount).compactMap({
                let uiImage = self.cameraScan.imageOfPage(at:$0)
                scannedPages.append(uiImage)
                return uiImage.cgImage
                
            })

            
      
            let imageAndRequests = images.map({(image: $0, request: VNRecognizeTextRequest())})
            let textPerPage = imageAndRequests.map { (image, request) -> String  in
                let handler = VNImageRequestHandler(cgImage: image, options: [:])
                do{
                    try handler.perform([request])
                    guard let observations = request.results else {return ""}
                    return observations.compactMap({$0.topCandidates(1).first?.string}).joined(separator: "\n")
                }
                catch {
                    print(error.localizedDescription)
                    return ""
                }
            }
            DispatchQueue.main.async {
                withCompletionHandler(textPerPage)
            }
        }
    }
    
    
    func recognizeText2(withCompletionHandler: @escaping (ScanModel?) -> Void){
        queue.async {
            let images: [CGImage] = (0..<self.cameraScan.pageCount).compactMap({
                return self.cameraScan.imageOfPage(at:$0).cgImage
            })

            let scan = self.getScanModel(images: images)
            DispatchQueue.main.async {
                withCompletionHandler(scan)
            }
        }
    }
    
    
    
    private func getScanModel(images: [CGImage]) -> ScanModel{
        
        let scannedPages = images.compactMap({UIImage(cgImage: $0)})
        
        let imageAndRequests = images.map({(image: $0, request: VNRecognizeTextRequest())})
        let textPerPage = imageAndRequests.map { (image, request) -> String  in
            let handler = VNImageRequestHandler(cgImage: image, options: [:])
            do{
                try handler.perform([request])
                guard let observations = request.results else {return ""}
                return observations.compactMap({$0.topCandidates(1).first?.string}).joined(separator: "\n")
            }
            catch {
                print(error.localizedDescription)
                return ""
            }
        }
        let content = textPerPage.joined(separator: "\n").trimmingCharacters(in: .whitespaces)
        return ScanModel(name: "SCAN-\(Date().formatted(.dateTime))", scannedPages: scannedPages, content: content)
    }
}



