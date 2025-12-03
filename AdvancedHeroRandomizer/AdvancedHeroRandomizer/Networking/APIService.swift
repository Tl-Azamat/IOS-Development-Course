import Foundation
import Alamofire

final class APIService {
    static let shared = APIService()
    private init() {}

    private let baseURL = "https://akabab.github.io/superhero-api/api"

    // Получить весь список героев (returns [Hero])
    func fetchAllHeroes(completion: @escaping (Result<[Hero], AFError>) -> Void) {
        let url = "\(baseURL)/all.json"
        AF.request(url)
            .validate()
            .responseDecodable(of: [Hero].self) { response in
                completion(response.result)
            }
    }

    // Получить героя по id (если захочешь восстанавливать по ID)
    func fetchHero(by id: Int, completion: @escaping (Result<Hero, AFError>) -> Void) {
        let url = "\(baseURL)/id/\(id).json"
        AF.request(url)
            .validate()
            .responseDecodable(of: Hero.self) { response in
                completion(response.result)
            }
    }
}


