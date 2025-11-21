//
//  DetailViewController.swift
//  FavouritesManagerApp
//
//  Created by Азамат Тлетай on 21.11.2025.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var reviewLabel: UILabel!
    
    // Store data temporarily if outlets aren't loaded yet
    private var storedImage: UIImage?
    private var storedTitle: String?
    private var storedDescription: String?
    private var storedReview: String?
    
    static func instantiate() -> DetailViewController {
        // Create programmatically since we're not using Storyboard for this controller
        // If you later add it to Storyboard, uncomment the code below:
        /*
        do {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            if let vc = sb.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
                return vc
            }
        } catch {
            // Fall through to programmatic creation
        }
        */
        return DetailViewController()
    }
    
    func configure(withImage image: UIImage?, titleText: String, descriptionText: String, reviewText: String) {
        // Store data
        storedImage = image
        storedTitle = titleText
        storedDescription = descriptionText
        storedReview = reviewText
        
        // Update UI if outlets are loaded
        updateUI()
    }
    
    private func updateUI() {
        imageView?.image = storedImage
        titleLabel?.text = storedTitle
        descriptionTextView?.text = storedDescription
        reviewLabel?.text = storedReview
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If outlets are nil, create UI programmatically
        if imageView == nil {
            setupProgrammaticUI()
        }
        
        // Configure description text view
        descriptionTextView?.isEditable = false
        descriptionTextView?.isScrollEnabled = true
        descriptionTextView?.font = UIFont.systemFont(ofSize: 16)
        descriptionTextView?.textColor = .label
        
        // Configure title label
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 28)
        titleLabel?.numberOfLines = 0
        titleLabel?.textColor = .label
        
        // Configure review label
        reviewLabel?.font = UIFont.italicSystemFont(ofSize: 15)
        reviewLabel?.numberOfLines = 0
        reviewLabel?.textColor = .secondaryLabel
        
        // Configure image view
        imageView?.contentMode = .scaleAspectFill
        imageView?.clipsToBounds = true
        imageView?.layer.cornerRadius = 12
        
        // Set background
        view.backgroundColor = .systemBackground
        
        // Update UI with stored data
        updateUI()
    }
    
    private func setupProgrammaticUI() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // Create image view
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 12
        imgView.backgroundColor = .systemGray5
        contentView.addSubview(imgView)
        imageView = imgView
        
        // Create title label
        let titleLbl = UILabel()
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        titleLbl.font = UIFont.boldSystemFont(ofSize: 28)
        titleLbl.numberOfLines = 0
        titleLbl.textColor = .label
        contentView.addSubview(titleLbl)
        titleLabel = titleLbl
        
        // Create description text view
        let descTextView = UITextView()
        descTextView.translatesAutoresizingMaskIntoConstraints = false
        descTextView.isEditable = false
        descTextView.isScrollEnabled = false
        descTextView.font = UIFont.systemFont(ofSize: 16)
        descTextView.textColor = .label
        descTextView.backgroundColor = .clear
        contentView.addSubview(descTextView)
        descriptionTextView = descTextView
        
        // Create review label
        let reviewLbl = UILabel()
        reviewLbl.translatesAutoresizingMaskIntoConstraints = false
        reviewLbl.font = UIFont.italicSystemFont(ofSize: 15)
        reviewLbl.numberOfLines = 0
        reviewLbl.textColor = .secondaryLabel
        contentView.addSubview(reviewLbl)
        reviewLabel = reviewLbl
        
        // Set constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            imgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            imgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            imgView.heightAnchor.constraint(equalTo: imgView.widthAnchor, multiplier: 9.0/16.0),
            
            titleLbl.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 16),
            titleLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            descTextView.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 12),
            descTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
            
            reviewLbl.topAnchor.constraint(equalTo: descTextView.bottomAnchor, constant: 12),
            reviewLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            reviewLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            reviewLbl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}
