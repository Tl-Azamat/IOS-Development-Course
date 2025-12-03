//
//  BooksViewController.swift
//  FavouritesManagerApp
//
//  Created by Азамат Тлетай on 21.11.2025.
//

import UIKit

class BooksViewController: UIViewController {
    var tableView: UITableView!
    
    private var books: [Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Books"
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
        books = [
            Book(title: "1984", author: "George Orwell", imageName: "book1", description: "A dystopian novel set in a totalitarian society where Big Brother watches everyone. Winston Smith rebels against the oppressive regime.", review: "Chilling and prophetic. Orwell's vision remains relevant today."),
            Book(title: "To Kill a Mockingbird", author: "Harper Lee", imageName: "book2", description: "A young girl in the American South watches her father, a lawyer, defend a black man falsely accused of rape in the 1930s.", review: "A powerful story about justice, prejudice, and growing up. Atticus Finch is an iconic character."),
            Book(title: "The Great Gatsby", author: "F. Scott Fitzgerald", imageName: "book3", description: "A tale of decadence and excess in Jazz Age America. Jay Gatsby's obsession with Daisy Buchanan leads to tragedy.", review: "Fitzgerald's prose is beautiful and haunting. A masterpiece of American literature."),
            Book(title: "Pride and Prejudice", author: "Jane Austen", imageName: "book4", description: "Elizabeth Bennet and Mr. Darcy's journey from prejudice and misunderstanding to love and understanding.", review: "Austen's wit and social commentary are timeless. A perfect romance novel."),
            Book(title: "The Catcher in the Rye", author: "J.D. Salinger", imageName: "book5", description: "Holden Caulfield's coming-of-age story as he navigates adolescence and alienation in New York City.", review: "Salinger captures teenage angst perfectly. Holden's voice is unforgettable."),
            Book(title: "One Hundred Years of Solitude", author: "Gabriel García Márquez", imageName: "book6", description: "The multi-generational saga of the Buendía family in the fictional town of Macondo, blending realism and magical realism.", review: "Márquez's magical realism at its finest. A masterpiece of world literature."),
            Book(title: "The Lord of the Rings", author: "J.R.R. Tolkien", imageName: "book7", description: "Frodo Baggins's epic quest to destroy the One Ring and save Middle-earth from the Dark Lord Sauron.", review: "Tolkien's world-building is unparalleled. The definitive fantasy epic."),
            Book(title: "Moby-Dick", author: "Herman Melville", imageName: "book8", description: "Captain Ahab's obsessive quest for revenge against the white whale that took his leg. A profound meditation on obsession and fate.", review: "Melville's epic is dense but rewarding. Ahab's monomania is haunting."),
            Book(title: "War and Peace", author: "Leo Tolstoy", imageName: "book9", description: "A sweeping historical novel following several aristocratic families during Napoleon's invasion of Russia.", review: "Tolstoy's masterpiece. Epic in scope and profound in insight."),
            Book(title: "The Brothers Karamazov", author: "Fyodor Dostoevsky", imageName: "book10", description: "A philosophical novel exploring faith, doubt, and morality through the story of three brothers and their father's murder.", review: "Dostoevsky's deepest work. The Grand Inquisitor chapter alone is worth the read."),
            Book(title: "The Picture of Dorian Gray", author: "Oscar Wilde", imageName: "book11", description: "Dorian Gray's portrait ages while he remains young, exploring themes of beauty, morality, and corruption.", review: "Wilde's wit and decadence shine. A dark and beautiful novel."),
            Book(title: "Crime and Punishment", author: "Fyodor Dostoevsky", imageName: "book12", description: "Raskolnikov, a poor student, murders a pawnbroker and grapples with guilt and redemption in St. Petersburg.", review: "Dostoevsky's psychological insight is unmatched. Raskolnikov's torment is palpable.")
        ]
        tableView?.reloadData()
    }
}

extension BooksViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as? FavoriteTableViewCell else {
            return UITableViewCell()
        }
        
        let book = books[indexPath.row]
        let image = UIImage(named: book.imageName ?? "") ?? UIImage(systemName: "book.fill")
        let titleText = "\(book.title)\nby \(book.author)"
        cell.configure(withTitle: titleText, image: image)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let book = books[indexPath.row]
        let detailVC = DetailViewController.instantiate()
        let titleText = "\(book.title)\nby \(book.author)"
        detailVC.configure(
            withImage: UIImage(named: book.imageName ?? "") ?? UIImage(systemName: "book.fill"),
            titleText: titleText,
            descriptionText: book.description,
            reviewText: book.review
        )
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
