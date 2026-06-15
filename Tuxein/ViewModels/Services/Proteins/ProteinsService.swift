//
//  LingandsListService.swift
//  Tuxein
//
//  Created by Ewan Bigotte on 31/05/2026.
//

import Foundation

protocol ProteinsService {
    func fetchList() async throws -> [Protein];
    func fetchProteinDetails(for identifier: String) async throws -> ([Atom], [Bond]);
    
    func load() -> Set<String>;
    func save(favoriteIDs: Set<String>);
}
