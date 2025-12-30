//
//  APIClient.swift
//  OAuth
//
//  Created by user277759 on 12/30/25.
//

import Foundation


enum APIError: LocalizedError {
    case invalidURL
    case invalidREsponse
    case http(Int, String?)
    case decoding(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .invalidREsponse: return "Invalid server response"
        case .http(let code, let msg): return "HTTP \(code): \(msg ?? "Unknown error" )"
        case .decoding(let err): return "Decoding error: \(err.localizedDescription)"
        }
    }
}


final class APIClient {
    
    let baseURL: URL
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    func request<T: Decodable, Body: Encodable>(
        path: String,
        method: String = "POST",
        body: Body? = nil,
        bearerToken: String? = nil,
        responseType: T.Type = T.self
    ) async throws -> T {
        
        guard let url = URL(string: path, relativeTo: baseURL) else { throw APIError.invalidURL}
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let bearerToken {
            request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        }
        if let body {
            request.httpBody =  try JSONEncoder().encode(body)
        }
        
        let (data,response) =  try await URLSession.shared.data(for: request)
        
        guard let http = response as? HTTPURLResponse else {throw APIError.invalidREsponse}
        
        if !(200...299).contains(http.statusCode){
            let serverMsg = (try? JSONDecoder().decode(ServerMessage.self, from: data).message) ?? String(data:data, encoding: .uft8)
            throw APIError.http(http.statusCode, serverMsg)
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decoding(error)
        }
    }
}

struct ServerMessage: Codable {
    let message: String
}
