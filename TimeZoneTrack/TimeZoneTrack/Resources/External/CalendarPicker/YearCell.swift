//
//  YearCell.swift
//  CalendarCollectionView
//
//  Created by Christina Taflin on 17/09/19.
//  Copyright © 2019 tcs. All rights reserved.
//

import UIKit

class YearCell: UICollectionViewCell {
    static let reuseIdentifierYearCell = String(describing: YearCell.self)
    @IBOutlet weak var lblYear: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
