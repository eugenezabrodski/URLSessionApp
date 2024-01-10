//
//  AlamofireNetwork.swift
//  URLSessionApp
//
//  Created by Eugene on 10/01/2024.
//

import Foundation
import Alamofire

class AlamofireNetwork {
    
    static func sendRequest(url: String, complition: @escaping (_ courses: [CourseModel])->()) {
        
        guard let url = URL(string: url) else { return }
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                var courses = [CourseModel]()
                courses = CourseModel.getArray(from: value)!
                complition(courses)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func responseData(url: String) {
        AF.request(url).responseData { data in
            switch data.result {
            case .success(let data):
                guard let string = String(data: data, encoding: .utf8) else { return }
                print(data, string)
            case .failure(let error):
                print(error)
            }
        }
    }
}
