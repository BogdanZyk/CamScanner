//
//  SettingsView.swift
//  CamScanner
//
//  Created by Богдан Зыков on 24.07.2022.
//

import SwiftUI

struct SettingsView: View {
    @State private var items = [Any]()
    @State private var showShare: Bool = false
    var body: some View {
        ZStack{
            
            List{
                Section {
                    Label("Upgrade Premium", systemImage: "crown")
                    Label("Restore Purchases", systemImage: "arrow.clockwise")
                } header: {
                    Text("In-App Purchases")
                }
                Section {
                    Label("Upgrade Premium", systemImage: "circle.grid.3x3.fill")
                    Label("Restore Purchases", systemImage: "lock.slash")
                } header: {
                    Text("App Passcode")
                }
                Section {
                    Label("Rate App", systemImage: "star")
                    Label("Share App", systemImage: "square.and.arrow.up")
                } header: {
                    Text("Spead the word")
                }
                Section {
                    Label("E-Mail us", systemImage: "envelope.badge")
                    Label("Term of Use", systemImage: "doc.text")
                    Label("Privacy Policy", systemImage: "hand.raised")
                } header: {
                    Text("Support & privacy")
                }
            }
            .listStyle(.insetGrouped)
        }
        .navigationTitle("Settings")
        .background(Color.lightGray)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView()
        }
    }
}
