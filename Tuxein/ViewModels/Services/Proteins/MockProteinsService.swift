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
        guard let url = Bundle.main.url(forResource: "ProteinSampleData", withExtension: "txt") else {
            throw ProteinsError.invalidDecoding;
        }
        
        do {
            let data = try Data(contentsOf: url);
            
            guard let file = String(data: data, encoding: .utf8) else {
                throw URLError(.badURL)
            }
            
            let lines: [Substring] = file.split(separator: "\n");
            let atomLoopIndex: Int = lines.firstIndex(where: { $0.contains("_chem_comp_atom") })!;
            let bondLoopIndex: Int = lines.firstIndex(where: { $0.contains("_chem_comp_bond") })!;
            
            let atoms = getCompAtomInfo(lines: Array(lines.dropFirst(atomLoopIndex)));
            let bonds = getCompBondInfo(lines: Array(lines.dropFirst(bondLoopIndex)));
            
            return (atoms, bonds);
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
