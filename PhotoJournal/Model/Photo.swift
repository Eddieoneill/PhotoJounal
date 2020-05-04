//
//  Photo.swift
//  PhotoJournal
//
//  Created by Edward O'Neill on 5/3/20.
//  Copyright © 2020 Edward O'Neill. All rights reserved.
//

import Foundation

struct  Photo: Codable & Equatable {
      let imageData: Data
      let date: Date
      let title: String
      let id: String
}
