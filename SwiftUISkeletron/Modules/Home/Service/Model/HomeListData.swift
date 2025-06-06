//
//  HomeData.swift
//  SwiftUISkeletron
//
//  Created by Stefan Simic on 29.4.25..
//

import Foundation

struct HomeListData: Identifiable, Hashable, Decodable {
	var id = UUID()
	var title: String
}
