import AVFoundation
import UIKit

// 🔊 Глобальный синглтон-плеер
class AudioPlayerManager: NSObject {
    static let shared = AudioPlayerManager()
    var player: AVAudioPlayer?
    var currentSong: Song?
    var timer: Timer?
    var isRepeatingList = true // 🔁 Повтор всего списка по умолчанию

    var isPlaying: Bool {
        return player?.isPlaying ?? false
    }

    func play(song: Song) {
        // 🎧 Если это тот же трек — просто продолжаем
        if let current = currentSong,
           current.trackName == song.trackName,
           let player = player {
            if !player.isPlaying {
                player.play()
            }
            return
        }

        // 🎵 Новый трек — создаём заново
        guard let path = Bundle.main.path(forResource: song.trackName, ofType: "mp3") else {
            print("Song not found")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            player?.volume = 0.5
            player?.prepareToPlay()
            player?.delegate = self
            player?.play()
            currentSong = song
            
            // ✅ Уведомляем об изменении текущей песни
            NotificationCenter.default.post(name: NSNotification.Name("currentSongDidChange"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name("playbackStateDidChange"), object: nil)
        } catch {
            print("Error playing song: \(error.localizedDescription)")
        }
    }

    func pause() {
        player?.pause()
        // ✅ Уведомляем об изменении состояния воспроизведения
        NotificationCenter.default.post(name: NSNotification.Name("playbackStateDidChange"), object: nil)
    }
}

extension AudioPlayerManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("songDidFinishPlaying"), object: nil)
    }
}

// MARK: - PlayerViewController
class PlayerViewController: UIViewController {

    public var position: Int = 0
    public var songs: [Song] = []

    @IBOutlet var holder: UIView!

    let audioManager = AudioPlayerManager.shared

    // UI элементы
    private let albumImageView = UIImageView()
    private let songNameLabel = UILabel()
    private let artistNameLabel = UILabel()
    private let playPauseButton = UIButton()
    private let repeatButton = UIButton()
    private let slider = UISlider()
    private let currentTimeLabel = UILabel()
    private let durationLabel = UILabel()
    
    // ✅ ДОБАВЛЯЕМ КНОПКИ КАК СВОЙСТВА КЛАССА
    private let backButton = UIButton()
    private let nextButton = UIButton()
    private let closeButton = UIButton()
    
