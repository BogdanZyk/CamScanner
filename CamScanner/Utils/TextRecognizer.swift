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
    
    static let instance = TextRecognizer()

    private init(){}
    
    private let queue = DispatchQueue(label: "scan_text", qos: .userInteractive, attributes: [], autoreleaseFrequency: .workItem)
    
    
    public func recognizeTextFromImages(images: [UIImage],  withCompletionHandler: @escaping (String?) -> Void){
        queue.async {
            [weak self] in
            guard let self = self else {return}
            let cgImage: [CGImage] = images.compactMap({$0.cgImage})
            
            let text = self.getRecognizeText(cgImages: cgImage)
            DispatchQueue.main.async {
                withCompletionHandler(text)
            }
        }
    }
    
    
    
    private func getRecognizeText(cgImages: [CGImage]) -> String{
        
        let imageAndRequests = cgImages.map({(image: $0, request: VNRecognizeTextRequest())})
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
        return content
    }
}



