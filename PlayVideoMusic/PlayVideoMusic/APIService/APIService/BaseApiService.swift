//
//  BaseApiService.swift
//  PlayMusic
//
//  Created by AnhND47.APL on 30/11/2022.
//

import Foundation
import Combine

// MARK: Response Structure
struct Response<T> {
    let value: T
    let response: URLResponse
}

// MARK: API Error
enum APIError: Error {
    case error(String)
    case errorURL
    case invalidResponse
    case errorParsing
    case unknown

    var localizedDescription: String {
        switch self {
        case .error(let string):
            return string
        case .errorURL:
            return "URL String is error."
        case .invalidResponse:
            return "Invalid response"
        case .errorParsing:
            return "Failed parsing response from server"
        case .unknown:
            return "An unknown error occurred"
        }
    }
}

class BaseApiService {
    static let shared = BaseApiService()
}

extension BaseApiService {
    // MARK: Fetch Api With URLRequest
    func request<T: Decodable>(from urlRequest: URLRequest) -> AnyPublisher<Response<T>, APIError> {
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { result in
                guard let httpResponse = result.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    print("status code for api response : \((result.response as? HTTPURLResponse)?.statusCode ?? 200)")
                    throw APIError.invalidResponse
                }

                let decoder = JSONDecoder()
                let value = try decoder.decode(T.self, from: result.data)
                return Response(value: value, response: result.response)
            }
            .mapError { error -> APIError in
                switch error {
                case is URLError:
                    return .errorURL
                case is DecodingError:
                    return .errorParsing
                default:
                    return error as? APIError ?? .unknown
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    // MARK: Fetch URL Image
    func requestImage(url: URL) -> AnyPublisher<Data, APIError> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300 else {
                    throw APIError.invalidResponse
                }
                return output.data
            }
            .mapError { error -> APIError in
                switch error {
                case is URLError:
                    return .errorURL
                case is DecodingError:
                    return .errorParsing
                default:
                    return error as? APIError ?? .unknown
                }
            }
            .eraseToAnyPublisher()
    }

    // MARK: Fetch Data Normal From API With URL Request
    func request<T: Decodable>(url: URL) -> AnyPublisher<Response<T>, APIError> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { result -> Response<T> in
                guard let httpResponse = result.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    print("status code for api response : \((result.response as? HTTPURLResponse)?.statusCode ?? 200)")
                    throw APIError.invalidResponse
                }

                let decoder = JSONDecoder()
                let value = try decoder.decode(T.self, from: result.data)
                return Response(value: value, response: result.response)
            }
            .mapError { error -> APIError in
                switch error {
                case is URLError:
                    return .errorURL
                case is DecodingError:
                    return .errorParsing
                default:
                    return error as? APIError ?? .unknown
                }
            }
            .eraseToAnyPublisher()
    }

    // MARK: Fetch Data Not Object From API
    func requestNotObject(from url: URL) -> AnyPublisher<Data, APIError> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { try self.handleNotObjURLResponse(output: $0) }
            .mapError { error -> APIError in
                switch error {
                case is URLError:
                    return .errorURL
                case is DecodingError:
                    return .errorParsing
                default:
                    return error as? APIError ?? .unknown
                }
            }
            .eraseToAnyPublisher()
    }

    // MARK: Handle Not Object Response
    private func handleNotObjURLResponse(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw APIError.errorURL
        }
        // 1. Convert Data output to string
        let dataDecoded = String(data: output.data, encoding: String.Encoding.ascii)
        guard let dataDecoded = dataDecoded else {
            throw APIError.errorParsing
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
