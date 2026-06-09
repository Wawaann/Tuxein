//
//  FavoritesScreenView.swift
//  Tuxein
//
//  Created by Ewan Bigotte on 02/06/2026.
//

import SwiftUI

struct FavoritesScreenView: View {
    
    let proteinsViewModel: ProteinsViewModel;
    var proteins: [Protein] {
        let favorites = proteinsViewModel.favoritesIDs;
        switch proteinsViewModel.listState {
        case .loaded(let proteins):
            return proteins.filter { favorites.contains($0.id) }
        default:
            return [];
        }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if proteins.isEmpty {
                    ContentUnavailableView("No Favorites yet", systemImage: "heart")
                } else {
                    ProteinsListView(proteinList: proteins, proteinsViewModel: proteinsViewModel)
                }
            }
            .navigationTitle("Favorites")
        }
    }
}

#Preview {
    
    let service = MockProteinsService();
    let viewModel = ProteinsViewModel(service: service);
    
    FavoritesScreenView(proteinsViewModel: viewModel)
}
