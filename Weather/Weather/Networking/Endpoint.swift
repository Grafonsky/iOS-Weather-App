//
//  Endpoint.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 29.10.2022.
//

import Foundation

protocol Endpoint {
    var baseURL: URL? { get }
    var queryItems: [URLQueryItem] { get }
    var path: String { get }
    var method: HTTPRequestMethod { get }
    var header: [String: String]? { get }
    var body: [String: String]? { get }
}
