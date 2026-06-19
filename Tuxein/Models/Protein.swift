//
//  Protein.swift
//  Tuxein
//
//  Created by Ewan Bigotte on 04/06/2026.
//

import Foundation

// MARK: Comp protocol

protocol ComponentBuildable {
    init?(from compValue: [Substring: Substring]);
}

// MARK: Atom component

struct Atom: Identifiable, Equatable, ComponentBuildable {
    var id: String;
    var type: String;
    var x: Float;
    var y: Float;
    var z: Float;
    
    init?(from values: [Substring: Substring]) {
        let normalizedValues = Dictionary(
            uniqueKeysWithValues: values.map { key, value in
                (key.trimmingCharacters(in: .whitespacesAndNewlines), value.trimmingCharacters(in: .whitespacesAndNewlines))
            }
        )
        
        guard let id = normalizedValues["atom_id"],
              let type = normalizedValues["type_symbol"],
              let xValue = normalizedValues["pdbx_model_Cartn_x_ideal"],
              let yValue = normalizedValues["pdbx_model_Cartn_y_ideal"],
              let zValue = normalizedValues["pdbx_model_Cartn_z_ideal"],
              let x = Float(xValue),
              let y = Float(yValue),
              let z = Float(zValue) else {
            print("Failed to parse atom: \(values)")
            return nil
        }

        self.id = id
        self.type = type
        self.x = x
        self.y = y
        self.z = z
    }
    
    var description: String {
        "Atom(id: \(id), type: \(type), x: \(x), y: \(y), z: \(z))";
    }
}

// MARK: Bond component

struct Bond: Identifiable, Equatable, ComponentBuildable {
    var id: String;
    var valueOrder: String;
    var aromticFlag: Bool;
    var stereoConfig: String;
    
    init?(from values: [Substring: Substring]) {
        let normalizedValues = Dictionary(
            uniqueKeysWithValues: values.map { key, value in
                (key.trimmingCharacters(in: .whitespacesAndNewlines), value.trimmingCharacters(in: .whitespacesAndNewlines))
            }
        )
        
        guard let atom1 = normalizedValues["atom_id_1"],
              let atom2 = normalizedValues["atom_id_2"],
              let valueOrder = normalizedValues["value_order"],
              let aromticFlag = normalizedValues["pdbx_aromatic_flag"],
              let stereoConfig = normalizedValues["pdbx_stereo_config"] else {
            print("Failed to parse bond: \(values)");
            return nil;
        }
        
        self.id = "\(atom1)-\(atom2)";
        self.valueOrder = valueOrder;
        self.aromticFlag = aromticFlag == "Y" ? true : false;
        self.stereoConfig = stereoConfig;
    }
    
    var description: String {
        "Bond(id: \(id), valueOrder: \(valueOrder), aromticFlag: \(aromticFlag), stereoConfig: \(stereoConfig))"
    }
}

// MARK: Protein model

struct Protein: Identifiable, Equatable, CustomStringConvertible {
    var id: String;
    var type: String;
    var formula: String;
    var weight: Float;
    var atoms: [Atom]?;
    var bonds: [Bond]?;
    
    var description: String {
        let atomsCount = atoms?.count ?? 0;
        let bondsCount = bonds?.count ?? 0;
        
        return "Protein(id: \(id), type: \(type), formula: \(formula), weight: \(weight), atoms: \(atomsCount), bonds: \(bondsCount))";
    }
}
