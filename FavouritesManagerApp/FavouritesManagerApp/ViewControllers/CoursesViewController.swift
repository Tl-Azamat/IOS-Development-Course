//
//  CoursesViewController.swift
//  FavouritesManagerApp
//
//  Created by Азамат Тлетай on 21.11.2025.
//

import UIKit

class CoursesViewController: UIViewController {
    var tableView: UITableView!
    
    private var courses: [Course] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Courses"
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
        courses = [
            Course(title: "iOS Development with Swift", instructor: "Apple Inc.", imageName: nil, description: "Learn to build iOS apps using Swift and Xcode. Covering UIKit, SwiftUI, and best practices for iOS development.", review: "Comprehensive and well-structured. Perfect for beginners and experienced developers."),
            Course(title: "Advanced Algorithms", instructor: "Stanford University", imageName: nil, description: "Deep dive into data structures, graph algorithms, dynamic programming, and algorithm design techniques.", review: "Challenging but rewarding. Taught by world-class professors."),
            Course(title: "Machine Learning Specialization", instructor: "Andrew Ng", imageName: nil, description: "Master machine learning fundamentals, neural networks, and deep learning with hands-on projects.", review: "Andrew Ng's teaching style is excellent. Practical and theoretical balance."),
            Course(title: "Web Development Bootcamp", instructor: "Colt Steele", imageName: nil, description: "Full-stack web development covering HTML, CSS, JavaScript, Node.js, React, and databases.", review: "Comprehensive course that takes you from zero to full-stack developer."),
            Course(title: "UI/UX Design Fundamentals", instructor: "Google Design", imageName: nil, description: "Learn design thinking, user research, prototyping, and visual design principles for digital products.", review: "Well-structured curriculum with real-world examples. Great for beginners."),
            Course(title: "Data Science with Python", instructor: "DataCamp", imageName: nil, description: "Master data analysis, visualization, and machine learning using Python, pandas, NumPy, and scikit-learn.", review: "Hands-on approach with lots of exercises. Excellent for learning by doing."),
            Course(title: "Blockchain Development", instructor: "Coursera", imageName: nil, description: "Build decentralized applications using Ethereum, Solidity, and Web3. Understanding of blockchain technology and smart contracts.", review: "Cutting-edge content. Perfect introduction to blockchain development."),
            Course(title: "DevOps Engineering", instructor: "Udemy", imageName: nil, description: "Learn Docker, Kubernetes, CI/CD pipelines, infrastructure as code, and cloud deployment strategies.", review: "Practical DevOps skills that are in high demand. Great for career advancement."),
            Course(title: "Cybersecurity Fundamentals", instructor: "SANS Institute", imageName: nil, description: "Introduction to cybersecurity principles, network security, cryptography, and ethical hacking techniques.", review: "Comprehensive security education. Taught by industry experts."),
            Course(title: "Mobile App Design", instructor: "Designlab", imageName: nil, description: "Master mobile app design principles, user interface patterns, and prototyping tools for iOS and Android.", review: "Excellent design course with mentorship. Real-world portfolio projects."),
            Course(title: "SwiftUI Mastery", instructor: "Hacking with Swift", imageName: nil, description: "Complete guide to SwiftUI framework, building modern iOS apps with declarative syntax and reactive programming.", review: "Paul Hudson's teaching is engaging. Perfect for modern iOS development."),
            Course(title: "Advanced React Development", instructor: "Kent C. Dodds", imageName: nil, description: "Deep dive into React hooks, performance optimization, testing strategies, and advanced patterns.", review: "Kent is an excellent teacher. Advanced concepts explained clearly.")
        ]
        tableView?.reloadData()
    }
}

extension CoursesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as? FavoriteTableViewCell else {
            return UITableViewCell()
        }
        
        let course = courses[indexPath.row]
        let image = UIImage(named: course.imageName ?? "") ?? UIImage(systemName: "book.closed.fill")
        let titleText = "\(course.title)\nby \(course.instructor)"
        cell.configure(withTitle: titleText, image: image)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let course = courses[indexPath.row]
        let detailVC = DetailViewController.instantiate()
        let titleText = "\(course.title)\nby \(course.instructor)"
        detailVC.configure(
            withImage: UIImage(named: course.imageName ?? "") ?? UIImage(systemName: "book.closed.fill"),
            titleText: titleText,
            descriptionText: course.description,
            reviewText: course.review
        )
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
