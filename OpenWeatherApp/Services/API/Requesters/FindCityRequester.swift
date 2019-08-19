//
//  FindCityRequester.swift
//  OpenWeatherApp
//
//  Created by Admin on 16/08/2019.
//  Copyright © 2019 NZ. All rights reserved.
//

import Foundation
import Moya

class FindCityRequester {

    typealias Completion = ([City]) -> Void
    typealias Failure = (NetworkServiceError) -> Void

    let queue: DispatchQueue = DispatchQueue.global(qos: .default)
    var workItem: DispatchWorkItem?

    private var cancellables: [Cancellable] = []

    func getCitiesBy(name: String, delayInSeconds: Int? = nil, completion: @escaping Completion, failure: @escaping Failure) {
        workItem = DispatchWorkItem { [weak self] in
            let cancellable = APIService.findCityBy(name: name, completion: { (result) in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        completion(response.cities)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        failure(error)
                    }
                }
            })
            DispatchQueue.main.async { [weak self] in
                self?.cancellables.append(cancellable)
            }
        }
        
        if let actualDelay = delayInSeconds {
            let dispatchTimeInterval = DispatchTimeInterval.seconds(actualDelay)
            queue.asyncAfter(deadline: .now() + dispatchTimeInterval, execute: workItem!)
        } else {
            queue.async(execute: workItem!)
        }
        workItem!.notify(queue: .main) { [weak self] in
            if let actualWorkItem = self?.workItem {
                if actualWorkItem.isCancelled {
                    failure(.cancelled)
                }
            }
        }
    }

    func cancel() {
        if let actualWorkItem = workItem {
            actualWorkItem.cancel()
        }
        cancellables.forEach { (item) in
            item.cancel()
        }
        cancellables.removeAll()
    }

    deinit {
        cancel()
    }

}
