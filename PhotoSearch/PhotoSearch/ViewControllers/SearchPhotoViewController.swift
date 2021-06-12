import UIKit
import PinLayout

protocol SearchPhotoViewProtocol: AnyObject {
    func reloadView()
    func changeIsPaginated(newValue: Bool)
}

class SearchPhotoViewController: UIViewController {
    
    // MARK: - Properties
    
    private var presenter: SearchPhotoPresenterProtocol = SearchPhotoPresenter()
    
    private let searchBar = UISearchBar()
    private let collectionView: UICollectionView
    
    private var page: Int = 1
    private var isPaginated: Bool = false
    
    // MARK: - Init
        
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
        layout.itemSize = CGSize(width: view.frame.width / 2, height: view.frame.width / 2)
        presenter.setDelegate(with: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.getPhotos(page: 1, query: "")
        
        view.backgroundColor = .systemBackground
        configureCollectionView()
        configureSearchBar()
        view.addSubview(searchBar)
        view.addSubview(collectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        searchBar.pin
            .top(view.pin.safeArea.top + 10)
            .horizontally()
            .height(40)
        
        collectionView.pin
            .below(of: searchBar)
            .horizontally()
            .bottom(view.pin.safeArea.bottom)
    }
    
    // MARK: - Configures
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.description().description)
    }
    
    private func configureSearchBar() {
        searchBar.delegate = self
    }

    // MARK: - Handlers

}

extension SearchPhotoViewController: SearchPhotoViewProtocol {
    func reloadView() {
        collectionView.reloadData()
    }
    
    func changeIsPaginated(newValue: Bool) {
        isPaginated = newValue
    }
}

extension SearchPhotoViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.photosCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let id = ImageCollectionViewCell.description().description
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: presenter.getImageURL(for: indexPath.row))
        return cell
    }
    
}

extension SearchPhotoViewController: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if isPaginated {
            return
        }
        if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height {
            guard let query = searchBar.text else { return }
            isPaginated = true
            page += 1
            presenter.getPhotos(page: page, query: query)
        }
    }
}

extension SearchPhotoViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let query = searchBar.text else { return }
        presenter.getPhotos(page: 1, query: query)
    }
}
