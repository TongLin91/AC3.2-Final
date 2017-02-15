//
//  FeedTableViewCell.swift
//  AC3.2-Final
//
//  Created by Tong Lin on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import SnapKit

class FeedTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        setupViewHierarchy()
        configureConstraints()
        
    }
    
    
    func setupViewHierarchy(){
        self.contentView.addSubview(mainImageView)
        self.contentView.addSubview(commentLabel)
    }
    
    func configureConstraints(){
        mainImageView.snp.makeConstraints { (view) in
            view.top.leading.trailing.equalToSuperview()
            view.height.equalTo(self.contentView.frame.width)
        }
        
        commentLabel.snp.makeConstraints { (view) in
            view.top.equalTo(mainImageView.snp.bottom).offset(10)
            view.leading.equalToSuperview().offset(10)
            view.trailing.equalToSuperview().offset(10)
            view.bottom.equalToSuperview().offset(-20)
        }
    }

    //MARK: - Lazy inits
    lazy var mainImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    lazy var commentLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 12)
        view.textAlignment = .left
        view.numberOfLines = 0
        return view
    }()
}
