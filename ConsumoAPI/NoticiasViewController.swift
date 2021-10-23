//
//  NoticiasViewController.swift
//  ConsumoAPI
//
//  Created by marco rodriguez on 18/10/21.
//

import UIKit
//SE IMPORTA LOS SERVICIOS DE SAFARI PARA PODER UTILIZAR EL NAVEGADOR
import SafariServices
// MARK: - Estructuras
struct Noticias: Codable {
    var articles: [Noticia]
}

struct Noticia: Codable {
    //SE CREAN LAS VARIABLES A PARTIR DEL NOMBRE QUE ESTA EN EL JSON
    var title: String?
    var description: String?
    var urlToImage: String?
    var url: String?
    
}

class NoticiasViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //SE CREA EL ARREGLO DE NOTICIAS
    var noticias = [Noticia]()
    
    //FUNCIÓN PARA SABER LA CANTIDAD DE INFORMACIÓN DEL ARREGLO DE NOTICIAS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noticias.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //SE HACE UN CASTEO DE NOTICIAS CELL PARA QUE AGARRE NUESTRA CELDA PERSONALIZADA
        let celda = tablaNoticias.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! NoticiasCell
//        celda.textLabel?.text = noticias[indexPath.row].title
//        celda.detailTextLabel?.text = noticias[indexPath.row].description
        
        //OBTENER EL TEXTO Y PONERLO EN LAS VARIABLES DE LA CELDA PERSONALIZADA
        celda.lblTitulo.text = noticias[indexPath.row].title
        celda.lblTexto.text = noticias[indexPath.row].description
        
        //CREAMOS VARIABLE SEGURA PARA OBTENER LA URL DE LA IMAGEN
        if let urlImagen = URL(string: noticias[indexPath.row].urlToImage ?? "https://siempreenmedio.files.wordpress.com/2014/04/no_disponible.jpg"){
            DispatchQueue.global().async { [weak self] in
                //SE CREA LA VARIABLE SEGURA DATA  DE TIPO IMAGEN
                if let data = try? Data(contentsOf: urlImagen){
                    if let image = UIImage(data: data){
                        DispatchQueue.main.async {
                            //OBTENEMOS LA IMAGEN Y SE PONE EN LA CELDA PERSONALIZADA
                            celda.imagenNoticias.image = image
                        }
                    }
                }
            }
        }
        
        return celda
    }
    
    //FUNCIÓN PARA ENTRAR A CADA ITEM DE LA TABLA
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        //HACEMOS UN PROCESO SIMILAR AL DE LA IMAGEN, PERO CON LA URL DE LA NOTICIA
        if let urlNoticias = URL(string: noticias[indexPath.row].url ?? "https://tunavegador.com/wp-content/uploads/2020/12/Solucionar-error-403.jpg"){
            //UTILIZAMOS EL SERVICIO DE SAFARI PARA DESPLEGAR LA PÁGINA WEB DE CADA NOTICIA
            let safariVC = SFSafariViewController(url: urlNoticias)
            present(safariVC, animated: true)
        }
    }
    

    @IBOutlet weak var tablaNoticias: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //CARGAMOS LA TABLA PERSONALIZADA
        tablaNoticias.register(UINib(nibName: "NoticiasCell", bundle: nil), forCellReuseIdentifier: "celda")

        tablaNoticias.delegate = self
        tablaNoticias.dataSource = self
        
        let urlString = "https://newsapi.org/v2/top-headlines?apiKey=f0797ef3b62d4b90a400ed224e0f82b7&country=mx"
        //CREAMOS LA VARIABLE SEGURA URLPARSE PARA OBTENER LAS NOTICIAS DESDE LA API NEWSAPI
        if let urlParse = URL(string: urlString) {
            if let data = try? Data(contentsOf: urlParse) {
                // we're OK to parse!
                print("Listo para llamar a parse!")
             parse(json: data)
            }
        }


    }
    //SE CREA LA FUNCIÓN PARSE PARA SABER SI EJECUTA DE MANERA CORRECTA LA API
    func parse(json: Data) {
        let decoder = JSONDecoder()
        print("Se llamo parse y creo decoder")
        if let jsonPeticion = try? decoder.decode(Noticias.self, from: json) {
            print("Json Petitions: \(jsonPeticion.articles.count)")
            noticias = jsonPeticion.articles
            print("news: \(noticias.count)")
            tablaNoticias.reloadData()
        }
    }

    

    

}
