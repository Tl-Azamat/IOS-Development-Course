import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case badResponse
    case decodingError(Error)
    case emptyList
}

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    private let base = "https://cdn.jsdelivr.net/gh/akabab/superhero-api@0.3.0/api"

    func fetchAllSuperheroes(completion: @escaping (Result<[Superhero], NetworkError>) -> Void) {
        guard let url = URL(string: "\(base)/all.json") else {
            completion(.failure(.invalidURL))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }

            guard
                let http = response as? HTTPURLResponse,
                200..<300 ~= http.statusCode,
                let data = data
            else {
                completion(.failure(.badResponse))
                return
            }

            do {
                let decoder = JSONDecoder()
                let heroes = try decoder.decode([Superhero].self, from: data)
                completion(.success(heroes))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }

        task.resume()
    }

    func fetchRandomHero(completion: @escaping (Result<Superhero, NetworkError>) -> Void) {
        fetchAllSuperheroes { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let heroes):
                guard !heroes.isEmpty else {
                    completion(.failure(.emptyList))
                    return
                }

                let randomIndex = Int.random(in: 0..<heroes.count)
                completion(.success(heroes[randomIndex]))
            }
        }
    }
}

