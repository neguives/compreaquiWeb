import 'package:cloud_firestore/cloud_firestore.dart';

class EmpresasData {
  String cidade, cnpj, imagem, nomeEmpresa, razaoSocial, descricao, id;
  bool disponivel, premium;

  EmpresasData.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    cidade = snapshot.data["cidade"];
    nomeEmpresa = snapshot.data["nomeEmpresa"];
    cnpj = snapshot.data["cnpj"];
    imagem = snapshot.data["imagem"];
    descricao = snapshot.data["descricao"];
    razaoSocial = snapshot.data["razaoSocial"];
    disponivel = snapshot.data["disponivel"];
    premium = snapshot.data["premium"];
  }

  Map<String, dynamic> toResumedMap() {
    return {
      "nomeEmpresa": nomeEmpresa,
      "cidade": cidade,
      "descricao": descricao,
      "cnpj": cnpj,
      "imagem": imagem,
      "razaoSocial": razaoSocial,
      "disponivel": disponivel,
      "premium": premium,
    };
  }
}
