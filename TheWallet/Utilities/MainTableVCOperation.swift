//
//  Screen1TableViewCellCategory.swift
//  MoneyManager
//
//  Created by Roman on 26.01.2021.
//

import UIKit

final class MainTableVCOperation: UITableViewCell {
    @IBOutlet var labelCategory: UILabel!
    @IBOutlet var labelAmount: UILabel!
    @IBOutlet var currencyStatus: UILabel!

    var vcMainDelegate: ProtocolVCMain?
    var id: UUID?

    @objc func showOperation(_ sender: UITapGestureRecognizer) {
        if let id = id {
            do {
                try vcMainDelegate?.showOperation(id)
            } catch {
                vcMainDelegate?.showAlert(message: "showOperation error")
            }
            print("ChangeCategory from Screen2")
        } else {
            vcMainDelegate?.showAlert(message: "showOperation id error")
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
            // Initialization code
        let gesture = UITapGestureRecognizer(target: self, action: #selector(showOperation(_:)))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(gesture)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
