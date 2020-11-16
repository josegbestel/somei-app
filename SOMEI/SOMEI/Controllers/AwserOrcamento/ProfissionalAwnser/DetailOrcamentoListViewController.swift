//
//  DetailOrcamentoListViewController.swift
//  SOMEI
//
//  Created by Sergio Cordeiro on 30/10/20.
//  Copyright © 2020 José Guilherme Bestel. All rights reserved.
//

import UIKit
import Cosmos

class DetailOrcamentoListViewController: UIViewController {

    @IBOutlet weak var professionTitle: UILabel!
    @IBOutlet weak var descriptionTitle: UILabel!
    
    //Solicitação view
    @IBOutlet weak var solicitationView: UIView!
    @IBOutlet weak var professionalTitleSolicitationView: UILabel!
    @IBOutlet weak var descriptionTitleSolicitationView: UILabel!
    @IBOutlet weak var imageOrcamentoCollection: UICollectionView!
    @IBOutlet weak var esderecoLabel: UILabel!
    
    //Dados do servico
    @IBOutlet weak var serviceDatasView: UIView!
    @IBOutlet weak var clientNameLabel: UILabel!
    @IBOutlet weak var starView: CosmosView!
    @IBOutlet weak var priceLabel: UILabel!
    
    //Status View
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var imageViewStatus: UIImageView!
    @IBOutlet weak var statusLabelStatusView: UILabel!
    
    @IBOutlet weak var mainStatusLabel: UILabel!
    
    var imagesArray:[UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewLayout()
        configureStatus()
        completeInformations()
        
    }
    
    func completeInformations() {
        
        professionTitle.text = OrcamentoManager.sharedInstance.selectedOrcamentoToRequestService?.profissao
        descriptionTitle.text = OrcamentoManager.sharedInstance.selectedOrcamentoToRequestService?.descricao
        
        //Solicitação view
        professionalTitleSolicitationView.text = OrcamentoManager.sharedInstance.selectedOrcamentoToRequestService?.profissao
        descriptionTitleSolicitationView.text = OrcamentoManager.sharedInstance.selectedOrcamentoToRequestService?.descricao
        esderecoLabel.text = completeOrcamentoEndereco()
        
        //Dados do servico
        //TODO: mudar orcamento para receber o solicitante
        clientNameLabel.text = OrcamentoManager.sharedInstance.selectedOrcamentoToRequestService?.solicitante?.name
        starView.rating = Double(OrcamentoManager.sharedInstance.selectedOrcamentoToRequestService?.solicitante?.nota ?? 5)
        priceLabel.text = "R$ \(OrcamentoManager.sharedInstance.selectedOrcamentoToRequestService?.valorMinimo ?? 0)"
        //Status View
        configureImageView()
    }
    
