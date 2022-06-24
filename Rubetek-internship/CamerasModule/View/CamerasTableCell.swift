//
//  CamerasTableCell.swift
//  Rubetek-internship
//
//  Created by Светлана Кривобородова on 21.06.2022.
//

import Foundation
import UIKit

final class CamerasTableCell: UITableViewCell {

    let cornerRadius: CGFloat = 12
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = cornerRadius
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var cameraImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var recImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Assets.recImg.rawValue)
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Assets.starImg.rawValue)
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Assets.fontRegular.rawValue, size: 17)
        label.textColor = .textLabelForCells
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(image: UIImage?, name: String?, rec: Bool, isFavorite: Bool) {
        cameraImageView.image = image
        nameLabel.text = name
        recImageView.isHidden = rec
        starImageView.isHidden = isFavorite
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cameraImageView.roundCorners(corners: [.topLeft, .topRight], radius: cornerRadius)
    }
}

extension CamerasTableCell {
    private func setupView() {
        contentView.addSubview(containerView)
        containerView.addSubviews([
            cameraImageView,
            nameLabel,
        ])
        cameraImageView.addSubviews([
            recImageView,
            starImageView,
        ])
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            cameraImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            cameraImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            cameraImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            cameraImageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -10),
            
            nameLabel.topAnchor.constraint(equalTo: cameraImageView.bottomAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            nameLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            
            recImageView.topAnchor.constraint(equalTo: cameraImageView.topAnchor, constant: 10),
            recImageView.leadingAnchor.constraint(equalTo: cameraImageView.leadingAnchor, constant: 10),
            
            starImageView.topAnchor.constraint(equalTo: cameraImageView.topAnchor, constant: 10),
            starImageView.trailingAnchor.constraint(equalTo: cameraImageView.trailingAnchor, constant: -10),
        ])
    }
}
