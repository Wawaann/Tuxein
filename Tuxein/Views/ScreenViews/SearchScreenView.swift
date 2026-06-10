//
//  SearchScreenView.swift
//  Tuxein
//
//  Created by Ewan Bigotte on 02/06/2026.
//

import SwiftUI

struct SearchScreenView: View {
    
    @Binding var searchQuery: String;
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
                                || item.type.localizedCaseInsensitiveContains(searchQuery)
                                || item.formula.localizedCaseInsensitiveContains(searchQuery)
                        }
                    
                    ProteinsListView(proteinList: filteredList, proteinsViewModel: proteinsViewModel)
                case .error(let error):
                    Text(error)
                }
            }
            .navigationTitle(Text("Search proteins"))
            .toolbarTitleDisplayMode(.inlineLarge)
        }
    }
}

#Preview {
    PreviewWrapper()
}

private struct PreviewWrapper: View {
    @State private var searchQuery: String = "";
    let viewModel: ProteinsViewModel;

    init() {
        let service = MockProteinsService();
        self.viewModel = ProteinsViewModel(service: service);
    }

    var body: some View {
        SearchScreenView(searchQuery: $searchQuery, proteinsViewModel: viewModel)
            .task {
                await viewModel.fetchList();
            }
    }
}
