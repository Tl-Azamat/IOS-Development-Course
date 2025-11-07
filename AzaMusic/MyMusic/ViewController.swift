import UIKit

struct Song {
    let name: String
    let albumName: String
    let artistName: String
    let imageName: String
    let trackName: String
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var table: UITableView!

    var songs = [Song]()
    var currentSong: Song?
    var miniPlayerView: UIView!
    var miniPlayerTitleLabel: UILabel!
    var miniPlayerArtistLabel: UILabel!
    var miniPlayerImageView: UIImageView!
    var miniPlayPauseButton: UIButton!
    
    // ✅ ДОБАВЛЯЕМ ЭЛЕМЕНТЫ ДИЗАЙНА
    private let backgroundGradientLayer = CAGradientLayer()
    private let blurEffectView = UIVisualEffectView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSongs()
        setupBackgroundDesign() // ✅ ДОБАВЛЯЕМ КРАСИВЫЙ ФОН
        setupNavigationBarDesign() // ✅ ДОБАВЛЯЕМ ДИЗАЙН НАВИГАЦИИ
        table.delegate = self
        table.dataSource = self
        setupMiniPlayer()
        
        // ✅ Добавляем наблюдатели для обновления mini player
        NotificationCenter.default.addObserver(self, selector: #selector(currentSongDidChange), name: NSNotification.Name("currentSongDidChange"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playbackStateDidChange), name: NSNotification.Name("playbackStateDidChange"), object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // ✅ КРАСИВЫЙ ФОН С ГРАДИЕНТОМ И БЛЮРОМ
    private func setupBackgroundDesign() {
        // Градиентный фон
        backgroundGradientLayer.frame = view.bounds
        backgroundGradientLayer.colors = [
            UIColor.systemPurple.cgColor,
            UIColor.systemIndigo.cgColor,
            UIColor.systemBlue.cgColor
        ]
        backgroundGradientLayer.locations = [0.0, 0.5, 1.0]
        view.layer.insertSublayer(backgroundGradientLayer, at: 0)
        
        // Блюр эффект
        let blurEffect = UIBlurEffect(style: .dark)
        blurEffectView.effect = blurEffect
        blurEffectView.frame = view.bounds
        blurEffectView.alpha = 0.2
        view.insertSubview(blurEffectView, at: 1)
        
        // Настройка таблицы
        table.backgroundColor = .clear
        table.separatorStyle = .none
    }
    
    // ✅ КРАСИВЫЙ НАВИГЕЙШН БАР
    private func setupNavigationBarDesign() {
        title = "My Music"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Прозрачный navigation bar с блюром
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
    }

    func configureSongs() {
        songs.append(Song(name: "Врываемся",
                          albumName: "",
                          artistName: "HIRO",
                          imageName: "cover4",
                          trackName: "song4"))
        songs.append(Song(name: "Особа Крутая",
                          albumName: "",
                          artistName: "HIRO",
                          imageName: "cover3",
                          trackName: "song6"))
        songs.append(Song(name: "Billie Jean",
                          albumName: "",
                          artistName: "Michael Jackson",
                          imageName: "cover1",
                          trackName: "Michael Jackson - Billie Jean"))
        songs.append(Song(name: "Adjare Gudju",
                          albumName: "",
                          artistName: "HIRO & Ирина Кайратовна",
                          imageName: "cover2",
                          trackName: "HIRO & Ирина Кайратовна - Adjare Gudju"))
        songs.append(Song(name: "10",
                          albumName: "",
                          artistName: "Эндшпиль",
                          imageName: "cover5",
                          trackName: "Эндшпиль - 10"))
    }

    // MARK: - TableView

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let song = songs[indexPath.row]
        
        // ✅ КРАСИВЫЙ ДИЗАЙН ЯЧЕЙКИ
        cell.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        cell.contentView.backgroundColor = .clear
        
        // Текст
        cell.textLabel?.text = song.name
        cell.detailTextLabel?.text = song.artistName
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.textColor = UIColor.white.withAlphaComponent(0.8)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        // Картинка
        cell.imageView?.image = UIImage(named: song.imageName)
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.layer.cornerRadius = 8
        cell.imageView?.clipsToBounds = true
        cell.imageView?.layer.borderWidth = 1
        cell.imageView?.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        
        // Стрелочка
        let disclosureImage = UIImage(systemName: "play.circle.fill")
        cell.accessoryView = UIImageView(image: disclosureImage)
        (cell.accessoryView as? UIImageView)?.tintColor = .white
        
        // Скругленные углы
        cell.layer.cornerRadius = 12
        cell.clipsToBounds = true
        
        // Выделение
        let selectionView = UIView()
        selectionView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        cell.selectedBackgroundView = selectionView
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80 // ✅ Увеличили высоту для лучшего вида
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // ✅ АНИМАЦИЯ НАЖАТИЯ
        if let cell = tableView.cellForRow(at: indexPath) {
            UIView.animate(withDuration: 0.2, animations: {
                cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }) { _ in
                UIView.animate(withDuration: 0.2) {
                    cell.transform = .identity
                }
            }
        }
        
        let song = songs[indexPath.row]
        currentSong = song
        updateMiniPlayer(with: song)

        // открыть PlayerViewController (он воспроизводит песню)
        guard let vc = storyboard?.instantiateViewController(identifier: "player") as? PlayerViewController else {
            return
        }
        vc.songs = songs
        vc.position = indexPath.row
        present(vc, animated: true)
    }

    // MARK: - Mini Player Setup

