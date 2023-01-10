//
//  ViewController.swift
//  Weather
//
//  Created by Jamong on 2023/01/10.
//

import UIKit

class ViewController: UIViewController {
	
	// API Request Ui
	@IBOutlet var cityNameTextField: UITextField!
	
	// API Response Ui
	@IBOutlet var citiNameLabel: UILabel!
	@IBOutlet var weatherDescriptionLabel: UILabel!
	@IBOutlet var tempLabel: UILabel!
	@IBOutlet var maxTempLabel: UILabel!
	@IBOutlet var minTempLabel: UILabel!
	
	@IBOutlet var weatherStackView: UIStackView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	// Error Message Alert
	func showAlert(message: String) {
		let alert = UIAlertController(title: "에러", message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}
	
	// API Request Button
	@IBAction func tapFetchWeatherButton(_ sender: UIButton) {
		if let citiName = self.cityNameTextField.text {
			self.getCurrentWeather(cityName: citiName)
			self.view.endEditing(true)
		}
	}
	
	// WeatherView TextUi Update
	func configureView(weatherInformation: WeatherInformation) {
		self.citiNameLabel.text = weatherInformation.name
		if let weather = weatherInformation.weather.first {
			self.weatherDescriptionLabel.text = weather.description
		}
		self.tempLabel.text = "\(Int(weatherInformation.temp.temp - 273.15))°C"
		self.minTempLabel.text = "최저: \(Int(weatherInformation.temp.minTemp - 273.15))°C"
		self.minTempLabel.text = "최고: \(Int(weatherInformation.temp.maxTemp - 273.15))°C"
	}
	
	// API Request-Response
	func getCurrentWeather(cityName: String) {
		guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=489ce281d95c10524d40f109cac7419c") else { return }
		let session = URLSession(configuration: .default)
		session.dataTask(with: url) { [weak self] data, response, error in
			let successRange = (200..<300)
			guard let data = data, error == nil else { return }
			let decoder = JSONDecoder()
			
			// Response Status
			if let response = response as? HTTPURLResponse, successRange.contains(response.statusCode) {
				// Status: 200
				guard let weatherInformation = try? decoder.decode(WeatherInformation.self, from: data) else { return }
				DispatchQueue.main.async {
					self?.weatherStackView.isHidden = false
					self?.configureView(weatherInformation: weatherInformation)
				}
				// Status: 401
			} else {
				guard let errorMesaage = try? decoder.decode(ErrorMessage.self, from: data) else { return }
				DispatchQueue.main.async {
					self?.showAlert(message: errorMesaage.message)
				}
			}
		}.resume()
	}
}
