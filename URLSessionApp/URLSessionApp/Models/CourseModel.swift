//
//  CourseModel.swift
//  URLSessionApp
//
//  Created by Eugene on 08/01/2024.
//

import Foundation


struct CourseModel: Decodable {
    let id: Int?
    let name: String?
    let link: String?
    let imageUrl: String?
    let numberOfLessons: Int?
    let numberOfTests: Int?
}
