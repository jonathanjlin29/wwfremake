//
//  SquareState.swift
//  Extreme WWF
//
//  Created by Jonathan Lin on 3/18/16.
//  Copyright © 2016 Jon Lin. All rights reserved.
//

import Foundation

/**
 This represents a squares current state.
 Empty means there is no tile on it.
 Final means the tile has been played.
 Placed means the tile has been placed but not played yet.
 */
enum SquareState {
    case Empty
    case Final
    case Placed
}
    