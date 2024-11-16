
import UIKit
import Combine

protocol DetailViewControllerProtocol: AnyObject {
    var viewModel: DetailViewModel { get }
    func setupViewsHierarchy()
    func setupViewsLayout()
    func configureImage()
}

final class DetailViewController: UIViewController, DetailViewControllerProtocol {
    
    // MARK: State & DI
    
    var viewModel: DetailViewModel
    
    // MARK: UI-Elements
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: Initializers
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
        isModalInPresentation = true
//        configurePresentationMode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewsHierarchy()
        setupViewsLayout()
        configureImage()
    }
    
    // MARK: Setup & Layout
    
    func setupViewsHierarchy() {
        [imageView, closeButton].forEach { view.addSubview($0) }
        view.backgroundColor = .white
    }
    
    func setupViewsLayout() {
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            
            imageView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 30),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ])
    }
    
    func configureImage() {
        let imageUrl = viewModel.image.urls.full
        if let url = URL(string: imageUrl), let data = try? Data(contentsOf: url) {
            imageView.image = UIImage(data: data)
        }
    }
    
//    func configurePresentationMode() {
//        modalPresentationStyle = .fullScreen
//        isModalInPresentation = true
//    }
    
    // MARK: Actions
    
    @objc
    func closeButtonTapped() {
        viewModel.dismissDetailView()
    }
}
