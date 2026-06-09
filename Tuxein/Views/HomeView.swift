//
//  HomeView.swift
//  Tuxein
//
//  Created by Ewan Bigotte on 29/05/2026.
//

import SwiftUI

struct HomeView: View {
    
    var proteinsViewModel: ProteinsViewModel = ProteinsViewModel();
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            selectedScreen
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            TabBar(selectedTab: $selectedTab)
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
            ProteinsScreen(proteinsViewModel: proteinsViewModel)
        case 1:
            FavoritesScreenView(proteinsViewModel: proteinsViewModel)
        case 2:
            SettingsScreenView()
        default:
            ProteinsScreen(proteinsViewModel: proteinsViewModel)
        }
    }
}

#Preview {
    
    let service = MockProteinsService();
    let viewModel = ProteinsViewModel(service: service);
    
    HomeView(proteinsViewModel: viewModel)
}
