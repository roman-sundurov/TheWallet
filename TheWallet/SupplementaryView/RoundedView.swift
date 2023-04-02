//
//  RoundedView.swift
//  TheWallet
//
//  Created by Roman on 31.12.2022.
//

import UIKit

@IBDesignable
final class RoundedView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewSetup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewSetup()
    }

    func viewSetup() {
        // self.layer.borderColor = UIColor(named: "TextFieldBorderColor")?.cgColor
        // self.layer.borderWidth = 2
        self.layer.cornerRadius = 10
    }
}
