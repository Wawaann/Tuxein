//
//  FavoritesScreenView.swift
//  Tuxein
//
//  Created by Ewan Bigotte on 02/06/2026.
//

import SwiftUI

struct FavoritesScreenView: View {
    
    let proteinsViewModel: ProteinsViewModel;
    var proteinsList: [Protein] {
        let favorites = proteinsViewModel.favoritesIDs;
        switch proteinsViewModel.listState {
        case .loaded(let proteins):
            return proteins.filter { favorites.contains($0.id) }
        default:
            return [];
        }
    }
    @Binding var searchQuery: String;
    @Binding var showTabBar: Bool;
    
    var body: some View {
        NavigationStack {
            Group {
                if proteinsList.isEmpty {
                    ContentUnavailableView("No Favorites yet", systemImage: "heart")
                } else {
                    
                    let filteredList = searchQuery.isEmpty
                        ? proteinsList
                        : proteinsList.filter { item in
                            item.id.localizedCaseInsensitiveContains(searchQuery) ||
                            item.formula.localizedStandardContains(searchQuery)
                        }
                    
                    ProteinsListView(proteinList: filteredList, proteinsViewModel: proteinsViewModel, showTabBar: $showTabBar)
                }
            }
            .navigationTitle("Favorites")
        }
    }
}

#Preview {
    PreviewWrapper()
}

private struct PreviewWrapper: View {
    @State private var searchQuery: String = "";
    @State private var showTabBar: Bool = false;
    let viewModel: ProteinsViewModel;

    init() {
        let service = MockProteinsService();
        self.viewModel = ProteinsViewModel(service: service);
    }

    var body: some View {
        FavoritesScreenView(proteinsViewModel: viewModel, searchQuery: $searchQuery, showTabBar: $showTabBar)
            .task {
                await viewModel.fetchList();
            }
    }
}
