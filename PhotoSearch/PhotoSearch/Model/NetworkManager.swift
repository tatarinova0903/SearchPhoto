import UIKit

protocol NetworkManagerDescription {
    func getPhotos(page: Int, query: String, completion: @escaping (Result<APIResponse, Error>) -> Void)
    func getPhoto(urlStr: String, completion: @escaping (Result<UIImage?, CustomErrors>) -> Void)
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
    
    func getPhoto(urlStr: String, completion: @escaping (Result<UIImage?, CustomErrors>) -> Void) {
        
        if let cachedImage = imageCache.object(forKey: urlStr as NSString) {
            completion(.success(cachedImage))
            return
        }
        
        guard let url = URL(string: urlStr) else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard error == nil else {
                completion(.failure(CustomErrors.failedLoadingPhoto))
                return
            }
            
            guard let data = data else {
                completion(.failure(CustomErrors.unexpected))
                return
            }
            
            guard let image = UIImage(data: data) else {
                completion(.failure(CustomErrors.failedLoadingPhoto))
                return
            }
            
            self?.imageCache.setObject(image, forKey: urlStr as NSString)
            
            DispatchQueue.main.async {
                completion(.success(image))
            }
        }
        task.resume()
    }
}
