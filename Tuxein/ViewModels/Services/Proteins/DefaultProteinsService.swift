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
    
    func getCompAtomInfo(lines: [Substring]) -> [Atom] {
        var compAtom: [Substring] = [];
        var atoms: [Atom] = [];
        
        for line in lines {
            
            if line.starts(with: "_chem_comp_atom") {
                compAtom.append(line.split(separator: ".").last!);
            } else if line.starts(with: "#") {
                break;
            } else {
                var compAtomValue: [Substring: Substring] = [:]
                let values = line.split(separator: " ");
                
                for (compAtomKey, value) in zip(compAtom, values) {
                    compAtomValue[compAtomKey] = value;
                }
                
                guard let atom = Atom(from: compAtomValue) else {
                    continue;
                }
                
                atoms.append(atom);
            }
        }
        
        return atoms;
    }
    
    func getCompBondInfo(lines: [Substring]) -> [Bond] {
        var compBond: [Substring] = [];
        var bonds: [Bond] = [];
        
        for line in lines {
            if line.starts(with: "_chem_comp_bond") {
                compBond.append(line.split(separator: ".").last!);
            } else if line.starts(with: "#") {
                break;
            } else {
                var compBondValue: [Substring: Substring] = [:]
                let values = line.split(separator: " ");
                
                for (compBondKey, value) in zip(compBond, values) {
                    compBondValue[compBondKey] = value;
                }
                
                guard let bond = Bond(from: compBondValue) else {
                    continue;
                }
                
                bonds.append(bond);
            }
        }
        
        return bonds;
    }
    
    func fetchProteinDetails(for identifier: String) async throws -> ([Atom], [Bond]) {

        print("ID: \(identifier)")
        
        guard let url = URL(string: detailsURL + identifier + ".cif") else {
            throw URLError(.badURL);
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url);
            
            guard let file = String(data: data, encoding: .utf8) else {
                throw URLError(.badURL);
            }
            
            let lines: [Substring] = file.split(separator: "\n");
            let atomLoopIndex: Int = lines.firstIndex(where: { $0.contains("_chem_comp_atom") })!;
            let bondLoopIndex: Int = lines.firstIndex(where: { $0.contains("_chem_comp_bond") })!;
            
            let atoms = getCompAtomInfo(lines: Array(lines.dropFirst(atomLoopIndex)));
            let bonds = getCompBondInfo(lines: Array(lines.dropFirst(bondLoopIndex)));
            
            return (atoms, bonds);
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
