//
//  ViewController.swift
//  DiceeApp
//
//  Created by Азамат Тлетай on 22.10.2025.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var leftDiceImageView: UIImageView!
    @IBOutlet weak var rightDiceImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Actions
    @IBAction func rollButtonPressed(_ sender: UIButton) {
        let diceArray = [
            UIImage(named: "dice1"),
            UIImage(named: "dice2"),
            UIImage(named: "dice3"),
            UIImage(named: "dice4"),
            UIImage(named: "dice5"),
            UIImage(named: "dice6")
        ]
        
        // выбираем случайные значения
        leftDiceImageView.image = diceArray.randomElement() ?? UIImage(named: "dice1")
        rightDiceImageView.image = diceArray.randomElement() ?? UIImage(named: "dice1")
    }
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            rollButtonPressed(UIButton())
        }
    }

}


