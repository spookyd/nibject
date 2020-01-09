//
//  IBUIStackView.swift
//  
//
//  Created by Luke Davis on 12/2/19.
//

import Foundation

public class IBUIStackView: IBUIView {

    // swiftlint:disable:next todo
    // TODO: Add prop support
    /*
     <key>spacing</key>
     <real>6</real>
     
     <key>axis</key>
     <integer>0</integer>
     
     <key>alignment</key>
     <integer>1</integer>
     
     <key>distribution</key>
     <integer>1</integer>
     */

    override func addSubviewMethodName() -> String {
        return "addArrangedSubview"
    }

}
