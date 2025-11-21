//
//  SceneDelegate.swift
//  FavouritesManagerApp
//
//  Created by Азамат Тлетай on 21.11.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // Create Tab Bar Controller
        let tabBarController = UITabBarController()
        
        // Create view controllers
        let moviesVC = MoviesViewController()
        let moviesNav = UINavigationController(rootViewController: moviesVC)
        moviesNav.tabBarItem = UITabBarItem(title: "Movies", image: UIImage(systemName: "film.fill"), tag: 0)
        
        let musicVC = MusicViewController()
        let musicNav = UINavigationController(rootViewController: musicVC)
        musicNav.tabBarItem = UITabBarItem(title: "Music", image: UIImage(systemName: "music.note"), tag: 1)
        
        let booksVC = BooksViewController()
        let booksNav = UINavigationController(rootViewController: booksVC)
        booksNav.tabBarItem = UITabBarItem(title: "Books", image: UIImage(systemName: "book.fill"), tag: 2)
        
        let coursesVC = CoursesViewController()
        let coursesNav = UINavigationController(rootViewController: coursesVC)
        coursesNav.tabBarItem = UITabBarItem(title: "Courses", image: UIImage(systemName: "book.closed.fill"), tag: 3)
        
        // Setup table views for each controller
        setupTableView(for: moviesVC)
        setupTableView(for: musicVC)
        setupTableView(for: booksVC)
        setupTableView(for: coursesVC)
        
        // Set view controllers
        tabBarController.viewControllers = [moviesNav, musicNav, booksNav, coursesNav]
        
        // Create window
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
    
    private func setupTableView(for viewController: UIViewController) {
        // Load view to ensure viewDidLoad is called
        _ = viewController.view
        
        // Create table view
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 80
        tableView.estimatedRowHeight = 80
        tableView.separatorStyle = .singleLine
        
        // Register cell
        tableView.register(FavoriteTableViewCell.self, forCellReuseIdentifier: "FavoriteCell")
        
        // Add to view
        viewController.view.addSubview(tableView)
        
        // Set constraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor)
        ])
        
        // Set outlets using runtime
        if let moviesVC = viewController as? MoviesViewController {
            moviesVC.tableView = tableView
            moviesVC.setupTableView()
            moviesVC.loadSampleData()
            moviesVC.tableView.reloadData()
        } else if let musicVC = viewController as? MusicViewController {
            musicVC.tableView = tableView
            musicVC.setupTableView()
            musicVC.loadSampleData()
            musicVC.tableView.reloadData()
        } else if let booksVC = viewController as? BooksViewController {
            booksVC.tableView = tableView
            booksVC.setupTableView()
            booksVC.loadSampleData()
            booksVC.tableView.reloadData()
        } else if let coursesVC = viewController as? CoursesViewController {
            coursesVC.tableView = tableView
            coursesVC.setupTableView()
            coursesVC.loadSampleData()
            coursesVC.tableView.reloadData()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

