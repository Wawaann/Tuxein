//
//  LoginView.swift
//  Tuxein
//
//  Created by Ewan Bigotte on 29/05/2026.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 200) {
            Text("Tuxein")
                .font(Font.largeTitle.bold())
            
            HStack(alignment: .center, spacing: 50) {
                Button("Register") {
                    
                }
                .buttonStyle(.glassProminent)
                Button("Login") {
                }
                .buttonStyle(.glassProminent)
            }
        }
    }
}

#Preview {
    LoginView()
}
