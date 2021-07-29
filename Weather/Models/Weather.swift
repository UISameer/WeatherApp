import Foundation

// MARK: - CurrentWeather
struct CurrentWeather: Codable {
    var coord: Coord?
    var weather: [Weather]?
    var base: String?
    var main: Main?
    var visibility: Int?
    var wind: Wind?
    var rain: Rain?
    var clouds: Clouds?
    var dt: Int?
    var sys: Sys?
    var timezone: Int?
    var id: Int?
    var name: String?
    var cod: Int?
    
    enum CodingKeys: String, CodingKey {
        case coord
        case weather
        case base
        case main
        case visibility
        case wind
        case rain
        case clouds
        case dt
        case sys
        case timezone
        case id
        case name
        case cod
    }
}

// MARK: - Clouds
struct Clouds: Codable {
    var all: Int?
    
    enum CodingKeys: String, CodingKey {
        case all
    }
}

// MARK: - Coord
struct Coord: Codable {
    var lon: Int?
    var lat: Int?
    
    enum CodingKeys: String, CodingKey {
        case lon
        case lat
    }
}

// MARK: - Main
struct Main: Codable {
    var temp: Double?
    var feelsLike: Double?
    var tempMin: Double?
    var tempMax: Double?
    var pressure: Int?
    var humidity: Int?
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike
        case tempMin
        case tempMax
        case pressure
        case humidity
    }
}

// MARK: - Rain
struct Rain: Codable {
    var the1H: Double?
    
    enum CodingKeys: String, CodingKey {
        case the1H
    }
}

// MARK: - Sys
struct Sys: Codable {
    var type: Int?
    var id: Int?
    var sunrise: Int?
    var sunset: Int?
    
    enum CodingKeys: String, CodingKey {
        case type
        case id
        case sunrise
        case sunset
    }
}

// MARK: - Weather
struct Weather: Codable {
    var id: Int?
    var main: String?
    var weatherDescription: String?
    var icon: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case main
        case weatherDescription
        case icon
    }
}

// MARK: - Wind
struct Wind: Codable {
    var speed: Double?
    var deg: Int?
    var gust: Double?
    
    enum CodingKeys: String, CodingKey {
        case speed
        case deg
        case gust
    }
}
