//
//  SelectAppsViewModel.swift
//  Stride
//
//  Created by Tyler Tran on 1/31/26.
//

import SwiftUI
import Combine
import FamilyControls
import Foundation


extension SelectAppsView {
    @Observable
    class ViewModel {
        var activitySelection: FamilyActivitySelection = FamilyActivitySelection()
        var timeGoal: Int = 30
        var pickerPresented = false
        
        func setSelection(){
            AppSelectionModel.setSelection(activitySelection)
        }

    }
}
