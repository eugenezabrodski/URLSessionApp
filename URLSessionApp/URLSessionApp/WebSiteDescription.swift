//
//  WebSiteDescription.swift
//  URLSessionApp
//
//  Created by Eugene on 08/01/2024.
//

import Foundation

struct WebSiteDescription: Decodable {
    let websiteDescription: String?
    let websiteName: String?
    let courses: [CourseModel]
}
