//
//  ProteinsScreen.swift
//  Tuxein
//
//  Created by Ewan Bigotte on 02/06/2026.
//

import SwiftUI

struct ProteinsScreenView: View {
    
    var proteinsViewModel: ProteinsViewModel;
    @Binding var searchQuery: String;
    @Binding var showTabBar: Bool;
    
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
                            item.id.localizedCaseInsensitiveContains(searchQuery) ||
                            item.formula.localizedStandardContains(searchQuery)
                        }
                    
                    ProteinsListView(proteinList: filteredList, proteinsViewModel: proteinsViewModel, showTabBar: $showTabBar)
                case .error(let error):
                    Text(error)
                }
            }
            .navigationTitle(Text("Proteins"))
            .toolbarTitleDisplayMode(.inlineLarge)
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
        ProteinsScreenView(proteinsViewModel: viewModel, searchQuery: $searchQuery, showTabBar: $showTabBar)
            .task {
                await viewModel.fetchList();
            }
    }
}