    func setupMiniPlayer() {
        let height: CGFloat = 80 // ✅ Увеличили высоту
        
        miniPlayerView = UIView(frame: CGRect(x: 10, // ✅ Добавили отступы по бокам
                                              y: view.frame.size.height - height - view.safeAreaInsets.bottom - 10,
                                              width: view.frame.size.width - 20, // ✅ Учитываем отступы
                                              height: height))
        
        // ✅ КРАСИВЫЙ ДИЗАЙН MINI PLAYER
        miniPlayerView.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        miniPlayerView.layer.cornerRadius = 20
        miniPlayerView.layer.shadowColor = UIColor.black.cgColor
        miniPlayerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        miniPlayerView.layer.shadowRadius = 12
        miniPlayerView.layer.shadowOpacity = 0.3
        
        // Блюр эффект
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = miniPlayerView.bounds
        blurView.layer.cornerRadius = 20
        blurView.clipsToBounds = true
        miniPlayerView.addSubview(blurView)

        miniPlayerImageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 60, height: 60))
        miniPlayerImageView.contentMode = .scaleAspectFill
        miniPlayerImageView.layer.cornerRadius = 10
        miniPlayerImageView.clipsToBounds = true
        miniPlayerImageView.layer.borderWidth = 1
        miniPlayerImageView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        miniPlayerView.addSubview(miniPlayerImageView)

        miniPlayerTitleLabel = UILabel(frame: CGRect(x: 80, y: 15, width: view.frame.size.width - 180, height: 25))
        miniPlayerTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        miniPlayerTitleLabel.textColor = .white
        miniPlayerView.addSubview(miniPlayerTitleLabel)

        miniPlayerArtistLabel = UILabel(frame: CGRect(x: 80, y: 40, width: view.frame.size.width - 180, height: 20))
        miniPlayerArtistLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        miniPlayerArtistLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        miniPlayerView.addSubview(miniPlayerArtistLabel)

        miniPlayPauseButton = UIButton(frame: CGRect(x: view.frame.size.width - 70, y: 20, width: 40, height: 40))
        miniPlayPauseButton.setBackgroundImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        miniPlayPauseButton.tintColor = .white
        miniPlayPauseButton.addTarget(self, action: #selector(didTapMiniPlayPause), for: .touchUpInside)
        miniPlayerView.addSubview(miniPlayPauseButton)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapMiniPlayer))
        miniPlayerView.addGestureRecognizer(tapGesture)

        view.addSubview(miniPlayerView)
        miniPlayerView.isHidden = true
    }

    func updateMiniPlayer(with song: Song) {
        miniPlayerImageView.image = UIImage(named: song.imageName)
        miniPlayerTitleLabel.text = song.name
        miniPlayerArtistLabel.text = song.artistName
        
        let isPlaying = AudioPlayerManager.shared.isPlaying
        let imageName = isPlaying ? "pause.circle.fill" : "play.circle.fill"
        miniPlayPauseButton.setBackgroundImage(UIImage(systemName: imageName), for: .normal)
        
        // ✅ АНИМАЦИЯ ПОЯВЛЕНИЯ
        if miniPlayerView.isHidden {
            miniPlayerView.isHidden = false
            miniPlayerView.alpha = 0
            miniPlayerView.transform = CGAffineTransform(translationX: 0, y: 50)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut) {
                self.miniPlayerView.alpha = 1
                self.miniPlayerView.transform = .identity
            }
        }
    }

    // ✅ Обработчик изменения текущей песни
    @objc func currentSongDidChange(_ notification: Notification) {
        if let song = AudioPlayerManager.shared.currentSong {
            currentSong = song
            updateMiniPlayer(with: song)
        }
    }

    // ✅ Обработчик изменения состояния воспроизведения
    @objc func playbackStateDidChange(_ notification: Notification) {
        let isPlaying = AudioPlayerManager.shared.isPlaying
        let imageName = isPlaying ? "pause.circle.fill" : "play.circle.fill"
        
        UIView.animate(withDuration: 0.3) {
            self.miniPlayPauseButton.setBackgroundImage(UIImage(systemName: imageName), for: .normal)
        }
    }

    @objc func didTapMiniPlayPause() {
        let audioManager = AudioPlayerManager.shared
        
        // ✅ АНИМАЦИЯ КНОПКИ
        UIView.animate(withDuration: 0.1, animations: {
            self.miniPlayPauseButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.miniPlayPauseButton.transform = .identity
            }
        }
        
        if audioManager.isPlaying {
            audioManager.pause()
        } else {
            if let song = currentSong {
                audioManager.play(song: song)
            }
        }
    }

    @objc func didTapMiniPlayer() {
        guard let song = currentSong else { return }
        // ✅ ИСПРАВЛЕННЫЙ вызов firstIndex
        guard let index = songs.firstIndex(where: { $0.trackName == song.trackName }) else { return }
        guard let vc = storyboard?.instantiateViewController(identifier: "player") as? PlayerViewController else { return }
        vc.songs = songs
        vc.position = index
        present(vc, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // ✅ ОБНОВЛЯЕМ ФОН ПРИ ПОВОРОТЕ
        backgroundGradientLayer.frame = view.bounds
        blurEffectView.frame = view.bounds
        
        // Обновляем позицию mini player
        if miniPlayerView != nil && !miniPlayerView.isHidden {
            let height: CGFloat = 80
            miniPlayerView.frame = CGRect(x: 10,
                                          y: view.frame.size.height - height - view.safeAreaInsets.bottom - 10,
                                          width: view.frame.size.width - 20,
                                          height: height)
        }
    }
}
