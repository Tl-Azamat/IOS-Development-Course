import UIKit
import Kingfisher

class HeroViewController: UIViewController {

    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let heroImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.heightAnchor.constraint(equalToConstant: 220).isActive = true
        return iv
    }()

    private let nameLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: 28)
        l.numberOfLines = 2
        l.textAlignment = .center
        return l
    }()

    private let realNameLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 16)
        l.numberOfLines = 2
        l.textAlignment = .center
        l.textColor = .secondaryLabel
        return l
    }()

    private lazy var statsCard: UIView = makeCardView()
    private lazy var infoCard: UIView = makeCardView()

    private let statsTitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Power Stats"
        l.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return l
    }()

    private let infoTitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Hero Details"
        l.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return l
    }()

    private let statsStack = UIStackView()
    private let infoStack = UIStackView()

    private let randomizeButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Randomize", for: .normal)
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        b.backgroundColor = .systemBlue
        b.setTitleColor(.white, for: .normal)
        b.layer.cornerRadius = 12
        b.contentEdgeInsets = UIEdgeInsets(top: 14, left: 20, bottom: 14, right: 20)
        return b
    }()

    private let activity = UIActivityIndicatorView(style: .large)

    private let errorLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 14)
        l.textColor = .systemRed
        l.numberOfLines = 0
        l.isHidden = true
        return l
    }()

    // Data
    private var allHeroes: [Hero] = []
    private var currentHero: Hero?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Superhero Randomizer"
        setupViews()
        randomizeButton.addTarget(self, action: #selector(randomizeTapped), for: .touchUpInside)

        // Restore last hero if exists
        if let saved = Persistence.loadLastHero() {
            configure(with: saved, animated: false)
            // Also fetch fresh copy in background by ID (optional)
            APIService.shared.fetchHero(by: saved.id) { [weak self] result in
                switch result {
                case .success(let hero):
                    DispatchQueue.main.async {
                        self?.configure(with: hero, animated: true)
                        Persistence.saveLastHero(hero)
                    }
                case .failure:
                    break // keep saved hero if fetch fails
                }
            }
        } else {
            // No saved hero -> fetch all and randomize initial
            fetchAllAndShowRandom()
        }
    }

    // MARK: - Setup UI
    private func setupViews() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])

        let mainStack = UIStackView(arrangedSubviews: [heroImageView, nameLabel, realNameLabel, statsCard, infoCard, errorLabel, randomizeButton])
        mainStack.axis = .vertical
        mainStack.spacing = 16
        mainStack.alignment = .fill
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.layoutMargins = UIEdgeInsets(top: 24, left: 20, bottom: 24, right: 20)
        mainStack.isLayoutMarginsRelativeArrangement = true

        contentView.addSubview(mainStack)
        contentView.addSubview(activity)
        activity.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            activity.centerXAnchor.constraint(equalTo: heroImageView.centerXAnchor),
            activity.centerYAnchor.constraint(equalTo: heroImageView.centerYAnchor)
        ])
        setupStatsSection()
        setupInfoSection()
    }

    // MARK: - Networking flows
    private func fetchAllAndShowRandom() {
        setLoading(true)
        APIService.shared.fetchAllHeroes { [weak self] result in
            DispatchQueue.main.async {
                self?.setLoading(false)
                switch result {
                case .success(let heroes):
                    self?.allHeroes = heroes
                    self?.showRandomFromAll()
                case .failure(let err):
                    self?.showError("Не удалось загрузить список героев:\n\(err.localizedDescription)")
                }
            }
        }
    }

    @objc private func randomizeTapped() {
        if !allHeroes.isEmpty {
            showRandomFromAll()
        } else {
            fetchAllAndShowRandom()
        }
    }

    private func showRandomFromAll() {
        guard !allHeroes.isEmpty else {
            showError("Список героев пуст.")
            return
        }
        let idx = Int.random(in: 0..<allHeroes.count)
        let hero = allHeroes[idx]
        configure(with: hero, animated: true)
        Persistence.saveLastHero(hero)
    }

    // MARK: - UI updates
    private func configure(with hero: Hero, animated: Bool) {
        currentHero = hero
        errorLabel.isHidden = true

        nameLabel.text = hero.name
        realNameLabel.text = "Full name: \(hero.biography?.fullName ?? "—")"

        let imgUrlString = hero.images?.lg ?? hero.images?.md ?? hero.images?.sm ?? hero.images?.xs
        if let s = imgUrlString, let url = URL(string: s) {
            if animated {
                heroImageView.alpha = 0
                heroImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder")) { [weak self] _ in
                    UIView.animate(withDuration: 0.35) {
                        self?.heroImageView.alpha = 1
                    }
                }
            } else {
                heroImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
            }
        } else {
            heroImageView.image = UIImage(named: "placeholder")
        }

        statsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let stats = hero.powerstats
        let statPairs: [(String, Int?)] = [
            ("Int", stats.intelligence),
            ("Str", stats.strength),
            ("Spd", stats.speed),
            ("Dur", stats.durability),
            ("Pow", stats.power),
            ("Cmb", stats.combat)
        ]
        for (label, value) in statPairs {
            let v = makeStatView(title: label, value: value)
            statsStack.addArrangedSubview(v)
        }

        infoStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        addInfoRow(title: "Alignment", value: hero.biography?.alignment)
        addInfoRow(title: "Race", value: hero.appearance?.race)
        addInfoRow(title: "Gender", value: hero.appearance?.gender)
        addInfoRow(title: "Place of birth", value: hero.biography?.placeOfBirth)
        addInfoRow(title: "Publisher", value: hero.biography?.publisher)
        addInfoRow(title: "Occupation", value: hero.work?.occupation)
        addInfoRow(title: "Base", value: hero.work?.base)
        addInfoRow(title: "First Appearance", value: hero.biography?.firstAppearance)
        addInfoRow(title: "Group affiliation", value: hero.connections?.groupAffiliation)
        addInfoRow(title: "Aliases", value: hero.biography?.aliases?.joined(separator: ", "))
    }

    private func makeStatView(title: String, value: Int?) -> UIView {
        let container = UIStackView()
        container.axis = .vertical
        container.alignment = .center
        container.spacing = 4

        let t = UILabel()
        t.text = title
        t.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        t.textColor = .secondaryLabel

        let v = UILabel()
        v.font = UIFont.monospacedDigitSystemFont(ofSize: 18, weight: .bold)
        v.text = value != nil ? "\(value!)" : "—"

        container.addArrangedSubview(t)
        container.addArrangedSubview(v)
        return container
    }

    private func addInfoRow(title: String, value: String?) {
        let row = UIStackView()
        row.axis = .horizontal
        row.spacing = 8
        row.alignment = .top

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        titleLabel.textColor = .secondaryLabel
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        let valueLabel = UILabel()
        valueLabel.font = UIFont.systemFont(ofSize: 15)
        valueLabel.textColor = .label
        valueLabel.text = value?.isEmpty == false ? value : "—"
        valueLabel.numberOfLines = 0
        valueLabel.textAlignment = .right

        row.addArrangedSubview(titleLabel)
        row.addArrangedSubview(valueLabel)
        infoStack.addArrangedSubview(row)
    }

    private func setupStatsSection() {
        statsStack.axis = .horizontal
        statsStack.distribution = .fillEqually
        statsStack.spacing = 12

        let statsCardStack = UIStackView(arrangedSubviews: [statsTitleLabel, statsStack])
        statsCardStack.axis = .vertical
        statsCardStack.spacing = 12

        statsCard.addSubview(statsCardStack)
        statsCardStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statsCardStack.topAnchor.constraint(equalTo: statsCard.topAnchor, constant: 16),
            statsCardStack.leadingAnchor.constraint(equalTo: statsCard.leadingAnchor, constant: 16),
            statsCardStack.trailingAnchor.constraint(equalTo: statsCard.trailingAnchor, constant: -16),
            statsCardStack.bottomAnchor.constraint(equalTo: statsCard.bottomAnchor, constant: -16)
        ])
    }

    private func setupInfoSection() {
        infoStack.axis = .vertical
        infoStack.spacing = 12

        let infoCardStack = UIStackView(arrangedSubviews: [infoTitleLabel, infoStack])
        infoCardStack.axis = .vertical
        infoCardStack.spacing = 12

        infoCard.addSubview(infoCardStack)
        infoCardStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoCardStack.topAnchor.constraint(equalTo: infoCard.topAnchor, constant: 16),
            infoCardStack.leadingAnchor.constraint(equalTo: infoCard.leadingAnchor, constant: 16),
            infoCardStack.trailingAnchor.constraint(equalTo: infoCard.trailingAnchor, constant: -16),
            infoCardStack.bottomAnchor.constraint(equalTo: infoCard.bottomAnchor, constant: -16)
        ])
    }

    private func makeCardView() -> UIView {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1 / UIScreen.main.scale
        view.layer.borderColor = UIColor.separator.cgColor
        return view
    }

    // MARK: - Loading & Error UI
    private func setLoading(_ loading: Bool) {
        if loading {
            activity.startAnimating()
            randomizeButton.isEnabled = false
        } else {
            activity.stopAnimating()
            randomizeButton.isEnabled = true
        }
    }

    private func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false

        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}


