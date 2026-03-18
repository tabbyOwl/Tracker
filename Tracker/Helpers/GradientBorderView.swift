//
//  GradientBorderView.swift
//  Tracker
//
//  Created by Svetlana on 2026/3/16.
//
import UIKit

class GradientBorderView: UIView {

    private let gradientLayer = CAGradientLayer()
    private let shapeLayer = CAShapeLayer()

    var borderWidth: CGFloat = 1 {
        didSet { setNeedsLayout() }
    }

    var colors: [UIColor] = [] {
        didSet { gradientLayer.colors = colors.map { $0.cgColor } }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        layer.addSublayer(gradientLayer)
        gradientLayer.mask = shapeLayer

        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = borderWidth

        gradientLayer.colors = colors.map { $0.cgColor }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        gradientLayer.frame = bounds

        let path = UIBezierPath(
            roundedRect: bounds.insetBy(dx: borderWidth / 3, dy: borderWidth / 3),
            cornerRadius: layer.cornerRadius
        )

        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = borderWidth
        shapeLayer.strokeColor = UIColor.black.cgColor
        
    }
}
