import SwiftUI
struct ContentView: View {
    @State private var eventName: String = ""
    @State private var outcomes: String = ""
    @State private var probabilities: String = ""
    @State private var iterations: String = "100"
    
    @StateObject private var simulation = Simulation()
    @State private var showExportSuccess = false
    @State private var exportType: String = ""
    
    @State private var exporter: Exportable?
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Event Settings").font(.headline)) {
                    TextField("Event Name", text: $eventName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Outcomes (comma-separated)", text: $outcomes)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Probabilities (comma-separated, sum = 1)", text: $probabilities)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Number of Iterations", text: $iterations)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: iterations) { oldValue, newValue in
                            iterations = newValue.filter { $0.isNumber }
                        }
                }
                
                Button(action: runSimulation) {
                    Text("Run Simulation")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
            
            Divider()
            
            Text("Simulation Results").font(.headline).padding(.top)
            
            Table(simulation.results) {
                TableColumn("Index") { result in
                    Text("\(result.id + 1)")
                }
                TableColumn("Result") { result in
                    Text(result.result)
                }
            }
            .frame(maxHeight: 300)
            
            HStack {
                Button(action: exportToJSON) {
                    Text("Export to JSON")
                }
                Spacer()
                Button(action: exportToXML) {
                    Text("Export to XML")
                }
            }
            .padding()
            
            Spacer()
        }
        .frame(width: 600, height: 600)
        .alert("\(exportType) Export Successful", isPresented: $showExportSuccess) {
            Button("OK", role: .cancel) { }
        }
    }
    
    func runSimulation() {
        let outcomeList = outcomes.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) }
        let probabilityList = probabilities.split(separator: ",").compactMap { Double($0.trimmingCharacters(in: .whitespaces)) }
        
        guard outcomeList.count == probabilityList.count,
              probabilityList.reduce(0, +) == 1.0,
              let iterationCount = Int(iterations), iterationCount > 0 else {
            print("Invalid input data")
            return
        }
        
        let event = Event(name: eventName, outcomes: outcomeList, probabilities: probabilityList)
        simulation.run(event: event, iterations: iterationCount)
    }
    
    func exportToJSON() {
        exporter = JSONExporter()
        if let fileURL = exporter?.export(results: simulation.results) {
            exportType = "JSON"
            showExportSuccess = true
            print("JSON file saved at: \(fileURL.path)")
        }
    }

    func exportToXML() {
        exporter = XMLExporter()
        if let fileURL = exporter?.export(results: simulation.results) {
            exportType = "XML"
            showExportSuccess = true
            print("XML file saved at: \(fileURL.path)")
        }
    }
}
