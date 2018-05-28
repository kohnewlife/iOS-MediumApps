//
//  PhotoStore.swift
//  Pictogram
//
//  Created by Vo Huy on 5/24/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit

// the result of downloading the image
enum ImageResult {
    case success(UIImage)
    case failure(Error)
}

// photo errors
enum PhotoError: Error {
    case imageCreationError
}

enum PhotosResult {
    case success([Photo])
    case failure(Error)
}

class PhotoStore {
    // @escaping = the closure might not get called immediately within the method
    // this case it will call it when the web service request completes
    func fetchInterestingPhotos(completion: @escaping (PhotosResult) -> Void) {

        let url = FlickrAPI.interestingPhotosURL
        let request = URLRequest(url: url)
        // a task that retrieves the content of an url, given a request
        URLSession.shared.dataTask(with: request) {
            // a completion closure to call when the request finishes
            (data, response, error) in
            
            let result = self.processPhotosRequest(data: data, error: error)
            OperationQueue.main.addOperation {
                completion(result)
            }
        }.resume()
        // tasks are always created in the suspended state, calling resume() will start the webservice request
    }
    
    func fetchRecentPhotos(completion: @escaping (PhotosResult) -> Void) {
        
        let url = FlickrAPI.recentPhotosURL
        let request = URLRequest(url: url)
        // a task that retrieves the content of an url, given a request
        URLSession.shared.dataTask(with: request) {
            // a completion closure to call when the request finishes
            (data, response, error) in
            
            let result = self.processPhotosRequest(data: data, error: error)
            OperationQueue.main.addOperation {
                completion(result)
            }
            }.resume()
        // tasks are always created in the suspended state, calling resume() will start the webservice request
    }
    
    private func processPhotosRequest(data: Data?, error: Error?) -> PhotosResult {
        guard let jsonData = data else { return .failure(error!) }
        return FlickrAPI.photos(fromJSON: jsonData)
    }
    
    // download image data
    func fetchImage(for photo: Photo, completion: @escaping (ImageResult) -> Void) {
        
        let photoURL = photo.remoteURL
        let request = URLRequest(url: photoURL)
        
        URLSession.shared.dataTask(with: request) {
            (data, response, error) -> Void in
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code: \(httpResponse.statusCode)")
                print("Headers: \(httpResponse.allHeaderFields) -- ")
            }
            
            let result = self.processImageRequest(data: data, error: error)
            // the main thread
            OperationQueue.main.addOperation {
                completion(result)
            }
        }.resume()
    }
    
    // process data from the web service request into image
    private func processImageRequest(data: Data?, error: Error?) -> ImageResult {
        guard
            let imageData = data,
            let image = UIImage(data: imageData)
        else {
            // Couldn't create an image
            if data == nil {
                return .failure(error!)
            } else { return .failure(PhotoError.imageCreationError) }
        }
        
        // all passed, success
        return .success(image)
    }
}
