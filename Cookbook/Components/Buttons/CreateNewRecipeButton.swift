////
////  CreateNewRecipeButton.swift
////  Cookbook
////
////  Created by Vitaly Volshin on 12/19/24.
////

import SwiftUI

struct CreateNewRecipeButton: View {
    @Binding var isCreateNewRecipePressed: Bool
    
    var body: some View {
        Button(action: {
            isCreateNewRecipePressed.toggle()
        }, label: {
            Image("Plus")
        })
        .foregroundColor(Color.ownBlack)
    }
}

