import UIKit

protocol SearchPhotoPresenterProtocol: AnyObject {
    func setDelegate(with delegate: SearchPhotoViewProtocol)
    
    func getPhotos(page: Int, query: String)
    
    var photosCount: Int { get }
    func getImageURL(for index: Int) -> String
    
    func saveImage(_ image: UIImage?)
}

class SearchPhotoPresenter: SearchPhotoPresenterProtocol {
    
    // MARK: - Properties
    
    private weak var searchPhotoView: SearchPhotoViewProtocol?
    
    private var networkManager: NetworkManagerDescription = NetworkManager.shared
    
    private var res = [APIResult]()
    
    var photosCount: Int {
        res.count
    }
    
    // MARK: - Set
    
    func setDelegate(with delegate: SearchPhotoViewProtocol) {
        self.searchPhotoView = delegate
    }
    
    // MARK: - Handlers
    
    func getPhotos(page: Int, query: String) {
        networkManager.getPhotos(page: page, query: query) { [weak self] (res) in
            switch res {
            case .success(let res):
                if page > 1 {
                    self?.res.append(contentsOf: res.results)
                    self?.searchPhotoView?.changeIsPaginated(newValue: false)
                } else {
                    self?.res = res.results
                }
                self?.searchPhotoView?.reloadView()
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func getImageURL(for index: Int) -> String {
        res[index].urls.regular
    }
    
    func saveImage(_ image: UIImage?) {
        guard let image = image else {
            return
        }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}
