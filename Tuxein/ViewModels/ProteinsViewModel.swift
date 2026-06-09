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
    
    var listState: LoadingState<[Protein]> = .idle;
    var proteinState: LoadingState<String> = .idle;
    
    private(set) var favoritesIDs: Set<String> = [];

    var service: ProteinsService;
    
    init (service: ProteinsService = DefaultProteinsService()) {
        self.service = service;
    }
    
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
    
    func fetchProteinDetails(for identifier: String) async {
        guard !proteinState.isLoading || proteinState.error != nil else { return }
                
        self.proteinState = .loading;
        
        do {
            let file = try await self.service.fetchProteinDetails(for: identifier);
            
            self.proteinState = .loaded(file);
        } catch let error {
            self.proteinState = .error("\(error)");
        }
    }
    
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
    
    switch proteins.listState {
    case .idle: print("idle");
    case .loading: print("loading");
    case .loaded(_):
        print("data loaded")
//            for protein in data {
//                print("id: \(protein.id), \(protein.formula)");
//            }
    case .error(let error): print(error);
    }
}
