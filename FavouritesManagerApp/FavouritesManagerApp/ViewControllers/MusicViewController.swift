//
//  MusicViewController.swift
//  FavouritesManagerApp
//
//  Created by Азамат Тлетай on 21.11.2025.
//

import UIKit

class MusicViewController: UIViewController {
    var tableView: UITableView!
    
    private var songs: [Song] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Music"
        // setupTableView() and loadSampleData() are called from SceneDelegate after tableView is set
    }
    
    func setupTableView() {
        guard tableView != nil else { return }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        tableView.estimatedRowHeight = 80
        tableView.separatorStyle = .singleLine
    }
    
    func loadSampleData() {
        songs = [
            Song(title: "Bohemian Rhapsody", artist: "Queen", imageName: "music1", description: "A six-minute suite, notable for its lack of a refraining chorus and consisting of several sections: an intro, a ballad segment, an operatic passage, a hard rock part and a reflective coda.", review: "Freddie Mercury's masterpiece. A revolutionary piece of music."),
            Song(title: "Stairway to Heaven", artist: "Led Zeppelin", imageName: "music2", description: "Often considered one of the greatest rock songs of all time. It features a slow acoustic guitar introduction, building to an electric guitar climax.", review: "Jimmy Page's guitar work is legendary. A timeless classic."),
            Song(title: "Hotel California", artist: "Eagles", imageName: "music3", description: "The song is an allegory about hedonism and self-destruction in Southern California during the late 1970s.", review: "Hauntingly beautiful. Don Felder's guitar solo is iconic."),
            Song(title: "Like a Rolling Stone", artist: "Bob Dylan", imageName: "music4", description: "A six-minute folk-rock epic that transformed popular music. Dylan's poetic lyrics and electric backing created a new sound.", review: "Bob Dylan at his finest. Changed the landscape of music."),
            Song(title: "Imagine", artist: "John Lennon", imageName: "music5", description: "A song that calls for peace and unity. Lennon's vision of a world without borders, religions, or possessions.", review: "Profound and moving. A message that still resonates today."),
            Song(title: "Smells Like Teen Spirit", artist: "Nirvana", imageName: "music6", description: "The song that brought grunge to the mainstream. Kurt Cobain's raw energy and emotion defined a generation.", review: "The anthem of Generation X. Nirvana's greatest hit."),
            Song(title: "Thunder Road", artist: "Bruce Springsteen", imageName: "music7", description: "Opening track of Born to Run, capturing the desperation and hope of youth in small-town America.", review: "Springsteen's storytelling at its best. Pure rock poetry."),
            Song(title: "A Day in the Life", artist: "The Beatles", imageName: "music8", description: "A song in two parts: Lennon's verses about a news story and death, and McCartney's middle section about a man waking up.", review: "The Beatles' experimental peak. Sgt. Pepper's masterpiece."),
            Song(title: "Gimme Shelter", artist: "The Rolling Stones", imageName: "music9", description: "A dark and powerful song about the turmoil of the late 1960s. Merry Clayton's backing vocals are unforgettable.", review: "The Stones' most intense track. Haunting and powerful."),
            Song(title: "What's Going On", artist: "Marvin Gaye", imageName: "music10", description: "A soulful protest song addressing war, poverty, and social injustice. Gaye's smooth vocals over a laid-back groove.", review: "Marvin Gaye's social commentary masterpiece. Timeless relevance."),
            Song(title: "Purple Rain", artist: "Prince", imageName: "music11", description: "An epic power ballad featuring Prince's signature guitar work and emotional vocals. The title track of his iconic album.", review: "Prince's magnum opus. Emotional and powerful."),
            Song(title: "Layla", artist: "Eric Clapton", imageName: "music12", description: "A love song written for Pattie Boyd. The song features two distinct parts: a hard rock section and a piano coda.", review: "Duane Allman's slide guitar is mesmerizing. Clapton's passion is palpable.")
        ]
        tableView?.reloadData()
    }
}

extension MusicViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as? FavoriteTableViewCell else {
            return UITableViewCell()
        }
        
        let song = songs[indexPath.row]
        let image = UIImage(named: song.imageName ?? "") ?? UIImage(systemName: "music.note")
        let titleText = "\(song.title) - \(song.artist)"
        cell.configure(withTitle: titleText, image: image)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let song = songs[indexPath.row]
        let detailVC = DetailViewController.instantiate()
        let titleText = "\(song.title)\nby \(song.artist)"
        detailVC.configure(
            withImage: UIImage(named: song.imageName ?? "") ?? UIImage(systemName: "music.note"),
            titleText: titleText,
            descriptionText: song.description,
            reviewText: song.review
        )
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
