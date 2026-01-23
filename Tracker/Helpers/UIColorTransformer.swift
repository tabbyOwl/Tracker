//
//  UIColorTransformer.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/21.
//

import UIKit

@objc(UIColorTransformer)
final class UIColorTransformer: ValueTransformer {

    override class func allowsReverseTransformation() -> Bool {
        true
    }

    override class func transformedValueClass() -> AnyClass {
        NSData.self
    }

    override func transformedValue(_ value: Any?) -> Any? {
        guard let color = value as? UIColor else { return nil }

        do {
            return try NSKeyedArchiver.archivedData(
                withRootObject: color,
                requiringSecureCoding: false
            )
        } catch {
            return nil
        }
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }

        do {
            return try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)
        } catch {
            return nil
        }
    }
}
