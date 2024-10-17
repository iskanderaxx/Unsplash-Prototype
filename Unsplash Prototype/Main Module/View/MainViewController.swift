
import UIKit

final class MainViewController: UIViewController {
    
    // MARK: State & DI
    
    private let viewModel = UnsplashViewModel()
    
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
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadCollectionView()
        setupViewsHierarchy()
        setupViewsLayout()
    }
    
    // MARK: Setup & Layout
    
    private func reloadCollectionView() {
        viewModel.reloadCollectionView = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    func setupViewsHierarchy() {
        [searchStackView, loader, collectionView].forEach {
            view.addSubview($0)
        }
        [searchTextField, searchButton].forEach { searchStackView.addArrangedSubview($0) }
    }
    
    func setupViewsLayout() {
        addSearchIcon()
        
        NSLayoutConstraint.activate([
            searchStackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 15
            ),
            searchStackView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -15
            ),
            searchStackView.centerYAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 255
            ),
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
            collectionView.heightAnchor.constraint(equalToConstant: 878)
        ])
    }
    
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
            // To be filled with alert
            return
        }
        
        NSLayoutConstraint.activate([
            searchStackView.centerYAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35
            )
        ])
        UIView.animate(withDuration: 0.5) { self.view.layoutIfNeeded() }
        
        collectionView.isHidden = true
        
        activateLoader()
        viewModel.searchImages(query: query)
        deactivateLoader(after: 2.5)
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UnsplashLayoutCell.identifier, for: indexPath) as? UnsplashLayoutCell else {
            return UICollectionViewCell()
        }
        viewModel.configure(cell: cell, forRow: indexPath.row)
        return cell
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow: CGFloat = 3
        let width = collectionView.frame.size.width / numberOfItemsPerRow
        return CGSize(width: width, height: width)
    }
}

#Preview {
    MainViewController()
}

