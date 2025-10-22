//
//  ViewController.swift
//  RandomizerApp
//
//  Created by Азамат Тлетай on 23.10.2025.
//

import UIKit

struct FavoriteItem {
    let title: String
    let imageName: String
}

class ViewController: UIViewController {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemLabel: UILabel!
    
    let items: [FavoriteItem] = [
        FavoriteItem(title: "Paris", imageName: "paris"),
        FavoriteItem(title: "Tokyo", imageName: "tokyo"),
        FavoriteItem(title: "New York", imageName: "newyork"),
        FavoriteItem(title: "London", imageName: "london"),
        FavoriteItem(title: "Seoul", imageName: "seoul"),
        FavoriteItem(title: "Rome", imageName: "rome"),
        FavoriteItem(title: "Dubai", imageName: "dubai"),
        FavoriteItem(title: "Barcelona", imageName: "barcelona"),
        FavoriteItem(title: "Bangkok", imageName: "bangkok"),
        FavoriteItem(title: "Istanbul", imageName: "istanbul")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        randomizeItem()
    }
    
    @IBAction func randomizeButtonTapped(_ sender: UIButton) {
        randomizeItem()
    }
    
    func randomizeItem() {
        let randomItem = items.randomElement()!
        itemImageView.image = UIImage(named: randomItem.imageName)
        itemLabel.text = randomItem.title
    }
}
