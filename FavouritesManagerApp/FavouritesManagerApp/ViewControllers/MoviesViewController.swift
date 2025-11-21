//
//  MoviesViewController.swift
//  FavouritesManagerApp
//
//  Created by Азамат Тлетай on 21.11.2025.
//

import UIKit

class MoviesViewController: UIViewController {
    var tableView: UITableView!
    
    private var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movies"
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
        movies = [
            Movie(title: "Inception", imageName: nil, description: "A thief who steals corporate secrets through dream-sharing technology is given the inverse task of planting an idea into the mind of a C.E.O.", review: "Mind-bending and stylish. Christopher Nolan's masterpiece."),
            Movie(title: "The Dark Knight", imageName: nil, description: "When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.", review: "Heath Ledger's performance is phenomenal. One of the best superhero movies ever."),
            Movie(title: "Interstellar", imageName: nil, description: "A team of explorers travel through a wormhole in space in an attempt to ensure humanity's survival.", review: "Visually stunning and emotionally powerful. A cinematic experience."),
            Movie(title: "The Matrix", imageName: nil, description: "A computer hacker learns from mysterious rebels about the true nature of his reality and his role in the war against its controllers.", review: "Revolutionary visual effects and thought-provoking story."),
            Movie(title: "Pulp Fiction", imageName: nil, description: "The lives of two mob hitmen, a boxer, a gangster and his wife, and a pair of diner bandits intertwine in four tales of violence and redemption.", review: "Quentin Tarantino's iconic masterpiece. Brilliant dialogue and storytelling."),
            Movie(title: "Fight Club", imageName: nil, description: "An insomniac office worker and a devil-may-care soapmaker form an underground fight club that evolves into something much bigger.", review: "Dark, provocative, and unforgettable. Brad Pitt at his best."),
            Movie(title: "The Shawshank Redemption", imageName: nil, description: "Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.", review: "A timeless tale of hope and friendship. One of the greatest films ever made."),
            Movie(title: "Forrest Gump", imageName: nil, description: "The presidencies of Kennedy and Johnson, the Vietnam War, the Watergate scandal and other historical events unfold from the perspective of an Alabama man with an IQ of 75.", review: "Tom Hanks delivers an outstanding performance. Heartwarming and inspiring."),
            Movie(title: "The Godfather", imageName: nil, description: "The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.", review: "The epitome of cinematic excellence. Marlon Brando is legendary."),
            Movie(title: "Goodfellas", imageName: nil, description: "The story of Henry Hill and his life in the mob, covering his relationship with his wife Karen Hill and his partners.", review: "Martin Scorsese's brilliant direction. A gripping crime epic."),
            Movie(title: "Avatar", imageName: nil, description: "A paraplegic marine dispatched to the moon Pandora on a unique mission becomes torn between following his orders and protecting the world he feels is his home.", review: "Groundbreaking visual effects. James Cameron's epic masterpiece."),
            Movie(title: "Titanic", imageName: nil, description: "A seventeen-year-old aristocrat falls in love with a kind but poor artist aboard the luxurious, ill-fated R.M.S. Titanic.", review: "Epic romance and disaster film. Leonardo DiCaprio and Kate Winslet shine.")
        ]
        tableView?.reloadData()
    }
}

extension MoviesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as? FavoriteTableViewCell else {
            return UITableViewCell()
        }
        
        let movie = movies[indexPath.row]
        let image = UIImage(named: movie.imageName ?? "") ?? UIImage(systemName: "film.fill")
        cell.configure(withTitle: movie.title, image: image)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let movie = movies[indexPath.row]
        let detailVC = DetailViewController.instantiate()
        detailVC.configure(
            withImage: UIImage(named: movie.imageName ?? "") ?? UIImage(systemName: "film.fill"),
            titleText: movie.title,
            descriptionText: movie.description,
            reviewText: movie.review
        )
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
