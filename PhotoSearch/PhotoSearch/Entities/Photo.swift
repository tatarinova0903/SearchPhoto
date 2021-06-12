import Foundation

struct APIResponse: Decodable {
    var total: Int
    var total_pages: Int
    var results: [APIResult]
}

struct APIResult: Decodable {
    var id: String
    var urls: URLs
    
    init(id: String = "", urls: URLs = URLs()) {
        self.id = id
        self.urls = urls
    }
}

struct URLs: Decodable {
    var regular: String
    var small: String
    
    init(regular: String = "", small: String = "") {
        self.small = small
        self.regular = regular
    }
}
