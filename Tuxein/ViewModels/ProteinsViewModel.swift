//
//  LingandsList.swift
//  Tuxein
//
//  Created by Ewan Bigotte on 29/05/2026.
//

import Foundation
import Observation

@Observable
class ProteinsViewModel {
    
    // MARK: ViewModel variables and initializer

    var listState: LoadingState<[Protein]> = .idle;
    var proteinState: LoadingState<Protein> = .idle;
    
    private(set) var favoritesIDs: Set<String> = [];

    var service: ProteinsService;
    
    init (service: ProteinsService = DefaultProteinsService()) {
        self.service = service;
    }
    
    // MARK: Fetch protein list
    
    func fetchList() async {
        
        guard !listState.isLoading || listState.error != nil else { return }
                
        self.listState = .loading;
        
        do {
            let list = try await self.service.fetchList();
            
            self.listState = .loaded(list);
        } catch let error {
            self.listState = .error("\(error)");
        }
    }
    
    // MARK: Fetch protein details
    
    func fetchProteinDetails(for identifier: String) async {
        guard !proteinState.isLoading else { return }
        
        let normalizedIdentifier = identifier.uppercased();
        self.proteinState = .loading;
        
        do {
            let (atoms, bonds) = try await self.service.fetchProteinDetails(for: normalizedIdentifier);
            
            guard var protein = self.listState.data?.first(where: { $0.id == normalizedIdentifier }) else {
                throw ProteinsError.invalidDecoding;
            }
            
            protein.atoms = atoms;
            protein.bonds = bonds;
            
            print(protein);
            
            self.proteinState = .loaded(protein);
        } catch let error {
            self.proteinState = .error("\(error)");
        }
    }
    
    // MARK: Favorites function
    
    func load() {
        self.favoritesIDs = self.service.load();
    }
    
    private func save() {
        self.service.save(favoriteIDs: self.favoritesIDs);
    }
    
    func toggleFavorite(proteinId: String) {
        let isContained = self.favoritesIDs.contains(proteinId);
        
        if (isContained) {
            self.favoritesIDs.remove(proteinId);
        } else {
            self.favoritesIDs.insert(proteinId);
        }
    }
    
    func isFavorites(proteinID: String) -> Bool {
        return self.favoritesIDs.contains(proteinID);
    }
}

import Playgrounds

#Playground {
    let service = MockProteinsService();
    let proteins = ProteinsViewModel(service: service);
    
    await proteins.fetchList();
    await proteins.fetchProteinDetails(for: "001");
    
    switch proteins.proteinState {
    case .idle: print("idle");
    case .loading: print("loading");
    case .loaded(let protein):
        print(protein)
    case .error(let error): print(error);
    }
}
