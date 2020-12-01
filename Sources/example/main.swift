//
//  main.swift
//  
//
//  Created by psksvp on 30/11/20.
//

import Foundation
import OpenWeather


let ow = OpenWeather(apiKey: "OPENWEATHERMAP_API_KEY")
if let d = ow.fetch(location: .name(city: "Sydney", state: "NSW", countryCode: "AU"))
{
  print("current temperature is \(d.main.temp)")
}
else
{
  print("fail to fetch")
}
