//
//  ErrorAllertModifier.swift
//  Cookbook
//
//  Created by Vitaly Volshin on 12/19/24.
//

import SwiftUI

struct ErrorAlertModifier: ViewModifier {
    @Binding var showAlert: Bool
    var errorTitle: String?
    var errorMessage: String?
    
    func body(content: Content) -> some View {
        content
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(errorTitle ?? "Error"),
                    message: Text(errorMessage ?? "An unknown error occurred"),
                    dismissButton: .default(Text("OK"), action: {
                        showAlert = false
                    })
                )
            }
    }
}
