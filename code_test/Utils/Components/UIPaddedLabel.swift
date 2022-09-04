//
//  UIPaddedLabel.swift
//  code_test
//
//  Created by Thinzar Soe on 9/3/22.
//

import UIKit

public class UIPaddedLabel: UILabel {

    @IBInspectable var topInset: CGFloat = 0
    @IBInspectable var bottomInset: CGFloat = 0
    @IBInspectable var leftInset: CGFloat = 15.0
    @IBInspectable var rightInset: CGFloat = 0

    public override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    public override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }

    public override func sizeToFit() {
        super.sizeThatFits(intrinsicContentSize)
    }
}

