//
//  ImageCacheProvider.swift
//  Core
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/1/20.
//  Copyright © 2020 Fernando Henrique Bonfim Moreno Del Rio. All rights reserved.
//

import UIKit

public protocol ImageCacheProvider {
    func save(_ image: UIImage, for url: URL)
    func retrieve(_ url: URL) -> UIImage?
}
