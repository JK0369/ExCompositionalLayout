//
//  ViewController.swift
//  ExCompositionalLayout4
//
//  Created by Jake.K on 2022/04/22.
//

import UIKit

class ViewController: UIViewController {
  private lazy var collectionView: UICollectionView = {
    let view = UICollectionView(frame: .zero, collectionViewLayout: self.getLayout())
    view.isScrollEnabled = true
    view.showsHorizontalScrollIndicator = false
    view.showsVerticalScrollIndicator = true
    view.contentInset = .zero
    view.backgroundColor = .clear
    view.clipsToBounds = true
    view.register(MyCell.self, forCellWithReuseIdentifier: MyCell.id)
    view.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(view)
    return view
  }()
  
  private var dataSource: [MySection] = [
    .main(
      [
        .init(text: "(main 섹션) 아이템 1"),
        .init(text: "(main 섹션) 아이템 2"),
        .init(text: "(main 섹션) 아이템 3"),
        .init(text: "(main 섹션) 아이템 4"),
        .init(text: "(main 섹션) 아이템 5"),
        .init(text: "(main 섹션) 아이템 6"),
      ]
    ),
    .sub(
      [
        .init(text: "(sub 섹션) 아이템 1"),
        .init(text: "(sub 섹션) 아이템 2"),
        .init(text: "(sub 섹션) 아이템 3"),
        .init(text: "(sub 섹션) 아이템 4"),
        .init(text: "(sub 섹션) 아이템 5"),
        .init(text: "(sub 섹션) 아이템 6"),
        .init(text: "(sub 섹션) 아이템 7"),
        .init(text: "(sub 섹션) 아이템 8"),
        .init(text: "(sub 섹션) 아이템 9"),
        .init(text: "(sub 섹션) 아이템 10"),
        .init(text: "(sub 섹션) 아이템 11"),
      ]
    ),
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()

    NSLayoutConstraint.activate([
      self.collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
      self.collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
      self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -16),
      self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
    ])
    self.collectionView.dataSource = self
  }
  
  private func getLayout() -> UICollectionViewLayout {
    return UICollectionViewCompositionalLayout { sectionIndex, env -> NSCollectionLayoutSection? in
      switch self.dataSource[sectionIndex] {
      case .main:
        return self.getListSection()
      case .sub:
        return self.getGridSection()
      }
    }
  }
  
  private func getListSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .fractionalHeight(1.0)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .absolute(120)
    )
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitems: [item]
    )
    return NSCollectionLayoutSection(group: group)
  }
  
  private func getGridSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(0.3),
      heightDimension: .fractionalHeight(1.0)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .fractionalHeight(0.3)
    )
    // collectionView의 width에 3개의 아이템이 위치하도록 하는 것
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitem: item,
      count: 3
    )
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .paging
    section.visibleItemsInvalidationHandler = { [weak self] (visibleItems, offset, env) in
      guard let ss = self else { return }
      let normalizedOffsetX = offset.x + 10
      let centerPoint = CGPoint(x: normalizedOffsetX + ss.collectionView.bounds.width / 2, y: 20)
      visibleItems.forEach({ item in
        guard let cell = ss.collectionView.cellForItem(at: item.indexPath) else { return }
        UIView.animate(withDuration: 0.3) {
          cell.transform = item.frame.contains(centerPoint) ? .identity : CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
      })
    }
    return section
  }
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    self.collectionView.performBatchUpdates(nil, completion: nil)
  }
}

extension ViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    self.dataSource.count
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch self.dataSource[section] {
    case let .main(items):
      return items.count
    case let .sub(items):
      return items.count
    }
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCell.id, for: indexPath) as! MyCell
    switch self.dataSource[indexPath.section] {
    case let .main(items):
      cell.prepare(text: items[indexPath.item].text)
    case let .sub(items):
      cell.prepare(text: items[indexPath.item].text)
    }
    return cell
  }
}
