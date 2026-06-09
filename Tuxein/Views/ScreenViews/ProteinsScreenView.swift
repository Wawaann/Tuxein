//
//  ProteinsScreen.swift
//  Tuxein
//
//  Created by Ewan Bigotte on 02/06/2026.
//

import SwiftUI

struct ProteinsScreen: View {
    
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
                    ProteinsListView(proteinList: list, proteinsViewModel: proteinsViewModel)
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
    
    let service = MockProteinsService();
    let viewModel = ProteinsViewModel(service: service);
    
    ProteinsScreen(proteinsViewModel: viewModel)
        .task {
            await viewModel.fetchList();
        }
}
