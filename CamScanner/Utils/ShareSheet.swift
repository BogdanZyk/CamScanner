//
//  ShareSheet.swift
//  CamScanner
//
//  Created by Богдан Зыков on 24.07.2022.
//


import SwiftUI


struct ShareSheet: UIViewControllerRepresentable{
    
    var items: [Any]
    
    func makeUIViewController(context: Context) -> some UIActivityViewController {
        let viewComtroller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return viewComtroller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

