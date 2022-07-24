//
//  ScannerView.swift
//  CamScanner
//
//  Created by Богдан Зыков on 23.07.2022.
//

import SwiftUI
import VisionKit

struct ScannerViewComponent: UIViewControllerRepresentable{
   


    typealias UIViewControllerType = VNDocumentCameraViewController
    
    
    var completionHandler: (ScanModel?) -> Void
    var didCancelScanning: () -> Void
    
   
    
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let viewController = VNDocumentCameraViewController()
        viewController.delegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {
        
    }
    
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(with: self)
    }
    
   final class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate{
       
       
       let scannerView: ScannerViewComponent
       
       init(with scannerView: ScannerViewComponent) {
           self.scannerView = scannerView
       }
       
       func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
           let recognizer = TextRecognizer(cameraScan: scan)
           recognizer.recognizeText2(withCompletionHandler: scannerView.completionHandler)
       }
       
       func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
           scannerView.didCancelScanning()
       }
       
       func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
           print(error.localizedDescription)
           scannerView.didCancelScanning()
       }
    }
}



