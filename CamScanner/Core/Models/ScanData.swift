//
//  ScanData.swift
//  CamScanner
//
//  Created by Богдан Зыков on 23.07.2022.
//

import Foundation
import SwiftUI

struct ScanModel: Identifiable{
    var id = UUID()
    var name: String?
    var scannedPages: [UIImage]?
    var content: String?
}
