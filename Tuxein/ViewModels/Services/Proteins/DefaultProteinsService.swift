//
//  DefaultLingandsListService.swift
//  Tuxein
//
//  Created by Ewan Bigotte on 31/05/2026.
//

import Foundation

struct DefaultProteinsService: ProteinsService {
    
    let detailsURL = "https://files.rcsb.org/ligands/view/";
    private let favoriteKey = "TuxeinExplorer.FavoriteProteins";
    
    func fetchList() async throws -> [Protein] {
        
        guard let url = Bundle.main.url(forResource: "ProteinsList", withExtension: "txt") else {
            throw ProteinsError.invalidDecoding;
        }
        
        do {
            
            let data = try Data(contentsOf: url);
            
            guard let file = String(data: data, encoding: .utf8) else {
                throw URLError(.badURL)
            }
            
            var list: [Protein] = [];
            
            for item in file.split(separator: "\n") {
                let details = item.split(separator: "|");
                let protein = Protein(
                    id: String(details[0]),
                    type: String(details[1]),
                    formula: String(details[2]),
                    weight: Float(details[3]) ?? 0
                );
                
                list.append(protein);
            }
            
            return list;
        } catch {
            throw URLError(.badServerResponse)
        }
    }
    
    func fetchProteinDetails(for identifier: String) async throws -> String {

        guard let url = URL(string: detailsURL + identifier + ".cif") else {
            throw URLError(.badURL);
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url);
            
            guard let file = String(data: data, encoding: .utf8) else {
                throw URLError(.badURL)
            }
            
            return file;
        }
        catch {
            throw URLError(.badServerResponse)
        }
    }
    
    func load() -> Set<String> {
        let array = UserDefaults.standard.stringArray(forKey: favoriteKey) ?? [];
        return Set(array);
    }
    
    func save(favoriteIDs: Set<String>) {
        UserDefaults.standard.set(Array(favoriteIDs), forKey: favoriteKey);
    }
}
