//
//  NSImageCacheProvider.swift
//  Cloud
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 9/30/20.
//

import Core
import UIKit

public class NSImageCacheProvider: ImageCacheProvider {
    // The cache uses NSCache to handle temporary
    // transient data
    private var cache = NSCache<NSString, UIImage>()

    public init() {
    }

    public func save(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url.absoluteString as NSString)
    }

    public func retrieve(_ url: URL) -> UIImage? {
        cache.object(forKey: url.absoluteString as NSString)
    }
}
