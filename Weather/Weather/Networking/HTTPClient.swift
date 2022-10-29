//
//  HTTPClient.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 29.10.2022.
//

import Foundation

protocol HTTPClient {
    func sendRequest<T: Decodable>(
        session: URLSession,
        endpoint: Endpoint,
        responseModel: T.Type) async -> Result<T, HTTPRequestError>
}

extension HTTPClient {
    
    func sendRequest<T: Decodable>(session: URLSession = .shared,
                                   endpoint: Endpoint,
                                   responseModel: T.Type) async -> Result<T, HTTPRequestError> {
        
        guard let url = endpoint.baseURL
        else { return .failure(.invalidURL) }
        
        var request: URLRequest = .init(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header
        if let body = endpoint.body {
            request.httpBody = try? JSONEncoder().encode(body)
        }
        #if DEBUG
        request.debug()
        #endif
        return await withCheckedContinuation({ continuation in
            session.dataTask(with: request) { data, response, error in
                if let error = error {
                    return continuation.resume(
                        returning: .failure(
                            .request(
                                localizedDescription: error.localizedDescription)))
                }
                guard let responseCode = (response as? HTTPURLResponse)?.statusCode
                else { return continuation.resume(returning: .failure(.noResponse)) }
                
                switch responseCode {
                case 200...209:
                    guard let data = data,
                          let decodeResponse = try? JSONDecoder().decode(responseModel, from: data)
                    else { return continuation.resume(returning: .failure(.decode)) }
                    return continuation.resume(returning: .success(decodeResponse))
                case 401:
                    return continuation.resume(returning: .failure(.unauthorization))
                default:
                    return continuation.resume(returning: .failure(.unexpectedStatus(code: responseCode)))
                }
            }
        })
    }
}

extension URLRequest {
    
    func debug() {
        print(">>>>>> START URL REQUEST >>>>>>")
        print("🌐 URL:", self.url ?? "❌")
        print("🌐 Method:", self.httpMethod ?? "❌")
        print("🌐 Headers:", self.allHTTPHeaderFields ?? "❌")
        print("🌐 Body:", String(data: self.httpBody ?? Data(), encoding: .utf8) ?? "❌")
        print(">>>>>> END URL REQUEST >>>>>>")
    }
    
}
