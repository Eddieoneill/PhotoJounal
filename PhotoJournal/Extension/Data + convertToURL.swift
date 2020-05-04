//
//  Data + convertToURL.swift
//  PhotoJournal
//
//  Created by Edward O'Neill on 5/4/20.
//  Copyright © 2020 Edward O'Neill. All rights reserved.
//

import Foundation

extension Data {
    
    public func convertToURL() -> URL? {
        let tempURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("video").appendingPathExtension("mp4")
        do {
            try self.write(to: tempURL, options: [.atomic])
            return tempURL
        } catch {
            print("failed to save \(error)")
        }
        return nil
    }
}
