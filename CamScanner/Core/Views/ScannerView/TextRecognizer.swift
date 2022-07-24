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
            let images: [CGImage] = (0..<self.cameraScan.pageCount).compactMap({
                self.cameraScan.imageOfPage(at:$0).cgImage
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
}
