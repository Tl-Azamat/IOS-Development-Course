//
//  ViewController.swift
//  TableView
//
//  Created by Азамат Тлетай on 14.11.2025.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let sections = ["Favorite Movies", "Favorite Music", "Favorite Books", "Favorite Courses"]

    var data: [[FavoriteItem]] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupData()

        tableView.delegate = self
        tableView.dataSource = self

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
    }

    func setupData() {

        let movies = [
            FavoriteItem(imageName: "movie1", title: "Inception", subtitle: "Christopher Nolan", review: "Mind-blowing sci-fi film with stunning visuals."),
            FavoriteItem(imageName: "movie2", title: "Interstellar", subtitle: "Christopher Nolan", review: "Powerful emotional story about space and family."),
            FavoriteItem(imageName: "movie3", title: "Avatar", subtitle: "James Cameron", review: "A beautiful world with amazing CGI."),
            FavoriteItem(imageName: "movie4", title: "Titanic", subtitle: "James Cameron", review: "Romantic story with strong performances."),
            FavoriteItem(imageName: "movie5", title: "Shrek", subtitle: "DreamWorks", review: "Humorous and heartwarming animated classic.")
        ]

        let music = [
            FavoriteItem(imageName: "music1", title: "Eminem", subtitle: "Marshal Mathers LP", review: "Motivational and powerful lyrics."),
            FavoriteItem(imageName: "music2", title: "Drake", subtitle: "Take Care", review: "Relaxing vibe, emotional tracks."),
            FavoriteItem(imageName: "music3", title: "The Weeknd", subtitle: "After Hours", review: "Great vocals and production."),
            FavoriteItem(imageName: "music4", title: "Adele", subtitle: "25", review: "Emotional and touching songs."),
            FavoriteItem(imageName: "music5", title: "Ed Sheeran", subtitle: "Divide", review: "Beautiful melodies and lyrics.")
        ]

        let books = [
            FavoriteItem(imageName: "book1", title: "1984", subtitle: "George Orwell", review: "Deep dystopian story."),
            FavoriteItem(imageName: "book2", title: "The Alchemist", subtitle: "Paulo Coelho", review: "Inspirational journey."),
            FavoriteItem(imageName: "book3", title: "Dune", subtitle: "Frank Herbert", review: "Epic sci-fi universe."),
            FavoriteItem(imageName: "book4", title: "It", subtitle: "Stephen King", review: "Dark and atmospheric."),
            FavoriteItem(imageName: "book5", title: "Atomic Habits", subtitle: "James Clear", review: "Practical self-improvement guide.")
        ]

        let courses = [
            FavoriteItem(imageName: "course1", title: "iOS Development", subtitle: "Mobile Dev", review: "Love building apps!"),
            FavoriteItem(imageName: "course2", title: "Algorithms", subtitle: "CS Dept", review: "Improves problem-solving skills."),
            FavoriteItem(imageName: "course3", title: "Cybersecurity", subtitle: "IT Dept", review: "Important and interesting."),
            FavoriteItem(imageName: "course4", title: "Databases", subtitle: "CS Dept", review: "Useful for backend development."),
            FavoriteItem(imageName: "course5", title: "Networking", subtitle: "IT Dept", review: "Helps understand how systems communicate.")
        ]

        data = [movies, music, books, courses]
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as! FavoriteTableViewCell

        let item = data[indexPath.section][indexPath.row]

        cell.itemImageView.image = UIImage(named: item.imageName)
        cell.titleLabel.text = item.title
        cell.subtitleLabel.text = item.subtitle
        cell.reviewLabel.text = item.review

        return cell
    }

}

