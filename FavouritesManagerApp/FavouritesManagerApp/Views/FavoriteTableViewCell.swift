//
//  FavoriteTableViewCell.swift
//  FavouritesManagerApp
//
//  Created by Азамат Тлетай on 21.11.2025.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    private var programmaticImageView: UIImageView!
    private var programmaticTitleLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupProgrammaticUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        // IBOutlets will be set from storyboard
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupImageView()
        setupTitleLabel()
    }
    
    private func setupProgrammaticUI() {
        // Create image view
        programmaticImageView = UIImageView()
        programmaticImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(programmaticImageView)
        setupImageView(imageView: programmaticImageView)
        
        // Create title label
        programmaticTitleLabel = UILabel()
        programmaticTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(programmaticTitleLabel)
        setupTitleLabel(label: programmaticTitleLabel)
        
        // Set constraints
        NSLayoutConstraint.activate([
            programmaticImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            programmaticImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            programmaticImageView.bottomAnchor.constraint(greaterThanOrEqualTo: contentView.bottomAnchor, constant: -8),
            programmaticImageView.widthAnchor.constraint(equalToConstant: 60),
            programmaticImageView.heightAnchor.constraint(equalToConstant: 60),
            
            programmaticTitleLabel.leadingAnchor.constraint(equalTo: programmaticImageView.trailingAnchor, constant: 12),
            programmaticTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            programmaticTitleLabel.centerYAnchor.constraint(equalTo: programmaticImageView.centerYAnchor)
        ])
    }
    
    private func setupImageView(imageView: UIImageView? = nil) {
        let imgView = imageView ?? thumbImageView
        imgView?.layer.cornerRadius = 8
        imgView?.clipsToBounds = true
        imgView?.contentMode = .scaleAspectFill
    }
    
    private func setupTitleLabel(label: UILabel? = nil) {
        let lbl = label ?? titleLabel
        lbl?.numberOfLines = 2
        lbl?.font = UIFont.systemFont(ofSize: 17)
    }
    
    func configure(withTitle title: String, image: UIImage?) {
        let imgView = thumbImageView ?? programmaticImageView
        let lbl = titleLabel ?? programmaticTitleLabel
        
        lbl?.text = title
        imgView?.image = image ?? UIImage(systemName: "photo")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        let imgView = thumbImageView ?? programmaticImageView
        let lbl = titleLabel ?? programmaticTitleLabel
        
        imgView?.image = nil
        lbl?.text = nil
    }
}
