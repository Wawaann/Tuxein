//
//  LingandsListView.swift
//  Tuxein
//
//  Created by Ewan Bigotte on 31/05/2026.
//

import SwiftUI

struct SelectedProtein: Identifiable {
    let protein: Protein;
    var id: String { protein.id };
}

struct ProteinsListView: View {

    var proteinList: [Protein];
    var proteinsViewModel: ProteinsViewModel;
    
    // @State private var selectedProtein: SelectedProtein?;
    
    var body: some View {
            List(proteinList) { protein in
                // ProteinRow(selectedProtein: $selectedProtein, protein: protein, proteinsViewModel: proteinsViewModel)
                ProteinRow(protein: protein, proteinsViewModel: proteinsViewModel)
            }
            // .fullScreenCover(item: $selectedProtein) { selectedProtein in
            //     NavigationStack {
            //         ProteinDetailView(protein: selectedProtein.protein, proteinsViewModel: proteinsViewModel)
            //     }
            // }
    }
}

private struct ProteinRow: View {
    
    // @Binding var selectedProtein: SelectedProtein?;
    var protein: Protein;
    var proteinsViewModel: ProteinsViewModel;
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Button {
            //     selectedProtein = SelectedProtein(protein: protein)
            // } label: {
            NavigationLink {
                ProteinDetailView(protein: protein, proteinsViewModel: proteinsViewModel)
            } label: {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .firstTextBaseline, spacing: 12) {
                        Text(protein.id)
                            .font(.headline)
                            .foregroundStyle(Color.primary)
                        
                        Spacer()
                        
                        Text(protein.type.lowercased())
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Color.accentColor)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.accentColor.opacity(0.12), in: Capsule())
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        ProteinInfoRow(label: "Formula", value: protein.formula)
                        ProteinInfoRow(label: "Weight", value: protein.weight.formatted(.number.precision(.fractionLength(2))))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
            }
            // .buttonStyle(.plain)
            
            HStack {
                Spacer()
                
                FavoriteButton(proteinID: protein.id, proteinsViewModel: proteinsViewModel)
                    .buttonStyle(.borderless)
            }
        }
        .padding(14)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
    }
}

private struct ProteinInfoRow: View {
    let label: String;
    let value: String;
    
    var body: some View {
        HStack(spacing: 6) {
            Text(label)
                .font(.caption)
                .foregroundStyle(Color.secondary)
            
            Text(value)
                .font(.caption)
                .foregroundStyle(Color.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
    }
}

#Preview {
    
    let service = MockProteinsService();
    let list = service.fetchListPreview();
    let viewModel = ProteinsViewModel(service: service);
    
    NavigationStack {
        ProteinsListView(proteinList: list, proteinsViewModel: viewModel)
            .navigationTitle(Text("Proteins"))
            .toolbarTitleDisplayMode(.inlineLarge)
    }
}
