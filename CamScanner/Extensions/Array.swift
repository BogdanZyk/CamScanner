//
//  Array.swift
//  CamScanner
//
//  Created by Богдан Зыков on 26.07.2022.
//



import UIKit
import PDFKit


extension Array where Element: UIImage {
    
      func makePDF()-> Data? {
        let pdfDocument = PDFDocument()
        for (index,image) in self.enumerated() {
            let pdfPage = PDFPage(image: image)
            pdfDocument.insert(pdfPage!, at: index)
        }
          return pdfDocument.dataRepresentation()
    }
}
