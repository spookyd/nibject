public struct NibJect {
    
    @discardableResult
    public static func ejectNib(at inputPath: String, to outputPath: String) -> Result<GeneratedSwiftFile, Error> {
        do {
            let plist = try InterfaceBuilderPlist.from(inputPath).get()
            let nib = try Nib.from(plist).get()
            let view = try IBUIView.from(nib: nib)
            let fileName = getOutputFileName(inputPath)
            let swiftClass = try GeneratedSwiftFile.from(view, named: fileName).get()
            // Produce file text
            // Write file text
            swiftClass.writeToFile(at: outputPath)
            return .success(swiftClass)
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
