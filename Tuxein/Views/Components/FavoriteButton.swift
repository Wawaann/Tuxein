//
//  FavoriteButton.swift
//  Tuxein
//
//  Created by Ewan Bigotte on 04/06/2026.
//

import SwiftUI

struct FavoriteButton: View {
    
    let proteinID: String;
    let proteinsViewModel: ProteinsViewModel;
    
    var isFavorite: Bool {
        proteinsViewModel.isFavorites(proteinID: proteinID)
    }
    
    var body: some View {
        Button {
            proteinsViewModel.toggleFavorite(proteinId: proteinID)
        } label: {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .foregroundStyle(isFavorite ? Color.pink : Color.gray)
        }
    }
}

#Preview {
    
    let service: MockProteinsService = MockProteinsService();
    let viewModel: ProteinsViewModel = ProteinsViewModel(service: service);
    
    FavoriteButton(proteinID: "001", proteinsViewModel: viewModel)
}
