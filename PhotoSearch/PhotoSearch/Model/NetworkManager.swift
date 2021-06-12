import UIKit

protocol NetworkManagerDescription {
    func getPhotos(page: Int, query: String, completion: @escaping (Result<APIResponse, Error>) -> Void)
    func getRandomPhoto(completion: @escaping (Result<APIResult, Error>) -> Void)
}

class NetworkManager: NetworkManagerDescription {
    static let shared = NetworkManager()
    
    private let imageCache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func getPhotos(page: Int, query: String, completion: @escaping (Result<APIResponse, Error>) -> Void) {
        let urlStr = "https://api.unsplash.com/search/photos?page=\(page)&per_page=20&query=\(query)&client_id=\(APIKey.key)"
        guard let url = URL(string: urlStr) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            guard let data = data else { return }
            
            do {
                let res = try JSONDecoder().decode(APIResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(res))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    func getRandomPhoto(completion: @escaping (Result<APIResult, Error>) -> Void) {
        let urlStr = "https://api.unsplash.com/photos/random?client_id=\(APIKey.key)"
        guard let url = URL(string: urlStr) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            guard let data = data else { return }
            
            do {
                let res = try JSONDecoder().decode(APIResult.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(res))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
