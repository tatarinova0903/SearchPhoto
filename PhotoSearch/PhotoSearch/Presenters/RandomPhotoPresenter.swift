import UIKit

protocol RandomPhotoPresenterProtocol: AnyObject {
    func setDelegate(with delegate: RandomPhotoViewProtocol)
    func getPhoto()
}

class RandomPhotoPresenter: RandomPhotoPresenterProtocol {
    
    // MARK: - Properties
    
    private weak var delegate: RandomPhotoViewProtocol?
    
    private var networkManager: NetworkManagerDescription = NetworkManager.shared
    
    private var randomPhoto = APIResult()
    
    // MARK: - Set
    
    func setDelegate(with delegate: RandomPhotoViewProtocol) {
        self.delegate = delegate
    }
    
    // MARK: - Handlers
    
    func getPhoto() {
        networkManager.getRandomPhoto { [weak self] (res) in
            switch res {
            case .success(let photo):
                self?.delegate?.setPhoto(with: photo.urls.regular)
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
}
