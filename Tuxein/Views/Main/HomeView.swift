//
//  HomeView.swift
//  Tuxein
//
//  Created by Ewan Bigotte on 29/05/2026.
//

import SwiftUI

struct HomeView: View {
    
    var proteinsViewModel: ProteinsViewModel = ProteinsViewModel();
    
    var body: some View {
        Group {
            TabView {
                Tab("Proteins", systemImage: "atom") {
                    ProteinsScreen(proteinsViewModel: proteinsViewModel)
                }
                Tab("Favorites", systemImage: "heart") {
                    FavoritesScreenView(proteinsViewModel: proteinsViewModel)
                }
                Tab("Settings", systemImage: "gear") {
                    SettingsScreenView()
                }
                Tab(role: .search) {
                    SearchScreenView(proteinsViewModel: proteinsViewModel)
                }
            }
        }
        .task {
            await proteinsViewModel.fetchList();
        }
    }
}

#Preview {
    
    let service = MockProteinsService();
    let viewModel = ProteinsViewModel(service: service);
    
    HomeView(proteinsViewModel: viewModel)
}
