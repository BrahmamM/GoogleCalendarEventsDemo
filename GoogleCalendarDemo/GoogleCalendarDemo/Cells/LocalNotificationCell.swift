//
//  LocalNotificationCell.swift
//  SampleAuthenticationDemoApp
//
//  Created by Kalpita on 05/09/22.
//

import UIKit

class LocalNotificationCell: UITableViewCell {
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var myCellLabel: UILabel!
    @IBOutlet weak var switchaction: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
