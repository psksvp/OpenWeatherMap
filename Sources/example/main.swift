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
  print(d)
  print(d.coord.lon)
  print(d.main)

}
else
{
  print("fail to fetch")
}
