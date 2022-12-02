//
//  TabmanViewController+Extension.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/12/02.
//

import Tabman

extension TabmanViewController {
    var setTabMan: TMBarView<TMHorizontalBarLayout, TMLabelBarButton, TMLineBarIndicator> {
        let bar = TMBar.ButtonBar()
        
        bar.layout.transitionStyle = .snap
        bar.layout.alignment = .centerDistributed
        bar.layout.contentMode = .fit
        
        bar.indicator.weight = .light
        bar.indicator.overscrollBehavior = .bounce
        bar.indicator.tintColor = .setColor(.green)
        
        bar.backgroundView.style = .clear
        bar.buttons.customize{ button in
            button.selectedTintColor = .setColor(.green)
            button.font = .systemFont(ofSize: 14)
        }
        
        return bar
    }
}
