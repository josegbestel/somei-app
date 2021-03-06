//
//  ProfessionSearchManager.swift
//  SOMEI
//
//  Created by Sergio Cordeiro on 29/08/20.
//  Copyright © 2020 SOMEI. All rights reserved.
//

import Foundation
import CoreData

class OrcamentoManager {

    static let sharedInstance = OrcamentoManager()
    
    var profissoes: Profissoes!
    var selectedProfission:String?
    
    var createOrcamento = Orcamento(profissao: nil, descricao: nil, photos: [], linkPhotos: [], endereco: nil, data: nil, horario: nil)
    var localizacao = Localizacao(cep: "80215-901", logradouro: nil, numero: 1155, complemento: nil, bairro: nil, cidade: nil, uf: "PR", longitude: nil, latitude: nil)
    var agenda:Agenda = Agenda(horaInicio: nil, horaFinal: nil, diaSemana: nil, dinamica: nil)
    var agendaArray:[Agenda] = []
    var AgendaStructArray:[AgendaStruct]?
    var agendaFixa:AgendaStruct = AgendaStruct(horaInicio:nil,horaFinal:nil,diaSemana:nil,dinamica:nil)
    var profissionaisFromApi:[String] = []
    var photoArray:[URL]? = nil
    
    func completeOrcamento(onComplete: @escaping (Bool) -> Void) {
        insertAgendaInArray()
        guard let structForApi = createStruct() else {onComplete(false); return}
        print(structForApi)
        ProviderSomei.sendOrcamentoToApi(orcamento: structForApi){(error) -> Void in
            if error == false {
                print("problema ao salvar na API:\(error)")
                //TODO: Com a API online a flag do complete deve ser trocada para false
                onComplete(false)
            }else {
                print("Sucesso ao salvar na API")
                onComplete(true)
            }
        }
    }
    
    func insertAgendaInArray() {
        let agendaStructTransf = AgendaStruct.init(horaInicio: agenda.horaInicio, horaFinal: agenda.horaFinal, diaSemana: agenda.diaSemana, dinamica: false)
        AgendaStructArray?.insert(agendaStructTransf, at: 0)
    }
    
    func createStruct() -> OrcamentoStruct? {
        let latitude = Double("\(localizacao.latitude ?? "-49.275830")")
        let longitude = Double("\(localizacao.longitude ?? "-25.433075")")
        let localicaoStruct:LocalizacaoStruct = LocalizacaoStruct.init(cep: localizacao.cep, logradouro: localizacao.logradouro, numero: localizacao.numero, bairro: localizacao.bairro, cidade: localizacao.cidade, uf: localizacao.uf, longitude: longitude, latitude: latitude, complemento: localizacao.complemento)
        
        for datas in agendaArray {
            let datasStruct:AgendaStruct = AgendaStruct.init(horaInicio: datas.horaInicio, horaFinal: datas.horaFinal, diaSemana: datas.diaSemana, dinamica: datas.dinamica)
            AgendaStructArray?.insert(datasStruct, at: 0)
        }
        let idUser = SolicitanteManager.sharedInstance.solicitante.id
        print(photoArray?.count)
        print("Orçamento -> idSuser = \(idUser)")
        let orcamentoStruct:OrcamentoStruct = OrcamentoStruct.init(categoriaMeiTitulo: selectedProfission ?? "profissao", servico: createOrcamento.descricao ?? "não foi possivel obter descricao", solicitanteId: idUser ?? 00, agendas: AgendaStructArray ?? [], localizacao: localicaoStruct, foto: photoArray)
        
        
        return orcamentoStruct
    }
    
    func loadApiAndSaveCoreData() {
        print("loadApiAndSaveCoreData")
        cleanProfessionOnCoreData()
        for profissional in profissionaisFromApi {
            loadAndInsertDatas(profession: profissional)
        }
    }
    
    //Chamar a função para trazer os dados da API para o CoreData
    func loadAndInsertDatas(profession:String) {
        profissoes = Profissoes(context: SomeiManager.sharedInstance.context)
        profissoes.profissao = profession
        do {
            try SomeiManager.sharedInstance.context.save()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func cleanProfessionOnCoreData() {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Profissoes")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do
        {
            try SomeiManager.sharedInstance.context.execute(deleteRequest)
            try SomeiManager.sharedInstance.context.save()
        }
        catch {
            print ("There was an error")
        }
    }
    
}
