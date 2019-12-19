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
    
//    let nib: Nib
//    private var remainingConstraints: [Nib.ObjectID] = []
//    init(nib: Nib) {
//        self.nib = nib
//        remainingConstraints = nib.filteredHierarchy(by: .layoutConstraint)
//    }
//    
//    lazy var signature: Function = {
//        Function.createPrivate(named: "setupSubviews").complete()
//    }()
//    
//    func build() -> FunctionBody {
//        var function: FunctionBodyComposable = FunctionBodyWriter(for: signature)
//        for child in nib.hierarchy.children {
//            guard let object = nib.objects[child.objectID], object.classType == .view else {
//                continue
//            }
//            let property = generateViewName(child)
//            let subviewCall = FunctionCallBuilder(named: "addSubview").parameter(label: .none, name: property).complete()
//            function = function.add(subviewCall)
//        }
//        function = function.add(Property(rawValue: "var constraints: [NSLayoutConstraint] = []"))
//        for child in nib.hierarchy.children {
//            guard let object = nib.objects[child.objectID], object.classType == .view else {
//                continue
//            }
//            let layoutName = generateLayoutSubviewMethod(child)
//            let layoutCall = FunctionCall(rawValue: "constraints.append(contentsOf: \(layoutName))")
//            function = function.add(layoutCall)
//        }
//        let activation = FunctionCallBuilder(named: "NSLayoutConstraint.activate")
//            .parameter(label: .none, name: "constraints")
//            .complete()
//        function = function.add(activation)
//        return function.complete()
//    }
//    
//    func generateSubclasses() -> [FunctionCall] {
//        var subclasses: [FunctionCall] = []
//        for hierarchy in nib.hierarchy.children {
//            let subclassed = generateSubclasses(for: hierarchy)
//            subclasses.append(contentsOf: subclassed)
//        }
//        return subclasses
//    }
//
//    func generateSubclasses(for hierarchy: NibHierarchy) -> [FunctionCall] {
//        let parent = hierarchy.label
//        var subclasses: [FunctionCall] = []
//        for child in hierarchy.children {
//            guard let object = nib.objects[child.objectID], object.classType == .view else {
//                continue
//            }
//            let property = generateViewName(child)
//            let subviewCall = FunctionCallBuilder(named: "addSubview").parameter(label: .none, name: property).complete()
//            subclasses.append(subviewCall)
//            if child.children.isEmpty { continue }
//            subclasses.append(contentsOf: generateSubclasses(for: child))
//        }
//        return subclasses
//    }
//    
//    private func generateLayoutSubviewMethod(_ hierarchy: NibHierarchy) -> String {
//        // Validate valid characters
//        let name: String
//        if hierarchy.name.isEmpty {
//            name = hierarchy.label
//        } else {
//            name = hierarchy.name
//        }
//        return "layout\(name.upperCamelCased)()"
//    }
//    
//    func generateViewName(_ hierarchy: NibHierarchy) -> String {
//        // Validate valid characters
//        if hierarchy.name.isEmpty {
//            return hierarchy.label.lowerCamelCased
//        }
//        return hierarchy.name.lowerCamelCased
//    }
    
}
