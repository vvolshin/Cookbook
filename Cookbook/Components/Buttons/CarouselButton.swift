//
//  CarouselButton.swift
//  Cookbook
//
//  Created by Vitaly Volshin on 1/17/25.
//

import SwiftUI

extension CategoriesCarousel {
    struct CarouselButton: View {
        var name: String
        var count: Int
        @Binding var selectedCategory: String
        
        var body: some View {
            Button(action: {
                selectedCategory = name
            }) {
                ZStack(alignment: .topTrailing) {
                    Text(name)
                        .font(selectedCategory == name ? .system(size: 16, weight: .bold) : .system(size: 16))
                        .padding()
                    
                    Text("\(count)")
                        .font(selectedCategory == name ? .system(size: 12, weight: .bold) : .system(size: 12))
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}
