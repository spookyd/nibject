//
//  SetupSubviewsMethod.swift
//  
//
//  Created by Luke Davis on 12/14/19.
//

import Foundation
import CodeWriter

class SetupSubviewsMethod {
    
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
