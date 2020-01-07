public struct NibJect {
    
    @discardableResult
    public static func ejectNib(at inputPath: String,
                                to outputPath: String) -> Result<GeneratedSwiftFile, NibjectError> {
        do {
            let plist = try InterfaceBuilderPlist.from(inputPath).get()
            let nib = try Nib.from(plist).get()
            let view = try IBUIView.from(nib: nib)
            let constraints = IBLayoutConstraint.from(nib: nib)
            let viewGraph = IBUIViewGraph(view: view).flattenHierarchy()
            ConstraintBuilder(flattendView: viewGraph).assign(constraints: constraints)
            let fileName = getOutputFileName(inputPath)
            let swiftClass = try GeneratedSwiftFile.from(view, named: fileName).get()
            _ = try swiftClass.writeToFile(at: outputPath).get()
            return .success(swiftClass)
        } catch let error as NibjectError {
            return .failure(error)
        } catch let error as IBUIViewError {
            return .failure(error.asNibjectError())
        } catch {
            return .failure(.unknownError(underlyingError: error))
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
