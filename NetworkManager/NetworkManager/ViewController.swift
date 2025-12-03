//
//  ViewController.swift
//  NetworkManager
//
//  Created by Азамат Тлетай on 27.11.2025.
//

import UIKit

final class ViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIStackView()
    private let heroImageView = UIImageView()
    private let nameLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let attributesStack = UIStackView()
    private let randomButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    private var currentHero: Superhero?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        fetchRandomHero(animated: false)
    }

    private func setupUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.axis = .vertical
        contentView.spacing = 12
        contentView.alignment = .fill
        contentView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        heroImageView.translatesAutoresizingMaskIntoConstraints = false
        heroImageView.contentMode = .scaleAspectFill
        heroImageView.clipsToBounds = true
        heroImageView.layer.cornerRadius = 12
        heroImageView.heightAnchor.constraint(equalToConstant: 320).isActive = true

        nameLabel.font = .systemFont(ofSize: 28, weight: .bold)
        nameLabel.numberOfLines = 2

        subtitleLabel.font = .systemFont(ofSize: 14, weight: .regular)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 2

        attributesStack.axis = .vertical
        attributesStack.spacing = 8
        attributesStack.alignment = .leading
        attributesStack.translatesAutoresizingMaskIntoConstraints = false

        randomButton.setTitle("Randomize", for: .normal)
        randomButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        randomButton.layer.cornerRadius = 10
        randomButton.backgroundColor = .systemBlue
        randomButton.tintColor = .white
        randomButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 18, bottom: 12, right: 18)
        randomButton.addTarget(self, action: #selector(randomTapped), for: .touchUpInside)

        activityIndicator.hidesWhenStopped = true

        contentView.addArrangedSubview(heroImageView)
        contentView.addArrangedSubview(nameLabel)
        contentView.addArrangedSubview(subtitleLabel)
        contentView.addArrangedSubview(attributesStack)
        contentView.addArrangedSubview(randomButton)
        contentView.setCustomSpacing(24, after: attributesStack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        randomButton.heightAnchor.constraint(equalToConstant: 48).isActive = true

        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc private func randomTapped() {
        fetchRandomHero(animated: true)
    }

    private func fetchRandomHero(animated: Bool) {
        setLoading(true)
        NetworkManager.shared.fetchRandomHero { [weak self] result in
            DispatchQueue.main.async {
                self?.setLoading(false)
                switch result {
                case .failure(let error):
                    self?.showError(error)
                case .success(let hero):
                    self?.display(hero: hero, animated: animated)
                }
            }
        }
    }

    private func setLoading(_ loading: Bool) {
        if loading {
            activityIndicator.startAnimating()
            randomButton.isEnabled = false
            randomButton.alpha = 0.6
        } else {
            activityIndicator.stopAnimating()
            randomButton.isEnabled = true
            randomButton.alpha = 1
        }
    }

    private func showError(_ error: Error) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Try Again", style: .default) { [weak self] _ in
            self?.fetchRandomHero(animated: true)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alert, animated: true)
    }

    private func display(hero: Superhero, animated: Bool) {
        currentHero = hero
        nameLabel.text = hero.name
        let fullName = (hero.biography.fullName?.isEmpty == false) ? hero.biography.fullName! : "—"
        let publisher = hero.biography.publisher ?? "Unknown"
        subtitleLabel.text = "\(fullName) • \(publisher)"

        attributesStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        addAttribute(title: "Intelligence", value: hero.powerstats.intelligence)
        addAttribute(title: "Strength", value: hero.powerstats.strength)
        addAttribute(title: "Speed", value: hero.powerstats.speed)
        addAttribute(title: "Durability", value: hero.powerstats.durability)
        addAttribute(title: "Power", value: hero.powerstats.power)
        addAttribute(title: "Combat", value: hero.powerstats.combat)

        addAttribute(title: "Gender", value: hero.appearance.gender)
        addAttribute(title: "Race", value: hero.appearance.race)
        addAttribute(title: "Height", value: hero.appearance.height?.joined(separator: " / "))
        addAttribute(title: "Weight", value: hero.appearance.weight?.joined(separator: " / "))
        addAttribute(title: "Eye Color", value: hero.appearance.eyeColor)
        addAttribute(title: "Hair Color", value: hero.appearance.hairColor)

        addAttribute(title: "Occupation", value: hero.work.occupation)
        addAttribute(title: "Base", value: hero.work.base)
        addAttribute(title: "Place of Birth", value: hero.biography.placeOfBirth)
        addAttribute(title: "First Appearance", value: hero.biography.firstAppearance)
        addAttribute(title: "Group Affiliation", value: hero.connections.groupAffiliation)
        addAttribute(title: "Relatives", value: hero.connections.relatives)

        let imageURL = hero.images.lg ?? hero.images.md ?? hero.images.sm ?? hero.images.xs
        if animated {
            heroImageView.alpha = 0
            heroImageView.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        }

        ImageLoader.shared.loadImage(from: imageURL) { [weak self] image in
            guard let self = self else { return }
            self.heroImageView.image = image ?? UIImage(systemName: "person.crop.square")

            if animated {
                UIView.animate(withDuration: 0.45, delay: 0, options: [.curveEaseOut], animations: {
                    self.heroImageView.alpha = 1
                    self.heroImageView.transform = .identity
                })
            }
        }
    }

    private func addAttribute(title: String, value: Int?) {
        addAttribute(title: title, value: value.map { "\($0)" })
    }

    private func addAttribute(title: String, value: String?) {
        let label = UILabel()
        label.numberOfLines = 0

        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 15, weight: .semibold)
        ]
        let valueAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 15, weight: .regular),
            .foregroundColor: UIColor.label
        ]

        let attributed = NSMutableAttributedString(string: "\(title): ", attributes: titleAttributes)
        attributed.append(NSAttributedString(string: value ?? "—", attributes: valueAttributes))
        label.attributedText = attributed
        attributesStack.addArrangedSubview(label)
    }
}
