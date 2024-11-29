import Foundation
import PDFKit

protocol Exportable {
    func export(results: [SimulationResult]) -> URL?
}

    class JSONExporter: Exportable {
        func export(results: [SimulationResult]) -> URL? {
            let json = ["results": results.map { $0.result }]
            do {
                let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                let url = FileManager.default.temporaryDirectory.appendingPathComponent("SimulationResults.json")
                try data.write(to: url)
                return url
            } catch {
                print("Error exporting to JSON: \(error)")
                return nil
            }
        }
    }

    class XMLExporter: Exportable {
        func export(results: [SimulationResult]) -> URL? {
            let xmlHeader = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
            let rootElementStart = "<simulationResults>"
            let rootElementEnd = "</simulationResults>"
            
            var xmlString = xmlHeader + "\n" + rootElementStart + "\n"
            
            for result in results {
                let resultElement = """
                   <result>
                       <id>\(result.id)</id>
                       <outcome>\(result.result)</outcome>
                   </result>
                   """
                xmlString += resultElement + "\n"
            }
            
            xmlString += rootElementEnd
            
            let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("SimulationResults.xml")
            
            do {
                try xmlString.write(to: fileURL, atomically: true, encoding: .utf8)
                print("XML exported successfully!")
                return fileURL
            } catch {
                print("Error exporting to XML: \(error)")
                return nil
            }
        }
    }

