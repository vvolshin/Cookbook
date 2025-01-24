//
//  RecipeImageView.swift
//  Cookbook
//
//  Created by Vitaly Volshin on 12/19/24.
//

import SwiftUI

struct RecipeImage: View {
    let imageData: String?
    let width: CGFloat
    let height: CGFloat
    let cornerRadius: CGFloat
    
    var body: some View {
        if let imageData = imageData,
           let url = URL(string: imageData) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: width, height: height)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: width, height: height)
                        .cornerRadius(cornerRadius)
                        .clipped()
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: width, height: height)
                        .cornerRadius(cornerRadius)
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
        } else {
            Image(systemName: "photo")
                .resizable()
                .scaledToFit()
                .frame(width: width, height: height)
                .cornerRadius(cornerRadius)
                .foregroundColor(.gray)
        }
    }
}
