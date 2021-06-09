import Foundation

struct APIResponse: Decodable {
    var total: Int
    var total_pages: Int
    var results: [APIResult]
}

struct APIResult: Decodable {
    var id: String
    var urls: URLs
}

struct URLs: Decodable {
    var small: String
}
