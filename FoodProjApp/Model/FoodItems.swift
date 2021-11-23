//
//  FoodItems.swift
//  FoodProjApp
//
//  Created by kristians.tide on 21/11/2021.
//

import Foundation


struct FoodItems: Decodable {
    
    var summary: String
    var title: String
    var sourceUrl: String
    var imageURL: String
    var servings: Int
    var readyInMinutes: Int
    var sourceName: String
    var cuisines: [String] = []
//    var extendedIngredients: [ExtendedIngredients]
    
    enum CodingKeys: String, CodingKey{
        case summary
        case title
        case sourceUrl
        case imageURL = "image"
        case servings
        case readyInMinutes
        case sourceName
        case cuisines
//        case extendedIngredients
    }
}
//struct ExtendedIngredients: Decodable {
//    var name: String
//    var amount: Int
//    var unit: String
//    enum CodingKeys: String, CodingKey {
//        case name
//        case amount
//        case unit
//
//}
//
//}

struct Results: Decodable {
    let results: [FoodItems]

}
