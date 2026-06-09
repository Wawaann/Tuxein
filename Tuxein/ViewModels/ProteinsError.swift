//
//  LingandsListError.swift
//  Tuxein
//
//  Created by Ewan Bigotte on 31/05/2026.
//

import Foundation

import Foundation

enum ProteinsError: LocalizedError {
    case invalidURL;
    case invalidResponse;
    case invalidDecoding;
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL is invalid";
        case .invalidResponse:
            return "Invalid response from server";
        case .invalidDecoding:
            return "Invalid lignads during list decoding";
        }
    }
}
