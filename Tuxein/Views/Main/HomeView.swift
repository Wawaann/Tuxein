//
//  HomeView.swift
//  Tuxein
//
//  Created by Ewan Bigotte on 29/05/2026.
//

import SwiftUI

/*

 IMPORTANT:
    - Faire en sorte de pouvoir chercher dans FavoriteScreenView en
      implémentant la même logique que ProteinScreenView tout en ajoutant
      un cas ou rien n'est trouvé pour les deux View
    - Gérer les cas des proteines spécial comme Ni ou Hg en gérant le cas
      ou il n'y a qu'un atome.
*/

struct HomeView: View {
    
    var proteinsViewModel: ProteinsViewModel = ProteinsViewModel();
    @State private var selectedTab = 0;
    @State private var searchQuery: String = "";
    @State private var showTabBar: Bool = true;
    
    var body: some View {
        selectedScreen
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: .bottomLeading) {
                TabBar(selectedTab: $selectedTab, searchText: $searchQuery, showTabBar: $showTabBar)
                    .padding(.bottom, 8)
            }
            .task {
                await proteinsViewModel.fetchList();
            }
    }
    
    @ViewBuilder
    private var selectedScreen: some View {
        switch selectedTab {
        case 0:
            ProteinsScreenView(proteinsViewModel: proteinsViewModel, searchQuery: $searchQuery, showTabBar: $showTabBar)
        case 1:
            FavoritesScreenView(proteinsViewModel: proteinsViewModel, searchQuery: $searchQuery, showTabBar: $showTabBar)
        case 2:
            SettingsScreenView()
        default:
            ProteinsScreenView(proteinsViewModel: proteinsViewModel, searchQuery: $searchQuery, showTabBar: $showTabBar)
        }
    }
}

#Preview {
    
    let service = MockProteinsService();
    let viewModel = ProteinsViewModel(service: service);
    
    HomeView(proteinsViewModel: viewModel)
}
