//
//  Cache.swift
//  
//
//  Created by psksvp@gmail.com on 1/12/20.
//

import Foundation


public class Cache<K: Hashable, V>
{
  typealias VALUE = (V, Date)
  private var table = [K : VALUE]()
  private let entryLifeTime: TimeInterval
  
  public init(entryLifeTime t: TimeInterval)
  {
    entryLifeTime = t
  }
  
  public func put(_ key: K, _ value: V)
  {
    table[key] = (value, Date())
  }
  
  public func get(_ key: K) -> V?
  {
    guard let (v, d) = table[key] else {return nil}
    if fabs(d.timeIntervalSinceReferenceDate) >= entryLifeTime
    {
      table.removeValue(forKey: key)
      return nil
    }
    return v
  }
}
