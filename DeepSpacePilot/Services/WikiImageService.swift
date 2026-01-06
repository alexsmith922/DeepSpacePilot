import Foundation

/// Service to fetch images for space objects from Wikipedia
public class WikiImageService {
    public static let shared = WikiImageService()
    
    private init() {}
    
    private let baseURL = "https://en.wikipedia.org/w/api.php"
    
    /// Fetches the URL of a thumbnail image for the given query (e.g. "Messier 1")
    public func fetchImageURL(for query: String) async throws -> URL? {
        // Construct URL components
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "action", value: "query"),
            URLQueryItem(name: "titles", value: query),
            URLQueryItem(name: "prop", value: "pageimages"),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "pithumbsize", value: "500"),
            URLQueryItem(name: "redirects", value: "1")
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        // Decode JSON
        let result = try JSONDecoder().decode(WikiResponse.self, from: data)
        
        // The pages dict has dynamic keys (pageIDs), so we just take the first value
        guard let page = result.query.pages.values.first else {
            return nil
        }
        
        if let source = page.thumbnail?.source {
            return URL(string: source)
        }
        
        return nil
    }
}

// MARK: - API Response Models

private struct WikiResponse: Codable {
    let query: WikiQuery
}

private struct WikiQuery: Codable {
    let pages: [String: WikiPage]
}

private struct WikiPage: Codable {
    let pageid: Int
    let title: String
    let thumbnail: WikiThumbnail?
}

private struct WikiThumbnail: Codable {
    let source: String
    let width: Int
    let height: Int
}
