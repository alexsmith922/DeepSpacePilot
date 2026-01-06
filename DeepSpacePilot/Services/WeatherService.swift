import Foundation

public class WeatherService {
    public static let shared = WeatherService()
    
    private init() {}
    
    struct OpenMeteoResponse: Codable {
        let current: CurrentWeather
        
        struct CurrentWeather: Codable {
            let time: String
            let interval: Int
            let cloud_cover: Double
        }
    }
    
    public func fetchCurrentCloudCover(latitude: Double, longitude: Double) async throws -> Double {
        // Open-Meteo API
        // https://api.open-meteo.com/v1/forecast?latitude=52.52&longitude=13.41&current=cloud_cover
        
        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&current=cloud_cover"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoder = JSONDecoder()
        let result = try decoder.decode(OpenMeteoResponse.self, from: data)
        
        // Return 0.0 to 1.0
        return result.current.cloud_cover / 100.0
    }
}
