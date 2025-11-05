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
    
    @Published var showEnableFaceIDPrompt: Bool = false
    private var enableFaceIDCallback: ((Bool) -> Void)? = nil
    
    func showEnableFaceIDPrompt(_ show: Bool, onConfirm: @escaping (Bool) -> Void) {
        if (show) {
            enableFaceIDCallback = onConfirm
            showEnableFaceIDPrompt = true
        }
    }
    
    func confirmEnableFaceID(_ confirmed: Bool) {
        enableFaceIDCallback?(confirmed)
        enableFaceIDCallback = nil
        showEnableFaceIDPrompt = false
    }

    
    func showToastMessage(content message:String){
        self.toastMessage = message
        self.showToast = true
    }
}
