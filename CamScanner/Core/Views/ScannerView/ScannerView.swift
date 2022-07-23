//
//  ScannerView.swift
//  CamScanner
//
//  Created by Богдан Зыков on 23.07.2022.
//

import SwiftUI
import VisionKit

struct ScannerView: UIViewControllerRepresentable{
   
    


    typealias UIViewControllerType = VNDocumentCameraViewController
    
    
    private let completionHandler: ([String]?) -> Void
    
    init(completion: @escaping ([String]?) -> Void){
        self.completionHandler = completion
    }
    
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let viewController = VNDocumentCameraViewController()
        viewController.delegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {
        
    }
    
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(completionHandler: completionHandler)
    }
    
   final class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate{
        private let completionHandler: ([String]?) -> Void
        
        init(completionHandler: @escaping ([String]?) -> Void) {
            self.completionHandler = completionHandler
        }
       
       func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
           let recognizer = TextRecognizer(cameraScan: scan)
           recognizer.recognizeText(withCompletionHandler: completionHandler)
       }
       
       func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
           completionHandler(nil)
       }
       
       func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
           print(error.localizedDescription)
           completionHandler(nil)
       }
    }

}

