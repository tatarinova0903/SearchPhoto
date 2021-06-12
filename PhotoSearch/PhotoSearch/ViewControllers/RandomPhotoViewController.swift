import UIKit
import PinLayout
import Kingfisher

protocol RandomPhotoViewProtocol: AnyObject {
    func setPhoto(with urlStr: String)
}

class RandomPhotoViewController: UIViewController {
    
    // MARK: - Properties
    
    private var presenter: RandomPhotoPresenterProtocol = RandomPhotoPresenter()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.systemIndigo.withAlphaComponent(0.5)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let generateButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemIndigo
        button.setTitle("Generate", for: .normal)
        button.addTarget(self, action: #selector(generateButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
    
    init() {
        super.init(nibName: nil, bundle: nil)
        presenter.setDelegate(with: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override functions

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Random"
        view.backgroundColor = .systemBackground
        
        view.addSubview(imageView)
        view.addSubview(generateButton)        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        imageView.pin
            .top(view.pin.safeArea.top + 70)
            .hCenter()
            .size(CGSize(width: UIScreen.main.bounds.width / 1.5, height: UIScreen.main.bounds.width / 1.5))
        
        generateButton.pin
            .below(of: imageView, aligned: .center)
            .marginTop(40)
            .size(CGSize(width: UIScreen.main.bounds.width / 3, height: 40))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        generateButton.layer.cornerRadius = generateButton.frame.height / 2
    }
    
    // MARK: - Configures
    
    
    // MARK: - Handlers

    @objc
    func generateButtonTapped() {
        imageView.image = nil
        presenter.getPhoto()
    }
}


extension RandomPhotoViewController: RandomPhotoViewProtocol {
    func setPhoto(with urlStr: String) {
        let url = URL(string: urlStr)
        imageView.kf.setImage(with: url)
    }
}
