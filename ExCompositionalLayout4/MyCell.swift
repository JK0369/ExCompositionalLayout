//
//  MyCell.swift
//  ExCompositionalLayout4
//
//  Created by Jake.K on 2022/04/22.
//

import UIKit

final class MyCell: UICollectionViewCell {
  static let id = "MyCell"
  
  // MARK: UI
  private lazy var label: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    self.contentView.addSubview(label)
    return label
  }()
  
  private var randomValue: CGFloat {
    CGFloat(drand48())
  }
  
  // MARK: Initializer
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.backgroundColor = UIColor(red: self.randomValue, green: self.randomValue, blue: self.randomValue, alpha: 1.0)
    NSLayoutConstraint.activate([
      self.label.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16),
      self.label.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16),
      self.label.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16),
      self.label.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
    ])
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    self.prepare(text: "")
  }
  
  func prepare(text: String) {
    self.label.text = text
  }
}
