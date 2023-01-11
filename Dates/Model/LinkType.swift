//
//  LinkType.swift
//  Dates
//
//  Created by Vitali Kazakevich on 10.01.23.
//

import Foundation

enum LinkType: String, CaseIterable {
    case instagram
    case twitter
    case facebook

    var image: String { rawValue }
}
