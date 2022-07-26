//
//  HomeView.swift
//  CamScanner
//
//  Created by Богдан Зыков on 23.07.2022.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    @State private var createFolderAlert: Bool = false
    @State private var showDetailsView: Bool = false
    var body: some View {
            ZStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 10) {
                    navigationSection
                    foldersSection
                    Spacer()
                }
                foldersFilesView
                NavigationLink(isActive: $showDetailsView) {
                    FileDetailsView(homeVM: homeVM)
                } label: {
                    EmptyView()
                }
            }
            .background(Color.lightGray)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Cam Scanner")
                        .foregroundColor(.black)
                        .font(.title).bold()
                }
            }
            .textFieldAlert(isShowing: $createFolderAlert, text: $homeVM.createFolderName, title: "Create new folder", saveAction: homeVM.addFolder)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(HomeViewModel())
    }
}

extension HomeView{
    
    
    private var navigationSection: some View{
        HStack{
            Text("FOLDERS")
                .foregroundColor(.secondary)
            Spacer()
            Button {
                withAnimation(.easeOut(duration: 0.2)){
                    createFolderAlert.toggle()
                }
            } label: {
                Image(systemName: "folder.fill.badge.plus")
                    .foregroundColor(.accent)
                    .font(.title3)
            }
        }
        .padding(.top)
        .padding(.horizontal)
        .hLeading()
    }

    private var foldersSection: some View{
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15){
                if let rootFolder = homeVM.rootFolder{
                    rootFolderView(rootFolder: rootFolder)
                }
                
                if let folders = homeVM.rootFolder?.folders?.allObjects as? [Folder], !folders.isEmpty{
                    ForEach(folders) { folder in
                        folderCardView(folder: folder)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical)
        }
    }
    
    private func folderCardView(folder: Folder) -> some View{
        let isSelected: Bool = homeVM.currentSelectedFolder?.name == folder.name
        return folderCardViewComponent(name: folder.name, items: folder.items?.allObjects as? [Item])
            .overlay(alignment: .topTrailing) {
                Button {
                    withAnimation {
                        homeVM.deleteFolder(folder: folder)
                    }
                } label: {
                    Image(systemName: "trash.fill")
                        .foregroundColor(isSelected ? .white.opacity(0.5) : .secondaryGray.opacity(0.5))
                }
                .padding(10)
            }
    }
    
    private func rootFolderView(rootFolder: RootFolder) -> some View{
        folderCardViewComponent(name: rootFolder.name, items: rootFolder.items?.allObjects as? [Item])
    }
    
    private func folderCardViewComponent(name: String?, items: [Item]?) -> some View{
        let isSelected: Bool = homeVM.currentSelectedFolder?.name == name
       return VStack(alignment: .leading, spacing: 5){
            Image(systemName: "folder.fill")
                .font(.largeTitle)
                .foregroundColor(isSelected ? .white.opacity(0.7) : .accent.opacity(0.5))
            Text(name ?? "NO NAME")
                .font(.title3)
                .lineLimit(1)
           Text("\(items?.count ?? 0) item")
                .font(.subheadline)
                .foregroundColor(isSelected ? .white.opacity(0.5) : .secondaryGray)
        }
        .padding()
        .hLeading()
        .foregroundColor(isSelected ? .white : .black)
        .frame(width: 160, height: 120)
        .background{
            RoundedRectangle(cornerRadius: 20)
                .fill(isSelected ? Color.accent : .white)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 0)
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                homeVM.currentSelectedFolder = SelectFolderModel(name: name, items: items)
            }
        }
    }

    private var foldersFilesView: some View{
        VStack(alignment: .leading, spacing: 10){
                Text("FOLDERS FILES")
                    .foregroundColor(.secondary)
                    .padding(.leading)
                if let files = homeVM.currentSelectedFolder?.items, !files.isEmpty{
                    List {
                        ForEach(files) { file in
                            HStack(alignment: .top, spacing: 15){
                                if let data = file.images, let images = Helpers.unarchivedImageData(imageData: data), let image = images.first{
                                    Image(uiImage: image)
                                        .resizable()
                                        .frame(width: 80, height: 100)
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                    VStack(alignment: .leading, spacing: 0){
                                        Text(file.name ?? "No name")
                                            .font(.body).bold()
                                        Spacer()
                                        Label("\(images.count)", systemImage: "doc.on.doc.fill")
                                            .foregroundColor(Color.secondaryGray)
                                            .font(.subheadline)
                                    }
                                    .padding(.vertical, 10)
                                }
                                Spacer()
                                
                            }
                            .padding(.vertical, 5)
                            .onTapGesture {
                                homeVM.currentItem = file
                                showDetailsView.toggle()
                            }
                        }
                        .onDelete { index in
                            homeVM.deleteFile(index: index.first)
                        }
                        
                    }
                    .listStyle(.plain)
                }else{
                    noDocumentsView
                        .animation(nil, value: UUID())
                    Spacer()
                }
        }
        .padding([.top])
        
        .frame(maxWidth: .infinity, maxHeight: getRect().height / 1.55, alignment: .leading)
        .background(Color.white.clipShape(CustomCorners(corners: [.topRight, .topLeft], radius: 20)).shadow(color: .black.opacity(0.1), radius: 15, x: 0, y: 0))
    }
    
    private var noDocumentsView: some View{
        VStack(spacing: 15){
            Image(systemName: "doc.text.magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(height: 60)
                .foregroundColor(.secondaryGray)
            Text("No Documents this fold")
                .font(.title3).bold()
                .foregroundColor(.black)
            Text("You don't have any documents yet\nTap the button bellow to scan something")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondaryGray)
                
        }
        .hCenter()
        .padding(.top, 100)
        
    }
}


struct SelectFolderModel{
    var name: String?
    var items: [Item]?
}
