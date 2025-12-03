import UIKit

final class ImageLoader {
    static let shared = ImageLoader()
    private init() {}

    private let cache = NSCache<NSURL, UIImage>()

    func loadImage(from url: URL?, completion: @escaping (UIImage?) -> Void) {
        guard let url = url else {
            completion(nil)
            return
        }

        if let cached = cache.object(forKey: url as NSURL) {
            completion(cached)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self = self else { return }

            var image: UIImage?
            if let data = data {
                image = UIImage(data: data)
            }

            if let image = image {
                self.cache.setObject(image, forKey: url as NSURL)
            }

            DispatchQueue.main.async {
                completion(image)
            }
        }

        task.resume()
    }
}

