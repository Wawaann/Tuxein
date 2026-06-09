//
//  LingandDetailView.swift
//  Tuxein
//
//  Created by Ewan Bigotte on 01/06/2026.
//

import SwiftUI

struct ProteinDetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    let protein: Protein
    var proteinsViewModel: ProteinsViewModel;
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Protein \"\(protein.id)\" 3D View")
            Text("Formula \"\(protein.formula)\"")
            
            Spacer()
        }
        .navigationTitle(protein.id)
        .toolbarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    print("Partage")
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
                
                FavoriteButton(proteinID: protein.id, proteinsViewModel: proteinsViewModel)
            }
        }
    }
}

#Preview {
    
    let service = MockProteinsService();
    let viewModel = ProteinsViewModel(service: service);
    let protein: Protein = .init(
        id: "001",
        type: "NON-POLYMER",
        formula: "C35 H42 F2 N2 O6"
        , weight: 624.75
    )
    NavigationStack {
        ProteinDetailView(protein: protein, proteinsViewModel: viewModel)
    }
}
