//
//  SearchScreenView.swift
//  Tuxein
//
//  Created by Ewan Bigotte on 02/06/2026.
//

import SwiftUI

struct SearchScreenView: View {
    
    @State private var searchQuery: String = "";
    var proteinsViewModel: ProteinsViewModel;
    
    var body: some View {
        NavigationStack {
            Group {
                switch proteinsViewModel.listState {
                case .idle:
                    Text("No data yet")
                case .loading:
                    ProgressView {
                        Text("Loading...")
                    }
                case .loaded(let list):
                    
                    let filteredList = searchQuery.isEmpty
                        ? list
                        : list.filter { item in
                            item.id.localizedCaseInsensitiveContains(searchQuery)
                        }
                    
                    ProteinsListView(proteinList: filteredList, proteinsViewModel: proteinsViewModel)
                case .error(let error):
                    Text(error)
                }
            }
            .navigationTitle(Text("Search proteins"))
            .toolbarTitleDisplayMode(.inlineLarge)
            .searchable(text: $searchQuery)
        }
    }
}

#Preview {
    
    let service = MockProteinsService();
    let viewModel = ProteinsViewModel(service: service);
    
    SearchScreenView(proteinsViewModel: viewModel)
        .task {
            await viewModel.fetchList();
        }
}
