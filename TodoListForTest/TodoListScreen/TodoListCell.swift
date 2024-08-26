//
//  TodoListCell.swift
//  TodoListForTest
//
//  Created by Даниил on 25.08.2024.
//

import UIKit

final class TodoListCell: UICollectionViewCell {
    private let labelDescr = UILabel()
    private let labelTitle = UILabel()
    private let labelStatus = UILabel()
    
    private let buttonConstraint: CGFloat = 8
    private let horizontalConstraint: CGFloat = 16
    
    func config(descr: String, title: String, status: Bool) {
        self.labelDescr.text = "Описание: " + descr
        self.labelTitle.text = "Номер: " + title
        self.labelStatus.text = status ? "Выполнена" : "Не выполнена"
        self.labelStatus.textColor = status ? .green : .red
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        settingCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension TodoListCell {
    func settingCell() {
        contentView.backgroundColor = .white
        settingLabel()
    }
    
    func settingLabel() {
        labelTitle.applyForCel(fonsSize: 18, fontWeight: .bold)
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelTitle)
        
        NSLayoutConstraint.activate(
            [
                labelTitle.topAnchor.constraint(equalTo: contentView.topAnchor),
                labelTitle.leadingAnchor.constraint(
                    equalTo: contentView.leadingAnchor,
                    constant: horizontalConstraint
                ),
                labelTitle.trailingAnchor.constraint(
                    equalTo: contentView.trailingAnchor
                ),
            ]
        )
        
        labelDescr.applyForCel(fonsSize: 16, fontWeight: .regular)
        labelDescr.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelDescr)
        
        NSLayoutConstraint.activate(
            [
                labelDescr.topAnchor.constraint(
                    equalTo: labelTitle.bottomAnchor,
                    constant: buttonConstraint
                ),
                
                labelDescr.leadingAnchor.constraint(
                    equalTo: contentView.leadingAnchor,
                    constant: horizontalConstraint
                ),
                
                labelDescr.trailingAnchor.constraint(
                    equalTo: contentView.trailingAnchor,
                    constant: -horizontalConstraint
                )
            ]
        )
        
        
        labelStatus.applyForCel(fonsSize: 14, fontWeight: .light)
        labelStatus.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelStatus)
        
        NSLayoutConstraint.activate(
            [
                labelStatus.topAnchor.constraint(
                    equalTo: labelDescr.bottomAnchor,
                    constant: buttonConstraint
                ),
                
                labelStatus.leadingAnchor.constraint(
                    equalTo: contentView.leadingAnchor,
                    constant: horizontalConstraint
                ),
            ]
        )
    }
}