    @objc func goesToAvaliete(_ sender: UITapGestureRecognizer? = nil) {
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "EvaluateServiceProfessionalViewController")
        self.definesPresentationContext = true
        newVC?.modalPresentationStyle = .overCurrentContext
        self.present(newVC!, animated: true, completion: nil)
    }
    
    func configureImageView() {
        let status = OrcamentoManager.sharedInstance.selectedOrcamentoToRequestService?.status
        switch status {
          case "SOLICITADO":
            statusLabelStatusView.text = "Solicitado"
            statusLabelStatusView.backgroundColor = UIColor(red: 46/255, green: 75/255, blue: 113/255, alpha:1)
            imageViewStatus.image = UIImage(named: "solicitadoStatus")
          case "RESPONDIDO":
            statusLabelStatusView.text = "Respondido"
            statusLabelStatusView.backgroundColor = UIColor(red: 126/255, green: 142/255, blue: 156/255, alpha:1)
            imageViewStatus.image = UIImage(named: "respondidoStatus")
          case "CONFIRMADO":
            statusLabelStatusView.text = "Aguardando resposta do cliente"
            statusLabelStatusView.backgroundColor = UIColor(red: 255/255, green: 187/255, blue: 22/255, alpha:1)
            imageViewStatus.image = UIImage(named: "ConfirmadoStatus")
          case "PENDENTE":
            statusLabelStatusView.text = "Confirmar conclusão"
            statusLabelStatusView.backgroundColor = UIColor(red: 148/255, green: 62/255, blue: 255/255, alpha:1)
            imageViewStatus.image = UIImage(named: "PendenteStatus")
            let statusViewGesture = UITapGestureRecognizer(target: self, action: #selector(self.goesToAvaliete(_:)))
            statusView.addGestureRecognizer(statusViewGesture)
          case "FINALIZADO":
            statusLabelStatusView.text = "Serviço realizado"
            statusLabelStatusView.backgroundColor = UIColor(red: 6/255, green: 221/255, blue: 112/255, alpha:1)
            imageViewStatus.image = UIImage(named: "FinalizadoStatus")
          case "CANCELADO":
            statusLabelStatusView.text = "Cancelado"
            statusLabelStatusView.backgroundColor = UIColor(red: 255/255, green: 92/255, blue: 83/255, alpha:1)
          default:
            print("No status found:\(status ?? "")")
          }
    }
    
    func completeOrcamentoEndereco() -> String {
        var endereco = ""
        endereco.append(OrcamentoManager.sharedInstance.selectedOrcamentoToRequestService?.endereco?.logradouro ?? "")
        endereco.append(",")
        endereco.append("\(OrcamentoManager.sharedInstance.selectedOrcamentoToRequestService?.endereco?.numero ?? 0)")
        endereco.append("-")
        endereco.append(OrcamentoManager.sharedInstance.selectedOrcamentoToRequestService?.endereco?.bairro ?? "")
        endereco.append(",")
        endereco.append(OrcamentoManager.sharedInstance.selectedOrcamentoToRequestService?.endereco?.cidade ?? "")
        return endereco
    }
    
    func configureViewLayout() {
        //Solicitação view
        solicitationView.clipsToBounds = false
        solicitationView.backgroundColor = UIColor.white
        solicitationView.layer.shadowColor = UIColor.black.cgColor
        solicitationView.layer.shadowOpacity = 0.24
        solicitationView.layer.shadowOffset = .zero
        solicitationView.layer.shadowRadius = 5
        solicitationView.layer.cornerRadius = 5
        
        //Dados do servico
        serviceDatasView.clipsToBounds = false
        serviceDatasView.backgroundColor = UIColor.white
        serviceDatasView.layer.shadowColor = UIColor.black.cgColor
        serviceDatasView.layer.shadowOpacity = 0.24
        serviceDatasView.layer.shadowOffset = .zero
        serviceDatasView.layer.shadowRadius = 5
        serviceDatasView.layer.cornerRadius = 5
        
        //Status View
        statusView.clipsToBounds = false
        statusView.backgroundColor = UIColor.white
        statusView.layer.shadowColor = UIColor.black.cgColor
        statusView.layer.shadowOpacity = 0.24
        statusView.layer.shadowOffset = .zero
        statusView.layer.shadowRadius = 5
        statusView.layer.cornerRadius = 5
        
    }
    
    func configureStatus() {
        let status = OrcamentoManager.sharedInstance.selectedOrcamentoToRequestService?.status
        switch status {
          case "SOLICITADO":
            mainStatusLabel.text = "Solicitado"
            mainStatusLabel.backgroundColor = UIColor(red: 46/255, green: 75/255, blue: 113/255, alpha:1)
          case "RESPONDIDO":
            mainStatusLabel.text = "Respondido"
            mainStatusLabel.backgroundColor = UIColor(red: 126/255, green: 142/255, blue: 156/255, alpha:1)
          case "CONFIRMADO":
            mainStatusLabel.text = "Confirmado"
            mainStatusLabel.backgroundColor = UIColor(red: 255/255, green: 187/255, blue: 22/255, alpha:1)
          case "PENDENTE":
            mainStatusLabel.text = "Pendente"
            mainStatusLabel.backgroundColor = UIColor(red: 148/255, green: 62/255, blue: 255/255, alpha:1)
          case "FINALIZADO":
            mainStatusLabel.text = "Finalizado"
            mainStatusLabel.backgroundColor = UIColor(red: 6/255, green: 221/255, blue: 112/255, alpha:1)
          case "CANCELADO":
            mainStatusLabel.text = "Cancelado"
            mainStatusLabel.backgroundColor = UIColor(red: 255/255, green: 92/255, blue: 83/255, alpha:1)
          default:
            print("No status found:\(status ?? "")")
          }
    }
    
    func downloadImages() {
        let linkPhotos:[URL] = OrcamentoManager.sharedInstance.selectedOrcamento?.linkPhotos ?? []
        for imageLink in linkPhotos {
            downloadImage(from: imageLink)
        }
    }
    func updateImages(){
        imageOrcamentoCollection.reloadData()
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        print("Download Started images from Orcamento")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished images from Orcamento")
            DispatchQueue.main.async() { [weak self] in
                self?.imagesArray.insert(UIImage(data: data)!, at: 0)
                self?.updateImages()
            }
        }
    }

    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
extension DetailOrcamentoListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! photosOrcamentoCollectionViewCell
        cell.imageView.image = imagesArray[indexPath.row]
        
        return cell
    }
    
}
