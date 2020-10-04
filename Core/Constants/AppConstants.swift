//
//  AppConstants.swift
//  Core
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/2/20.
//

import Foundation
import UIKit

public struct AppConstants {
    // Message label tag, used to find a generic view
    public static let messageLabelTag = 999
    // Summary view sizes, that may vary depending on the device
    public static let bigSummarySize: CGFloat = 120.0
    public static let smallSummarySize: CGFloat = 50.0
    // Number of request attempts to success
    public static let requestRetryCount = 3
    // Style information
    public static let inputCornerRadius: CGFloat = 5.0
    public static let imageCornerRadius: CGFloat = 10.0
    public static let defaultShadowOffset = CGSize(width: 3.0, height: 3.0)
    public static let defaultShadowRadius: CGFloat = 3.0
    public static let defaultShadowOpacity: Float = 0.5
    public static let defaultBorderWidth: CGFloat = 1.0
    public static let defaultBorderColor = UIColor.gray.cgColor
    public static let defaultErrorColor = UIColor.red.cgColor
    // The placeholder image to be used when there's no
    // image available
    public static var placeholderImage = UIImage(named: "placeholder")
    public static var starFilledImage = UIImage(named: "star-filled")
    public static var starImage = UIImage(named: "star")
}
