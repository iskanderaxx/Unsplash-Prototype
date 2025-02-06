
import UIKit

final class UnsplashLayoutCell: UICollectionViewCell {
    
    // MARK: State & DI
    
    static let identifier: String = "collectionCell"
    
    // Saving by URL tba
    
    // MARK: UI Elements
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewsHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup & Layout
    
    private func setupViewsHierarchy() {
        contentView.addSubview(imageView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with image: UnsplashImage, size: ImageSize) {
        let urlString = image.urls.url(for: size)
        
        guard let url = URL(string: urlString) else { return }
        
        // prepareForReuse()
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil { return }
            
            // check url with response - from the elements from the beginning, make it with initializer
            
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }.resume()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}

