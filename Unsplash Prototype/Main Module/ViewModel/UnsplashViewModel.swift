
import Foundation

final class UnsplashViewModel {
    
    // MARK: State & DI
    
    private let service = NetworkService()
    var images: [UnsplashImage] = []
    var reloadCollectionView: (() -> Void)?
    
    // MARK: VM Methods
    
    func searchImages(query: String) {
        service.fetchImages(query: query) { [weak self] result in
            switch result {
            case .success(let images):
                self?.images = images

                DispatchQueue.main.async {
                    self?.reloadCollectionView?()
                }
                
            case .failure:
                print(UnsplashError.fetchingFailure.localizedDescription)
            }
        }
    }
    
    func numberOfRows() -> Int {
        images.count
    }
    
    func configure(cell: UnsplashLayoutCell, forRow row: Int) {
        let image = images[row]
        cell.configure(with: image.urls.small)
        
        saveImage(from: image.urls.small, with: image.id)
    }
    
    private func saveImage(from url: String, with imageName: String) {
        guard let url = URL(string: url) else { return }
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                UnsplashFileManager.shared.saveImage(from: data, with: imageName)
            }
        }
    }
}
