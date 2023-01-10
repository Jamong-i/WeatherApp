import Foundation

struct WeatherInformation: Codable {
	let weather: [Weather]
	let temp: Temp
	let name: String
	
	enum CodingKeys: String, CodingKey {
		case weather
		case temp = "main"
		case name
	}
}

// API Weather 프로퍼티 정의
struct Weather: Codable {
	let id: Int
	let main: String
	let description: String
	let icon: String
}

// API Main 프로퍼티 정의
struct Temp: Codable {
	let temp: Double
	let fellsLike: Double
	let minTemp: Double
	let maxTemp: Double
	
	// CodingKey mapping (Json To Property)
	enum CodingKeys: String, CodingKey {
		case temp
		case fellsLike = "feels_like"
		case minTemp = "temp_min"
		case maxTemp = "temp_max"
	}
}
