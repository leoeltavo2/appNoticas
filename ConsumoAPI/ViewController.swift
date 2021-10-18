//
//  ViewController.swift
//  ConsumoAPI
//
//  Created by marco rodriguez on 18/10/21.
//

import UIKit

// MARK: - Estructuras Necesarias
struct Petition: Codable {
    var title: String
    var body: String
    
}

struct Petitions: Codable {
    var results: [Petition]
}

class ViewController: UIViewController {
    
    // MARK: - Arreglo para guardar la informacion del JSON
    var petitions = [Petition]()

    @IBOutlet weak var tablaJson: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - TableView Methods
        tablaJson.delegate = self
        tablaJson.dataSource = self
        
        let urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"

            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    // we're OK to parse!
                    parse(json: data)
                }
            }
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()

        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tablaJson.reloadData()
        }
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tablaJson.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
        celda.textLabel?.text = petitions[indexPath.row].title
        celda.detailTextLabel?.text = petitions[indexPath.row].body
        return celda
    }
    
    
}

