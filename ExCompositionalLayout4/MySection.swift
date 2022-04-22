//
//  MySection.swift
//  ExCompositionalLayout4
//
//  Created by Jake.K on 2022/04/22.
//

import Foundation

enum MySection {
  struct MainItem {
    let text: String
  }
  struct SubItem {
    let text: String
  }
  
  case main([MainItem])
  case sub([SubItem])
}
