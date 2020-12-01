//
//  OpenWeatherData.swift
//
//
//  Created by psksvp@gmail.com on 30/11/20.
//

import Foundation



public class OpenWeather
{
  public enum Unit : CustomStringConvertible
  {
    case standard
    case matric
    case imperial
    
    public var description: String
    {
      switch self
      {
        case .standard: return "standard"
        case .matric  : return "matric"
        case .imperial: return "imperial"
      }
    }
  }
  
  public enum Location
  {
    case name(city: String, state: String, countryCode: String)
    case id(Int)
    case coordinate(latitude: Float, longitude: Float)
  }
  
  //JSON spec from openweathermap.org
  //---------------------------------
  public struct Data : Codable
  {
    public struct Coord : Codable
    {
      public let lon: Float
      public let lat: Float
    }
    
    public struct Weather : Codable
    {
      public let id: Int
      public let main: String
      public let description: String
      public let icon: String
    }
    
    public struct Main : Codable
    {
      public let temp: Float
      public let feels_like: Float
      public let temp_min: Float
      public let temp_max: Float
      public let pressure: Int
      public let humidity: Int
    }
    
    public struct Wind : Codable
    {
      public let speed: Float
      public let deg: Int
      public let gust: Float
    }
    
    public struct Clouds : Codable
    {
      public let all: Int
    }
    
    public struct Sys : Codable
    {
      public let type: Int
      public let id: Int
      public let country: String
      public let sunrise: UInt64
      public let sunset: UInt64
    }
    
    public let coord: Coord
    public let weather: [Weather]
    public let base: String
    public let main: Main
    public let visibility: UInt
    public let wind: Wind
    public let clouds: Clouds
    public let dt: UInt64
    public let sys: Sys
    public let timezone: UInt
    public let id: UInt
    public let name: String
    public let cod: UInt
  }
  
  let apiKey:String
  let base: String
  private let cache: Cache<String, Data>
  
  public init(apiKey a: String,
              baseURL u: String = "https://api.openweathermap.org/data/2.5/weather?",
              entryLife: TimeInterval = interval(hours: 4, minutes: 0, second: 0))
  {
    self.apiKey = a
    cache = Cache<String, Data>(entryLifeTime: entryLife)
    base = u
  }
  
  private func urlFor(_ location: Location, _ unit: Unit = .matric) -> URL?
  {
    func urlString() -> String
    {
      switch location
      {
        case let .name(city, _, countryCode) :
          return "q=\(city),\(countryCode)&units=\(unit.description)&APPID=\(apiKey)"
        
        case let .id(cityId) :
          return "id=\(cityId)&units=\(unit.description)&APPID=\(apiKey)"
        
        case let .coordinate(latitude, longitude) :
          return "lat=\(latitude)&lon=\(longitude)&units=\(unit.description)&APPID=\(apiKey)"
      }
    }
    
    if let url = URL(string: "\(base)\(urlString())")
    {
      return url
    }
    else
    {
      NSLog("malformed URL \(urlString())")
      return nil
    }
  }
  
  public func fetch(location: Location, unit: Unit = .matric) -> OpenWeather.Data?
  {
    guard let url = urlFor(location, unit) else {return nil}
    if let data = cache.get(url.absoluteString)
    {
      return data
    }
    
    do
    {
      NSLog("fetching: \(url)")
      let contents = try String(contentsOf: url)
      let weatherData = try JSONDecoder().decode(OpenWeather.Data.self,
                                                 from: contents.data(using: .utf8)!)
      cache.put(url.absoluteString, weatherData)
      return weatherData
    }
    catch let error
    {
      NSLog("fetching \(url) fail: \(error)")
      return nil
    }
  }
}
