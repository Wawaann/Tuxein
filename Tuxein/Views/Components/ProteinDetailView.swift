//
//  LingandDetailView.swift
//  Tuxein
//
//  Created by Ewan Bigotte on 01/06/2026.
//

import SwiftUI
import RealityKit

struct ProteinDetailView: View {
    
    let id: String;
    var proteinsViewModel: ProteinsViewModel;
    @Binding var showTabBar: Bool;
    
    var body: some View {
        Group {
            switch proteinsViewModel.proteinState {
            case .idle:
                Text("Y a rien")
            case .loading:
                ProgressView()
            case .loaded(let protein):
                Protein3DView(protein: protein)
            case .error(let error):
                Text(error)
            }
        }
        .onDisappear {
            showTabBar = true
        }
        .task {
            await proteinsViewModel.fetchProteinDetails(for: id);
        }
        .navigationTitle(id)
        .toolbarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    print("Partage")
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
                
                FavoriteButton(proteinID: id, proteinsViewModel: proteinsViewModel)
            }
        }
    }
}

#Preview {
    PreviewWrapper();
}

private struct PreviewWrapper: View {
    @State var viewModel: ProteinsViewModel = ProteinsViewModel(service: MockProteinsService());
    @State var showTabBar: Bool = false;
    
    var body: some View {
        Group {
            switch viewModel.proteinState {
            case .idle:
                Text("Y a rien")
            case .loading:
                ProgressView()
            case .loaded(let protein):
                NavigationStack {
                    ProteinDetailView(id: protein.id, proteinsViewModel: viewModel, showTabBar: $showTabBar)
                }
            case .error(let error):
                Text(error)
            }
        }
        .task {
            await viewModel.fetchList();
            await viewModel.fetchProteinDetails(for: "001");
        }
    }
}
