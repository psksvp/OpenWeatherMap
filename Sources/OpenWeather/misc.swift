//
//  misc.swift
//  
//
//  Created by psksvp@gmail.com on 1/12/20.
//

import Foundation

public func -(lhs: Date, rhs: Date) -> (hours: Int, minutes: Int, second: Int)
{
  let delta = Int(lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate)
  return (delta % 60, (delta / 60) % 60, delta / 3600)
}

public func interval(hours: Int, minutes: Int, second: Int) -> TimeInterval
{
  // TimeInterval: Double = A number of seconds
  return TimeInterval(hours * 3600 + minutes * 60 + second)
}

