//
//  BaseApiService.swift
//  PlayMusic
//
//  Created by AnhND47.APL on 30/11/2022.
//

import Foundation
import Combine

class BaseApiService {
    // MARK: Networking Error
    enum NetworkingError: Error {
        case badURLResponse
        case unknown
        case decodedError
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse:
                return "Bad response from URL"
            case .unknown:
                return "Unknown error occurred"
            case .decodedError:
                return "Decoded error object"
            }
        }
    }
    // MARK: Fetch Data Normal From API With URL Request
    static func request(from urlRequest: URLRequest) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { try handleURLResponse(output: $0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: Fetch Data Normal From API
    static func request(from url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { try handleURLResponse(output: $0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: Handle Normal Response
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkingError.badURLResponse
        }
        
        return output.data
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    // MARK: Fetch Data Not Object From API
    static func requestNotObject(from url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { try handleNotObjURLResponse(output: $0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: Handle Not Object Response
    static func handleNotObjURLResponse(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkingError.badURLResponse
        }
        // 1. Convert Data output to string
        let dataDecoded = String(data: output.data, encoding: String.Encoding.ascii)
        guard let dataDecoded = dataDecoded else {
            throw NetworkingError.decodedError
        }
        let dataString = dataDecoded.encode(dataDecoded)
        
        // 2. Convert string to result string
        var resultString = dataString.split(separator: "[")[1].dropLast()
        resultString.insert("[", at: resultString.startIndex)

        // 3. Convert result string to result data
        let dataResult = Data(resultString.utf8)
        
        return dataResult
    }
}

extension String {
    static let empty: String = ""
    static let dot: String = "."
    
    func utf8DecodedString() -> String {
        let data = self.data(using: .utf8)
        let message = String(data: data!, encoding: .nonLossyASCII) ?? ""
        return message
    }
    
    func utf8EncodedString()-> String {
        let messageData = self.data(using: .nonLossyASCII)
        let text = String(data: messageData!, encoding: .utf8) ?? ""
        return text
    }
    
    func encode(_ s: String) -> String {
        let data = s.data(using: .utf8, allowLossyConversion: true)!
        return String(data: data, encoding: .utf8)!
    }
}

