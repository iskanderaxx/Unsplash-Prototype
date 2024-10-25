
import UIKit

final class UnsplashLayoutCell: UICollectionViewCell {
    
    static let identifier: String = "collectionCell"
    
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
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data)
                }
            }
        }
    }
}

extension UnsplashLayoutCell {
    
    // Метод для проверки кэширвоания картинок с логированием
    
    //    func configure(with image: UnsplashImage, size: ImageSize) {
    //        let imageName = image.id
    //        let urlString = image.urls.url(for: size)
    //
    //        if let cachedImageName = ImageRepository.shared.checkIfCachedImage(for: imageName) {
    //            if let cacheDirectory = UnsplashFileManager.cacheDirectory {
    //                let filePath = cacheDirectory.appendingPathComponent("\(cachedImageName).jpg")
    //                if let data = try? Data(contentsOf: filePath), let cachedImage = UIImage(data: data) {
    //                    print("Изображение загружено из кэша: \(cachedImageName)")
    //                    DispatchQueue.main.async {
    //                        self.imageView.image = cachedImage
    //                    }
    //                    return
    //                }
    //            }
    //        }
    //
    //        print("Попытка загрузить изображение по URL: \(urlString)")
    //
    //        guard let url = URL(string: urlString) else { return }
    //
    //        DispatchQueue.global().async {
    //            if let data = try? Data(contentsOf: url) {
    //                DispatchQueue.main.async {
    //                    print("Изображение загружено из сети: \(urlString)")
    //                    self.imageView.image = UIImage(data: data)
    //                    ImageRepository.shared.cacheImage(from: data, for: imageName)
    //                }
    //            } else {
    //                print("Ошибка загрузки изображения: \(urlString)")
    //            }
    //        }
    //    }
}

