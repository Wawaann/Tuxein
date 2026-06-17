//
//  LingandsListView.swift
//  Tuxein
//
//  Created by Ewan Bigotte on 31/05/2026.
//

import SwiftUI
import UIKit

struct SelectedProtein: Identifiable {
    let protein: Protein;
    var id: String { protein.id };
}

struct ProteinsListView: View {

    var proteinList: [Protein];
    var proteinsViewModel: ProteinsViewModel;
    @Binding var showTabBar: Bool;
    
    var body: some View {
        if proteinList.isEmpty {
//            ContentUnavailableView("No protein found", image: "ProteinIcon")
            ContentUnavailableView {
                Image("ProteinIcon")
                    .resizable()
                    .frame(width: 100, height: 100)
                Text("No protein found")
                    .padding(.top, 12)
            }
            .padding(.bottom, 20)
        } else {
            List(proteinList) { protein in
                ProteinRow(protein: protein, proteinsViewModel: proteinsViewModel, showTabBar: $showTabBar)
            }
        }
    }
}

private struct ProteinRow: View {
    
    var protein: Protein;
    var proteinsViewModel: ProteinsViewModel;
    @Binding var showTabBar: Bool;
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            NavigationLink {
                ProteinDetailView(
                    id: protein.id,
                    proteinsViewModel: proteinsViewModel,
                    showTabBar: $showTabBar
                )
                    .onAppear {
                        showTabBar = false
                        UIApplication.shared.hideKeyboard()
                    }
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

extension UIApplication {
    func hideKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil);
    }
}

#Preview {
    PreviewWrapper()
}

private struct PreviewWrapper: View {
    let viewModel = ProteinsViewModel(service: DefaultProteinsService());
    @State private var showTabBar: Bool = true;
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.listState {
                case .idle:
                    Text("No data yet")
                case .loading:
                    ProgressView {
                        Text("Loading...")
                    }
                case .loaded(let list):
                    ProteinsListView(proteinList: list, proteinsViewModel: viewModel, showTabBar: $showTabBar)
                case .error(let error):
                    Text(error)
                }
            }
            .navigationTitle(Text("Proteins"))
            .toolbarTitleDisplayMode(.inlineLarge)
        }
        .task {
            await viewModel.fetchList()
        }
    }
}
