//
//  MockLingandsListService.swift
//  Tuxein
//
//  Created by Ewan Bigotte on 31/05/2026.
//

import Foundation

struct MockProteinsService: ProteinsService {
    
    func fetchList() async throws -> [Protein] {
        guard let url = Bundle.main.url(forResource: "ProteinsListSampleData", withExtension: "txt") else {
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
            throw ProteinsError.invalidDecoding;
        }
    }
    
    func fetchProteinDetails(for identifier: String) async throws -> String {
        guard let url = Bundle.main.url(forResource: "ProteinSampleData", withExtension: "txt") else {
            throw ProteinsError.invalidDecoding;
        }
        
        do {
            let data = try Data(contentsOf: url);
            
            guard let file = String(data: data, encoding: .utf8) else {
                throw URLError(.badURL)
            }
            
            return file;
        } catch {
            throw ProteinsError.invalidDecoding;
        }
    }
    
    func load() -> Set<String> {
        return ["001", "04G"];
    }
    
    func save(favoriteIDs: Set<String>) {
    }
    
    // -- MARK -- PREVIEW -- \\
    
    func fetchListPreview() -> [Protein] {
        return ["001", "011", "031", "041", "04G", "083", "0AF", "0DS", "0DX", "0E5", "0EA", "0J0", "0JV", "0L8", "0MC", "0MD", "0RU", "0RY", "0RZ", "0S0", "0T6", "0T7"].map {
            Protein(id: $0, type: "NON-POLYMER", formula: "C35 H42 F2 N2 O6", weight: 624.715);
        };
    }
    
}
