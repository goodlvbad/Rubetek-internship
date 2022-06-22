//
//  DoorsWithCameraTableCell.swift
//  Rubetek-internship
//
//  Created by Светлана Кривобородова on 21.06.2022.
//

import UIKit

final class DoorsWithCameraTableCell: UITableViewCell {
    
    var callbackForLockBtn: (() -> Void)?
    
    let cornerRadius: CGFloat = 12
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = cornerRadius
        view.backgroundColor = .red
        return view
    }()
    
    private lazy var cameraImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var lockBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(didTapLockBtn(_:)), for: .touchUpInside)
        btn.setBackgroundImage(UIImage(named: Assets.lockBtn.rawValue), for: .normal)
        return btn
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
    
    func setupCell(image: UIImage?, name: String?) {
        cameraImageView.image = image
        nameLabel.text = name
    }
}

extension DoorsWithCameraTableCell {
    private func setupView() {
        contentView.addSubview(containerView)
        containerView.addSubviews([
            cameraImageView,
            nameLabel,
            lockBtn,
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
            nameLabel.trailingAnchor.constraint(equalTo: containerView.centerXAnchor, constant: -5),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            nameLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            
            lockBtn.topAnchor.constraint(equalTo: cameraImageView.bottomAnchor, constant: 10),
            lockBtn.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            lockBtn.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
        ])
    }
    
    @objc
    private func didTapLockBtn(_ sender: UIButton) {
        callbackForLockBtn?()
    }
}
