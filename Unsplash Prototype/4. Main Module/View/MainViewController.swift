
import UIKit
import Combine

protocol MainViewControllerProtocol: AnyObject {
    var viewModel: MainViewModelProtocol { get }
    
    func setupBindings()
    func reloadCollectionView()
    func setupViewsHierarchy()
    func setupViewsLayout()
}

final class MainViewController: UIViewController, MainViewControllerProtocol {
    
    // MARK: State & DI
    
    var viewModel: MainViewModelProtocol
    var mainViewCoordinator: MainViewCoordinator?
    private var searchStackViewCenterYConstraint: NSLayoutConstraint?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: UI-Elements
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Phones, apples, pears..."
        textField.textColor = .newGray
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.backgroundColor = .defaultGray
        textField.textAlignment = .natural
        textField.layer.cornerRadius = 12
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Search", for: .normal)
        button.backgroundColor = .defaultRed
        button.tintColor = .white
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var searchStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var loader: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .gray
        indicator.isHidden = true
        indicator.hidesWhenStopped = true
        indicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UnsplashLayoutCell.self, forCellWithReuseIdentifier: UnsplashLayoutCell.identifier)
        collectionView.backgroundColor = .white
        collectionView.isHidden = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var placeholderStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isHidden = true
        return stack
    }()
    
    private lazy var placeholderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "placeholder")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var noResultsLabel: UILabel = {
        let label = UILabel()
        label.text = "Ничего не найдено"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Initializers
    
    init(viewModel: MainViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if mainViewCoordinator == nil {
            print("Warning: mainViewCoordinator is nil in MainViewController during viewDidLoad")
        } else {
            print("mainViewCoordinator successfully set in MainViewController")
        }
        
        setupViewsHierarchy()
        setupViewsLayout()
        setupBindings()
        reloadCollectionView()
        hidePlaceholder()
    }
    
    // MARK: Setup & Layout
    
    func setupViewsHierarchy() {
        [searchStackView, loader, collectionView, placeholderStackView].forEach {
            view.addSubview($0)
        }
        [searchTextField, searchButton].forEach { searchStackView.addArrangedSubview($0) }
        [placeholderImageView, noResultsLabel].forEach { placeholderStackView.addArrangedSubview($0)}
    }
    
    func setupViewsLayout() {
        addSearchIcon()
        
        let centerYConstraint = searchStackView.centerYAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 255
        )
        searchStackViewCenterYConstraint = centerYConstraint
        
        NSLayoutConstraint.activate([
            searchStackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 15
            ),
            searchStackView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -15
            ),
            centerYConstraint,
            searchTextField.widthAnchor.constraint(greaterThanOrEqualToConstant: 268),
            searchButton.widthAnchor.constraint(equalToConstant: 82),
            searchStackView.heightAnchor.constraint(equalToConstant: 48),
            
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            collectionView.topAnchor.constraint(
                equalTo: searchTextField.bottomAnchor, constant: 20
            ),
            collectionView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 15
            ),
            collectionView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -15
            ),
            collectionView.heightAnchor.constraint(equalToConstant: 878),
            
            placeholderStackView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            placeholderStackView.centerYAnchor.constraint(
                equalTo: view.centerYAnchor
            ),
            placeholderImageView.widthAnchor.constraint(equalToConstant: 200),
            placeholderImageView.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    func setupBindings() {
        viewModel.imagesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] images in
                self?.collectionView.isHidden = images.isEmpty
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.errorPublisher
            .sink { error in
                if let error = error {
                    print("\(error.localizedDescription)")
                }
            }
            .store(in: &cancellables)
        
        viewModel.showNoResults = { [weak self] in
            self?.showPlaceholder()
        }
    }
    
    func reloadCollectionView() {
        viewModel.reloadCollectionView = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    func addSearchIcon() {
        let searchIcon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchIcon.tintColor = .newGray
        searchIcon.translatesAutoresizingMaskIntoConstraints = false
        
        let iconContainerView = UIView()
        iconContainerView.translatesAutoresizingMaskIntoConstraints = false
        iconContainerView.addSubview(searchIcon)
        
        NSLayoutConstraint.activate([
            iconContainerView.widthAnchor.constraint(equalToConstant: 38),
            iconContainerView.heightAnchor.constraint(equalTo: searchIcon.heightAnchor),
            
            searchIcon.leadingAnchor.constraint(equalTo: iconContainerView.leadingAnchor, constant: 10),
            searchIcon.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            searchIcon.widthAnchor.constraint(equalToConstant: 20),
            searchIcon.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        self.searchTextField.leftView = iconContainerView
        self.searchTextField.leftViewMode = .always
    }
    
    // MARK: Actions
    
    @objc
    func searchButtonTapped() {
        guard let query = searchTextField.text, !query.isEmpty else {
            return
        }
        
        searchStackViewCenterYConstraint?.constant = 35
        UIView.animate(withDuration: 0.5) { self.view.layoutIfNeeded() }
        
        collectionView.isHidden = true
        
        activateLoader()
        viewModel.searchImages(query: query)
        deactivateLoader(after: 2.5)
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UnsplashLayoutCell.identifier, for: indexPath) as? UnsplashLayoutCell else {
            return UICollectionViewCell()
        }
        let imageSize: ImageSize = .small
        viewModel.configure(cell: cell, forRow: indexPath.row, size: imageSize)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow: CGFloat = 3
        let width = collectionView.frame.size.width / numberOfItemsPerRow
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedImage = viewModel.getImage(at: indexPath.row) else { return }
        mainViewCoordinator?.showDetailView(for: selectedImage)
    }
}

extension MainViewController {
    private func activateLoader() {
        loader.isHidden = false
        loader.startAnimating()
    }
    
    private func deactivateLoader(after delay: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.loader.stopAnimating()
            self?.collectionView.isHidden = false
        }
    }
    
    private func showPlaceholder() {
        placeholderStackView.isHidden = false
        collectionView.isHidden = true
    }
    
    private func hidePlaceholder() {
        placeholderStackView.isHidden = true
        collectionView.isHidden = false
    }
}

#Preview {
    let testModel = MainViewModel()
    MainViewController(viewModel: testModel)
}

