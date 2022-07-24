//
//  CameraScannerView.swift
//
//
//  Created by Богдан Зыков on 23.07.2022.
//

import SwiftUI
import VisionKit

struct CameraScannerView: UIViewControllerRepresentable{
   


    typealias UIViewControllerType = VNDocumentCameraViewController
    

    var completionHandler: ([UIImage]?) -> Void
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
       
       
       let scannerView: CameraScannerView
       
       init(with scannerView: CameraScannerView) {
           self.scannerView = scannerView
       }
       
       func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) { 
        
           let images: [UIImage]? = (0..<scan.pageCount).compactMap({
               return scan.imageOfPage(at:$0)
           })
           scannerView.completionHandler(images)
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







