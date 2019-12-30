//
//  SetupSubviewsMethod.swift
//  
//
//  Created by Luke Davis on 12/14/19.
//

import Foundation
import CodeWriter

class SetupSubviewsMethod {
    
    let rootView: IBUIView
    init(rootView: IBUIView) {
        self.rootView = rootView
    }
    
    lazy var signature: Function = {
        Function.createPrivate(named: "setupSubviews").complete()
    }()
    
    func build() -> FunctionBody {
        var composer: FunctionBodyComposable = FunctionBodyWriter(for: signature)
        for call in composeAddSubviews() {
            composer = composer.add(call)
        }
        composer = composer.add(Property(rawValue: "var constraints: [NSLayoutConstraint] = []"))
        for call in composeLayoutConstraints() {
            composer = composer.add(call)
        }
        
        let activation = FunctionCallBuilder(named: "NSLayoutConstraint.activate")
            .parameter(label: .none, name: "constraints")
            .complete()
        composer = composer.add(activation)
        return composer.complete()
    }
    
    private func composeAddSubviews() -> [FunctionCall] {
        composeAddSubviews(for: rootView)
    }
    
    private func composeAddSubviews(for view: IBUIView) -> [FunctionCall] {
        var calls: [FunctionCall] = []
        for child in view.subviews {
            calls.append(child.generateAddSubview())
            if child.subviews.isEmpty { continue }
            calls.append(contentsOf: composeAddSubviews(for: child))
        }
        return calls
    }
    
    private func composeLayoutConstraints() -> [FunctionCall] {
       composeLayoutConstraints(for: rootView)
   }
   
    private func composeLayoutConstraints(for view: IBUIView) -> [FunctionCall] {
        var calls: [FunctionCall] = []
        for child in view.subviews {
            if child.constraints.isEmpty { continue }
            let layoutName = child.makeLayoutSubView()
            let layoutCall = FunctionCall(rawValue: "constraints.append(contentsOf: \(layoutName)())")
            calls.append(layoutCall)
            if child.subviews.isEmpty { continue }
            calls.append(contentsOf: composeLayoutConstraints(for: child))
        }
        return calls
    }
    
}
