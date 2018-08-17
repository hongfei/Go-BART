//
// Created by Zhou, Hongfei on 8/10/18.
// Copyright (c) 2018 Hongfei Zhou. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift
import SwiftIcons
import PinLayout

class StationSearchBar: UIView, UITextFieldDelegate {
    var fromSearchBox = SearchBoxField().withPlaceholder(placeholder: "Station")
    var toSearchBox = SearchBoxField().withPlaceholder(placeholder: "Destination")
    var delegate: StationSearchBarDelegate? {
        didSet {
            self.fromSearchBox.addTarget(delegate, action: #selector(StationSearchBarDelegate.onTapFromBox), for: .touchDown)
            self.toSearchBox.addTarget(delegate, action: #selector(StationSearchBarDelegate.onTapToBox), for: .touchDown)
        }
    }

    override var safeAreaInsets: UIEdgeInsets {
        return UIEdgeInsetsMake(5, 5, 5, 5)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = UIColor("#E0E0E0")

        self.fromSearchBox.leftViewMode = .always
        self.fromSearchBox.leftView = UIImageView(image: Icons.searchIcon)
        self.fromSearchBox.rightView = UIImageView(image: Icons.locatingIcon)
        self.fromSearchBox.rightViewMode = .always
        self.fromSearchBox.isUserInteractionEnabled = true

        self.toSearchBox.rightViewMode = .always
        self.toSearchBox.leftView = UIImageView(image: Icons.searchIcon)

        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowOpacity = 0.6

        self.addSubview(self.fromSearchBox)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.fromSearchBox.pin.horizontally(pin.safeArea).top(pin.safeArea).height(35)
        pin.wrapContent(padding: pin.safeArea)
    }

    private func placeToSearchBox() {
        self.addSubview(self.toSearchBox)
        self.toSearchBox.pin.horizontally(pin.safeArea).below(of: self.fromSearchBox).height(35)
        pin.wrapContent(padding: pin.safeArea)
    }

    func reloadStation(from station: Station, to destination: Station?) {
        self.fromSearchBox.text = station.name
        self.fromSearchBox.leftViewMode = .never

        if !self.toSearchBox.isDescendant(of: self) {
            placeToSearchBox()
            self.fromSearchBox.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            self.toSearchBox.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }

        if let dst = destination {
            self.toSearchBox.text = dst.name
            self.toSearchBox.leftViewMode = .never
        } else {
            self.toSearchBox.text = nil
            self.toSearchBox.leftViewMode = .always
        }
    }

}

class SearchBoxField: UITextField {

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: self.center.x - 50, y: 0, width: 100, height: bounds.height)
    }

    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: self.center.x - 65, y: bounds.height / 2 - 10, width: 20, height: 20)
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.maxX - 30, y: bounds.height / 2 - 10, width: 20, height: 20)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = .white
        self.layer.borderColor = UIColor("#D0D0D0").cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        self.textAlignment = .center
    }

    func withPlaceholder(placeholder: String) -> SearchBoxField {
        self.placeholder = placeholder
        return self
    }
}

@objc protocol StationSearchBarDelegate {
    @objc func onTapFromBox(textField: UITextField)

    @objc func onTapToBox(textField: UITextField)
}