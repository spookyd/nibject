public struct NibJect {
    
    @discardableResult
    public static func ejectNib(at inputPath: String, to outputPath: String) -> Result<GeneratedSwiftFile, Error> {
        do {
            let plist = try InterfaceBuilderPlist.from(inputPath).get()
            let nib = try Nib.from(plist).get()
            let view = try IBUIView.from(nib: nib)
            let constraints = IBLayoutConstraint.from(nib: nib)
            let viewGraph = IBUIViewGraph(view: view).flattenHierarchy()
            ConstraintBuilder(flattendView: viewGraph).assign(constraints: constraints)
            let fileName = getOutputFileName(inputPath)
            let swiftClass = try GeneratedSwiftFile.from(view, named: fileName).get()
            let result = swiftClass.writeToFile(at: outputPath)
            switch result {
            case .success: return .success(swiftClass)
            case .failure(let error): return .failure(error)
            }
        } catch {
            return .failure(error)
        }
    }
    
    private static func getOutputFileName(_ path: String) -> String {
        guard let fileNameWithExtension = path.components(separatedBy: "/").last else {
            return ""
        }
        guard let fileName = fileNameWithExtension.components(separatedBy: ".").first else {
            return ""
        }
        return fileName
    }
}
