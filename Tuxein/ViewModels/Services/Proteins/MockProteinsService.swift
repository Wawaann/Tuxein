//
//  MockLingandsListService.swift
//  Tuxein
//
//  Created by Ewan Bigotte on 31/05/2026.
//

import Foundation

struct MockProteinsService: ProteinsService {
    
    // MARK: Fetch list
    
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
    
    // MARK: Fetch protein details
    
    private func getCompValue(from line: Substring, comp: inout [Substring], compValue: inout [Substring: Substring], oneComp: inout Bool) {
        
        let splitLine = line.split(separator: " ");
        
        if splitLine.count > 1 {
            let key = splitLine[0].split(separator: ".").last!;
            let value = splitLine.last!;
            compValue[key] = value;
            oneComp = true;
        } else {
            comp.append(line.split(separator: ".").last!);
        }
    }
    
    private func compAppend<T: ComponentBuildable>(for comp: inout [T], from compValue: [Substring: Substring]) {
        guard let template = T(from: compValue) else {
            print("Failed to create instance");
            return;
        }
        
        comp.append(template);
    }
    
    private func getCompInfo<T: ComponentBuildable>(from lines: [Substring], for info: String) -> [T] {
        let info: String = "_chem_comp_\(info)";
        var type: [T] = [];
        var comp: [Substring] = [];
        var compValue: [Substring: Substring] = [:];
        var oneComp: Bool = false;
        
        for line in lines {
            if line.starts(with: info) {
                getCompValue(from: line, comp: &comp, compValue: &compValue, oneComp: &oneComp)
            } else if line.starts(with: "#") {
                if oneComp {
                    compAppend(for: &type, from: compValue);
                }
                break;
            } else {
                compValue = [:];
                let values = line.split(separator: " ");
                
                for (compKey, value) in zip(comp, values) {
                    compValue[compKey] = value;
                }
                compAppend(for: &type, from: compValue);
            }
        }
        
        return type;
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
            var loopIndex: Int = lines.firstIndex(where: { $0.contains("_chem_comp_atom") }) ?? 0;
            
            let atoms: [Atom] = loopIndex == 0
                ? []
                : getCompInfo(from: Array(lines.dropFirst(loopIndex)), for: "atom");

            loopIndex = lines.firstIndex(where: { $0.contains("_chem_comp_bond") }) ?? 0;
            
            let bonds: [Bond] = loopIndex == 0
                ? []
                : getCompInfo(from: Array(lines.dropFirst(loopIndex)), for: "bond");
            
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
    
    // MARK: Preview list
    
    func fetchListPreview() -> [Protein] {
        return ["001", "011", "031", "041", "04G", "083", "0AF", "0DS", "0DX", "0E5", "0EA", "0J0", "0JV", "0L8", "0MC", "0MD", "0RU", "0RY", "0RZ", "0S0", "0T6", "0T7"].map {
            Protein(id: $0, type: "NON-POLYMER", formula: "C35 H42 F2 N2 O6", weight: 624.715);
        };
    }
    
}