    // ✅ ДОБАВЛЯЕМ ЭЛЕМЕНТЫ ДИЗАЙНА
    private let backgroundGradientLayer = CAGradientLayer()
    private let blurEffectView = UIVisualEffectView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundDesign() // ✅ ДОБАВЛЯЕМ КРАСИВЫЙ ФОН
        NotificationCenter.default.addObserver(self, selector: #selector(songDidFinishPlaying), name: NSNotification.Name("songDidFinishPlaying"), object: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if holder.subviews.isEmpty {
            configure()
        }
    }
    
    // ✅ КРАСИВЫЙ ФОН ПЛЕЕРА
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
        blurEffectView.alpha = 0.3
        view.insertSubview(blurEffectView, at: 1)
        
        holder.backgroundColor = .clear
    }

    func configure() {
        let song = songs[position]

        // ✅ ВАЖНОЕ ИСПРАВЛЕНИЕ: Всегда обновляем UI для текущей позиции
        setupUI(for: song)
        
        // Если уже играет этот же трек — просто обновляем UI и не перезапускаем
        if audioManager.currentSong?.trackName == song.trackName {
            if audioManager.isPlaying {
                playPauseButton.setBackgroundImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
            } else {
                playPauseButton.setBackgroundImage(UIImage(systemName: "play.circle.fill"), for: .normal)
            }
            startTimer()
            return
        }

        // Если новый трек — запускаем проигрывание
        audioManager.play(song: song)
        startTimer()
    }

    private func setupUI(for song: Song) {
        holder.subviews.forEach { $0.removeFromSuperview() }

        // ✅ КНОПКА ЗАКРЫТИЯ
        closeButton.frame = CGRect(x: 20, y: 50, width: 40, height: 40)
        closeButton.setBackgroundImage(UIImage(systemName: "chevron.down.circle.fill"), for: .normal)
        closeButton.tintColor = .white
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        holder.addSubview(closeButton)

        // ✅ КРАСИВАЯ ОБЛОЖКА С ТЕНЬЮ
        albumImageView.frame = CGRect(x: 40, y: 100,
                                      width: holder.frame.width - 80,
                                      height: holder.frame.width - 80)
        albumImageView.image = UIImage(named: song.imageName)
        albumImageView.contentMode = .scaleAspectFill
        albumImageView.layer.cornerRadius = 20
        albumImageView.clipsToBounds = true
        albumImageView.layer.shadowColor = UIColor.black.cgColor
        albumImageView.layer.shadowOffset = CGSize(width: 0, height: 10)
        albumImageView.layer.shadowRadius = 20
        albumImageView.layer.shadowOpacity = 0.3
        holder.addSubview(albumImageView)

        // ✅ КРАСИВЫЕ НАЗВАНИЯ
        songNameLabel.frame = CGRect(x: 20, y: albumImageView.frame.maxY + 30,
                                     width: holder.frame.width - 40, height: 40)
        songNameLabel.textAlignment = .center
        songNameLabel.font = .systemFont(ofSize: 28, weight: .bold)
        songNameLabel.textColor = .white
        songNameLabel.text = song.name
        holder.addSubview(songNameLabel)

        artistNameLabel.frame = CGRect(x: 20, y: songNameLabel.frame.maxY + 5,
                                       width: holder.frame.width - 40, height: 25)
        artistNameLabel.textAlignment = .center
        artistNameLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        artistNameLabel.font = .systemFont(ofSize: 18, weight: .medium)
        artistNameLabel.text = song.artistName
        holder.addSubview(artistNameLabel)

        // ✅ КРАСИВЫЙ СЛАЙДЕР
        slider.frame = CGRect(x: 60, y: artistNameLabel.frame.maxY + 40,
                              width: holder.frame.width - 120, height: 40)
        slider.minimumValue = 0
        slider.maximumValue = Float(audioManager.player?.duration ?? 0)
        slider.value = 0
        slider.minimumTrackTintColor = .white
        slider.maximumTrackTintColor = UIColor.white.withAlphaComponent(0.3)
        slider.setThumbImage(createThumbImage(), for: .normal)
        slider.addTarget(self, action: #selector(didSlideSlider(_:)), for: .valueChanged)
        holder.addSubview(slider)

        currentTimeLabel.frame = CGRect(x: 20, y: slider.frame.minY, width: 50, height: 30)
        durationLabel.frame = CGRect(x: holder.frame.width - 70, y: slider.frame.minY, width: 50, height: 30)
        currentTimeLabel.font = .systemFont(ofSize: 14, weight: .medium)
        durationLabel.font = .systemFont(ofSize: 14, weight: .medium)
        currentTimeLabel.textColor = .white
        durationLabel.textColor = .white
        currentTimeLabel.text = "0:00"
        durationLabel.text = formatTime(audioManager.player?.duration ?? 0)
        holder.addSubview(currentTimeLabel)
        holder.addSubview(durationLabel)

        // ✅ КРАСИВЫЕ КНОПКИ УПРАВЛЕНИЯ
        let yPosition = slider.frame.maxY + 50
        let buttonSize: CGFloat = 70

        playPauseButton.frame = CGRect(x: (holder.frame.width - buttonSize) / 2,
                                       y: yPosition, width: buttonSize, height: buttonSize)
        playPauseButton.setBackgroundImage(UIImage(systemName: audioManager.isPlaying ? "pause.circle.fill" : "play.circle.fill"), for: .normal)
        playPauseButton.tintColor = .white
        playPauseButton.addTarget(self, action: #selector(didTapPlayPauseButton), for: .touchUpInside)
        holder.addSubview(playPauseButton)

        // ✅ backButton теперь свойство класса
        backButton.frame = CGRect(x: 40, y: yPosition, width: buttonSize, height: buttonSize)
        backButton.setBackgroundImage(UIImage(systemName: "backward.end.circle.fill"), for: .normal)
        backButton.tintColor = .white
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        holder.addSubview(backButton)

        // ✅ nextButton теперь свойство класса
        nextButton.frame = CGRect(x: holder.frame.width - buttonSize - 40, y: yPosition, width: buttonSize, height: buttonSize)
        nextButton.setBackgroundImage(UIImage(systemName: "forward.end.circle.fill"), for: .normal)
        nextButton.tintColor = .white
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        holder.addSubview(nextButton)

        // ✅ КРАСИВАЯ КНОПКА REPEAT
        repeatButton.frame = CGRect(x: (holder.frame.width - 40) / 2, y: yPosition + 90, width: 40, height: 40)
        repeatButton.setBackgroundImage(UIImage(systemName: audioManager.isRepeatingList ? "repeat.circle.fill" : "repeat.circle"), for: .normal)
        repeatButton.tintColor = audioManager.isRepeatingList ? .white : UIColor.white.withAlphaComponent(0.6)
        repeatButton.addTarget(self, action: #selector(didTapRepeatButton), for: .touchUpInside)
        holder.addSubview(repeatButton)
    }
    
    // ✅ СОЗДАЕМ КРАСИВЫЙ ПОЛЗУНОК ДЛЯ СЛАЙДЕРА
    private func createThumbImage() -> UIImage {
        let size = CGSize(width: 20, height: 20)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(UIColor.white.cgColor)
        context?.fillEllipse(in: CGRect(origin: .zero, size: size))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image ?? UIImage()
    }
    
    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Таймер
    func startTimer() {
        audioManager.timer?.invalidate()
        audioManager.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            guard let self = self,
                  let player = self.audioManager.player else { return }
            self.slider.maximumValue = Float(player.duration)
            self.slider.value = Float(player.currentTime)
            self.currentTimeLabel.text = self.formatTime(player.currentTime)
            self.durationLabel.text = self.formatTime(player.duration)
        }
    }

    @objc func didSlideSlider(_ slider: UISlider) {
        audioManager.player?.currentTime = TimeInterval(slider.value)
    }

    // MARK: - Управление
    @objc func didTapBackButton() {
        // ✅ АНИМАЦИЯ КНОПКИ
        UIView.animate(withDuration: 0.1, animations: {
            self.backButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.backButton.transform = .identity
            }
        }
        
        if position > 0 {
            position -= 1
        } else if audioManager.isRepeatingList {
            position = songs.count - 1
        } else {
            return
        }
        configure()
    }

    @objc func didTapNextButton() {
        // ✅ АНИМАЦИЯ КНОПКИ
        UIView.animate(withDuration: 0.1, animations: {
            self.nextButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.nextButton.transform = .identity
            }
        }
        
        if position < songs.count - 1 {
            position += 1
        } else if audioManager.isRepeatingList {
            position = 0
        } else {
            return
        }
        configure()
    }

    @objc func didTapPlayPauseButton() {
        // ✅ АНИМАЦИЯ КНОПКИ
        UIView.animate(withDuration: 0.1, animations: {
            self.playPauseButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.playPauseButton.transform = .identity
            }
        }
        
        if audioManager.isPlaying {
            audioManager.pause()
            playPauseButton.setBackgroundImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        } else {
            let song = songs[position]
            audioManager.play(song: song)
            playPauseButton.setBackgroundImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
        }
        // ✅ Уведомляем об изменении состояния воспроизведения
        NotificationCenter.default.post(name: NSNotification.Name("playbackStateDidChange"), object: nil)
    }

    @objc func didTapRepeatButton() {
        // ✅ АНИМАЦИЯ КНОПКИ
        UIView.animate(withDuration: 0.1, animations: {
            self.repeatButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.repeatButton.transform = .identity
            }
        }
        
        audioManager.isRepeatingList.toggle()
        repeatButton.setBackgroundImage(UIImage(systemName: audioManager.isRepeatingList ? "repeat.circle.fill" : "repeat.circle"), for: .normal)
        repeatButton.tintColor = audioManager.isRepeatingList ? .white : UIColor.white.withAlphaComponent(0.6)
    }

    @objc func songDidFinishPlaying() {
        didTapNextButton()
    }

    func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

}
