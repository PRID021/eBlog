//
//  AppViewModel.swift
//  eBlog
//
//  Created by mac on 6/2/25.
//

import Foundation

class AppViewModel : ObservableObject {
    static let shared = AppViewModel()
    
    @Published var showToast = false
    @Published var toastMessage = ""
    
    func showToastMessage(content message:String){
        self.toastMessage = message
        self.showToast = true
    }
}
