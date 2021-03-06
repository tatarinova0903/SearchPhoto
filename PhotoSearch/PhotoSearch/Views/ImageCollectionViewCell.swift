import UIKit
import PinLayout
import Kingfisher

class ImageCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.systemIndigo.withAlphaComponent(0.5)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override functions
    
    override func layoutSubviews() {
        super.layoutSubviews()
                
        imageView.pin
            .all(10)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    // MARK: - Configures
    
    func configure(with imageURL: String) {
        let url = URL(string: imageURL)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url)
    }
    
    // MARK: - Handlers
    
    func getImage() -> UIImage? {
        imageView.image
    }
}
