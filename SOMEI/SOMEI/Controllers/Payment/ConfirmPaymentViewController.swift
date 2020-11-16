//
//  ConfirmPaymentViewController.swift
//  SOMEI
//
//  Created by Sergio Cordeiro on 08/11/20.
//  Copyright © 2020 José Guilherme Bestel. All rights reserved.
//

import UIKit

class ConfirmPaymentViewController: UIViewController {
    
    @IBOutlet weak var imageViewPerfil: UIImageView!
    @IBOutlet weak var fantasyNameLabel: UILabel!
    @IBOutlet weak var cnpjLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var enterpriseLabel: UILabel!
    @IBOutlet weak var categoriaLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayoutImageView()
        completeInformations()
    }
    
    func completeInformations(){
        completePhoto()
        fantasyNameLabel.text = OrcamentoManager.sharedInstance.profissionalEscolhidoRespostaOrcamento.name
        cnpjLabel.text = OrcamentoManager.sharedInstance.profissionalEscolhidoRespostaOrcamento.cnpj
        priceLabel.text = "R$\(OrcamentoManager.sharedInstance.selectedOrcamento?.valorMinimo ?? 0)"
        enterpriseLabel.text = OrcamentoManager.sharedInstance.profissionalEscolhidoRespostaOrcamento.name
        categoriaLabel.text = OrcamentoManager.sharedInstance.profissionalEscolhidoRespostaOrcamento.mainActivity
        descriptionLabel.text = OrcamentoManager.sharedInstance.selectedOrcamento?.descricao
    }
    
    func completePhoto() {
        if OrcamentoManager.sharedInstance.profissionalEscolhidoRespostaOrcamento.photo != nil {
            imageViewPerfil.image = OrcamentoManager.sharedInstance.profissionalEscolhidoRespostaOrcamento.photo
        }else{
            if OrcamentoManager.sharedInstance.profissionalEscolhidoRespostaOrcamento.photoLink != nil {
                downloadImage(from: cleanString(url:OrcamentoManager.sharedInstance.profissionalEscolhidoRespostaOrcamento.photoLink!))
            }
        }
    }
    
    func updateImage(){
        imageViewPerfil.image = OrcamentoManager.sharedInstance.profissionalEscolhidoRespostaOrcamento.photo
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        SomeiManager.sharedInstance.clearCache()
        print("Download Started")
        getData(from: url) { data, response, error in
            if error != nil {
                print("Erro ao baixar imagem:\(error?.localizedDescription ?? "")")
            }
            guard let data = data, error == nil else {print("download error"); return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { [weak self] in
                OrcamentoManager.sharedInstance.profissionalEscolhidoRespostaOrcamento.photo = UIImage(data: data)
                self?.updateImage()
            }
        }
    }
    
    //funcao necessario pois a lib retorna "OPTINAL(link)"
    func cleanString(url:URL) -> URL {
        print(url)
        let convertoToString = "\(url)"
        let dropLastWord = String(convertoToString.dropLast())
        let dropFirstWord:String = String(dropLastWord.dropFirst(9))
        let urlStr : String = dropFirstWord.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        if let cleanUrl = URL(string: urlStr){
            return cleanUrl
        }
        return url
    }
    
    
    func configureLayoutImageView() {
        imageViewPerfil.layer.borderWidth = 1
        imageViewPerfil.layer.masksToBounds = false
        imageViewPerfil.layer.borderColor = UIColor.black.cgColor
        imageViewPerfil.layer.cornerRadius = imageViewPerfil.frame.height/2
        imageViewPerfil.clipsToBounds = true
    }
    
    func sucessoPopUp() {
        let alert = UIAlertController(title: "Tudo certo!", message: "Serviço pago e enviado ao profissional", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok!", style: .default, handler: { action in
            self.goesToConfirm()
        })
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
    
    func goesToConfirm() {
        DispatchQueue.main.async {
            let newVC = self.storyboard?.instantiateViewController(withIdentifier: "SolicitanteHome")
            self.definesPresentationContext = true
            newVC?.modalPresentationStyle = .overCurrentContext
            self.present(newVC!, animated: true, completion: nil)
        }
    }
    
    func errorPopUp() {
        let alert = UIAlertController(title: "Algo deu errado", message: "Por favor tente novamente mais tarde", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok!", style: .default, handler: { action in
        })
        alert.addAction(ok)
        self.present(alert, animated: true)
    }

    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func confirmButton(_ sender: Any) {
        PaymentManager.sharedInstance.completePayment() { success in
            if success {
                self.sucessoPopUp()
            }else {
                self.errorPopUp()
            }
        }
    }
    
}
