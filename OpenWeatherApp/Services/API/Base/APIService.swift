//
//  NewtworkLayer.swift
//  OpenWeatherApp
//
//  Created by Admin on 08/08/2019.
//  Copyright © 2019 NZ. All rights reserved.
//

import Foundation
import Moya
import Result

enum NetworkServiceError: Error {
    case cancelled
    case noConnection
    case anyError(message: String?)
}

class APIService {

    static let provider = MoyaProvider<OpenWeatherMapAPIService>()
    static let callbackQueue = DispatchQueue.global(qos: .utility)

    typealias Failure = (NetworkServiceError) -> Void

    // MARK: CurrentWeather

    static func getCurrentWeatherBy(cityId: Int,
                                    completion: @escaping (Result<CurrentWheatherResponse, NetworkServiceError>) -> Void ) -> Cancellable {
        let cancellable = provider.request(.getCurrentWeatherByCityId(cityId),
                                           callbackQueue: callbackQueue) { (result) in
            do {
                let response = try process(result: result, apiResponseType: CurrentWheatherResponse.self)
                completion(.success(response))
            } catch {
                completion(.failure(error as! NetworkServiceError))
            }

        }
        return cancellable
    }

    static func getCurrentWeatherByCoordinates(longitude: Double,
                                               latitude: Double,
                                               completion: @escaping (Result<CurrentWheatherResponse, NetworkServiceError>) -> Void ) -> Cancellable {
        let cancellable = provider.request(.getCurrentWeatherByCoordinates(longitude: longitude, latitude: latitude),
                                           callbackQueue: callbackQueue) { result in
            do {
                let response = try process(result: result, apiResponseType: CurrentWheatherResponse.self)
                completion(.success(response))
            } catch {
                completion(.failure(error as! NetworkServiceError))
            }
        }
        return cancellable
    }

    // MARK: FiveDayForecast

    static func getFiveDaysForecastBy(cityId: Int,
                                      completion: @escaping (Result<FiveDayForecastResponse, NetworkServiceError>) -> Void ) -> Cancellable {
        let cancellable = provider.request(.getFiveDaysForecastByCityId(cityId),
                                           callbackQueue: callbackQueue) { result in
            do {
                let response = try process(result: result, apiResponseType: FiveDayForecastResponse.self)
                completion(.success(response))
            } catch {
                completion(.failure(error as! NetworkServiceError))
            }
        }
        return cancellable
    }

    static func getFiveDaysForecastByCoordinates(longitude: Double,
                                                 latitude: Double,
                                                 completion: @escaping (Result<FiveDayForecastResponse, NetworkServiceError>) -> Void ) -> Cancellable {
        let cancellable = provider.request(.getFiveDaysForecastByCoordinates(longitude: longitude, latitude: latitude),
                                           callbackQueue: callbackQueue) { result in
            do {
                let response = try process(result: result, apiResponseType: FiveDayForecastResponse.self)
                completion(.success(response))
            } catch {
                completion(.failure(error as! NetworkServiceError))
            }
        }
        return cancellable
    }

    // MARK: - FindCity
    static func findCityBy(name: String,
                           completion: @escaping (Result<FindCityResponse, NetworkServiceError>) -> Void ) -> Cancellable {
        let cancellable = provider.request(.findCityBy(name: name),
                                           callbackQueue: callbackQueue) { result in
                                            do {
                                                let response = try process(result: result, apiResponseType: FindCityResponse.self)
                                                completion(.success(response))
                                            } catch {
                                                completion(.failure(error as! NetworkServiceError))
                                            }
        }
        return cancellable
    }

    // MARK: -
    private static func process<APIResponseType: APIResponse>(result: Result<Response, MoyaError>,
                                                              apiResponseType: APIResponseType.Type) throws -> APIResponseType {

            switch result {
            case .success(let response):
                do {
                _ = try response.filterSuccessfulStatusCodes()
                let serializedResponse = try response.map(apiResponseType)
                return serializedResponse
                } catch MoyaError.statusCode(let badResponse) {
                    do {
                        let serializedResponse = try badResponse.map(APIResponse.self)
                        let message = serializedResponse.message
                        throw NetworkServiceError.anyError(message: message)
                    } catch {
                        throw NetworkServiceError.anyError(message: "Data procassing error")
                    }
                } catch MoyaError.objectMapping(_, _) {
                    throw NetworkServiceError.anyError(message: "Data procassing error")
                } catch {
                    throw NetworkServiceError.anyError(message: nil)
                }
            case .failure(let error):
                if case MoyaError.underlying(let nsError as NSError, _) = error {
                    if nsError.code == -999 || nsError.code == 53 {
                        throw NetworkServiceError.cancelled
                    } else {
                        if nsError.code == -1009 {
                            throw NetworkServiceError.noConnection
                        }
                    }
                }
                throw NetworkServiceError.anyError(message: "Connection error")
            }
    }

}
