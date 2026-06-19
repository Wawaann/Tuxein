//
//  Protein3DView.swift
//  Tuxein
//
//  Created by Ewan Bigotte on 13/06/2026.
//

import SwiftUI
import RealityKit

/*

 À faire:
    - voir si possibilité de fix l'affichage d'un seul
      atome au coordonnée (0, 0, 0).
*/

struct Protein3DView: View {
    
    var protein: Protein;
    
    @State private var anchorEntity: AnchorEntity = AnchorEntity();
    @State private var currentRotation = simd_quatf(angle: 0, axis: [0, 1, 0]);
    @State private var startRotation = simd_quatf(angle: 0, axis: [0, 1, 0]);
    @State private var currentScale: Float = 1;
    @State private var startScale: Float = 1;
    
    var body: some View {
        GeometryReader { geometry in
            RealityView { content in
                let anchor = AnchorEntity();
                anchorEntity = anchor;
                
                guard let atoms = protein.atoms, !atoms.isEmpty else {
                    content.add(anchor);
                    return;
                }
                
                guard let bonds = protein.bonds, !bonds.isEmpty else {
                    content.add(anchor);
                    return;
                }
                
                let atomById = Dictionary(uniqueKeysWithValues: atoms.map { ($0.id, $0) });
                
                let center = atoms.reduce(simd_float3.zero) { partial, atom in
                    partial + simd_float3(atom.x, atom.y, atom.z)
                } / Float(atoms.count)
                
                for atom in atoms {
                    let color = atom.id.starts(with: "H") ? UIColor.black : UIColor.red;
                    let mesh = MeshResource.generateSphere(radius: 0.02);
                    let material = SimpleMaterial(color: color, isMetallic: false);
                    let sphere = ModelEntity(mesh: mesh, materials: [material]);
                    
                    let rawPosition = simd_float3(atom.x, atom.y, atom.z);
                    sphere.position = (rawPosition - center) * 0.06;
                    
                    anchor.addChild(sphere);
                }
                
                for bond in bonds {
                    let IDS = bond.id.split(separator: "-");
                    guard let atom1 = atomById[String(IDS[0])],
                          let atom2 = atomById[String(IDS[1])] else {
                        continue;
                    }
                    
                    let pos1 = (simd_float3(atom1.x, atom1.y, atom1.z) - center) * 0.06;
                    let pos2 = (simd_float3(atom2.x, atom2.y, atom2.z) - center) * 0.06;
                    
                    let direction = pos2 - pos1;
                    let length = simd_length(direction);

                    let middle = (pos1 + pos2) / 2;
                    
                    let mesh = MeshResource.generateCylinder(height: length, radius: 0.01)
                    let material = SimpleMaterial(color: .black, isMetallic: false);
                    let cylinder = ModelEntity(mesh: mesh, materials: [material]);
                    
                    cylinder.position = middle;
                    cylinder.orientation = simd_quatf(
                        from: simd_float3(0, 1, 0),
                        to: simd_normalize(direction)
                    );
                    
                    anchor.addChild(cylinder);
                }
                
                content.add(anchor);
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let rotationY = Float(value.translation.width) * 0.01
                        let rotationX = Float(value.translation.height) * 0.01
                        
                        let xRotation = simd_quatf(angle: rotationX, axis: [1, 0, 0])
                        let yRotation = simd_quatf(angle: rotationY, axis: [0, 1, 0])
                        
                        currentRotation = yRotation * xRotation * startRotation
                        anchorEntity.orientation = currentRotation
                    }
                    .onEnded { _ in
                        startRotation = currentRotation
                    }
                    .simultaneously(
                        with: MagnifyGesture()
                            .onChanged { value in
                                let newScale = startScale * Float(value.magnification)
                                currentScale = min(max(newScale, 0.3), 4.0)
                                anchorEntity.scale = SIMD3(repeating: currentScale)
                            }
                            .onEnded { _ in
                                startScale = currentScale
                            }
                    )
            )
        }
    }
}

#Preview {
    Protein3DPreviewWrapper();
}

private struct Protein3DPreviewWrapper: View {
    @State var viewModel: ProteinsViewModel = ProteinsViewModel(service: MockProteinsService());
    
    var body: some View {
        Group {
            switch viewModel.proteinState {
            case .idle:
                Text("Y a rien")
            case .loading:
                ProgressView()
            case .loaded(let protein):
                Protein3DView(protein: protein)
            case .error(let error):
                Text(error)
            }
        }
        .task {
            await viewModel.fetchList();
            await viewModel.fetchProteinDetails(for: "011");
        }
    }
}
