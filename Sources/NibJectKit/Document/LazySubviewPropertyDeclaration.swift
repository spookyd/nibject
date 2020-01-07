//
//  LazySubViewPropertyDeclaration.swift
//  
//
//  Created by Luke Davis on 12/30/19.
//

import CodeWriter
import Foundation

struct LazySubviewPropertySectionMaker {
    
    var rootView: IBUIView
    
    func make() -> DeclarationRepresentable {
        JoinedDeclarationExpression(makeLazyProperties(for: rootView))
    }
    
    private func makeLazyProperties(for view: IBUIView) -> [DeclarationRepresentable] {
        var properties: [DeclarationRepresentable] = []
        for child in view.subviews {
            properties.append(LazySubviewPropertyDeclarationMaker(view: child).make())
            properties.append(RawDeclaration.newline)
            if child.subviews.isEmpty { continue }
            properties.append(contentsOf: makeLazyProperties(for: child))
        }
        return properties
    }

}

struct LazySubviewPropertyDeclarationMaker {
    
    var view: IBUIView
    
    func make() -> DeclarationRepresentable {
        let closure = ClosureExpression { builder in
            let closurePropName = "view"
            let constant = ConstantDeclaration { builder in
                builder.setName(closurePropName)
                builder.expression(InitializerExpression { builder in
                    builder.initializingExpression(RawExpression(rawValue: view.uikitRepresentation))
                })
            }
            let translatesExpression = ExplicitMemberExpression(expression: RawExpression(rawValue: closurePropName),
                                                                member: RawExpression(rawValue: "translatesAutoresizingMaskIntoConstraints"))
            let returnValue = ReturnExpression(expression: RawExpression(rawValue: closurePropName))
            builder.bodyStatements([
                constant,
                AssignmentOperatorExpression(expression: translatesExpression,
                                             value: RawExpression(rawValue: "false")),
                returnValue
            ])
        }
        let executed = InitializerExpression { builder in
            builder.initializingExpression(closure)
        }
        return VariableDeclaration { builder in
            builder.accessLevel(.private)
            builder.isLazy(true)
            builder.setName(view.propertyName)
            builder.explicitType(view.uikitRepresentation)
            builder.expression(executed)
        }
    }
    
}

