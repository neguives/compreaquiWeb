import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/datas/cart_product.dart';
import 'package:compreaidelivery/models/user_model.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  //Cupom de desconto
  String cupomDesconto;
  String disponibilidadeEstabelecimento;
  String tipoFrete;
  String nomeEmpresa;
  bool entregaGratis;
  int discountPercentage = 0;
  double precoFrete = 0;
  double precoFreteKarona = 0;

  String produtoPesquisar;
  UserModel user;
  List<CartProduct> products = [];

  bool isLoading = false;
  CartModel(this.user) {
    if (user.isLoggedIn()) loadCartItens(nomeEmpresa);
  }

  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);
  void addCartItem(CartProduct cartProduct, String nomeEmpresa) {
    products.add(cartProduct);

    Firestore.instance
        .collection("ConsumidorFinal")
        .document(user.firebaseUser.uid)
        .collection("Em Aberto")
        .document("Carrinho")
        .collection(nomeEmpresa)
        .add(cartProduct.toMap())
        .then((doc) {
      cartProduct.cid = doc.documentID;
    });

    notifyListeners();
  }

  void removeCartItem(CartProduct cartProduct, String nomeEmpresa) {
    Firestore.instance
        .collection("ConsumidorFinal")
        .document(user.firebaseUser.uid)
        .collection("Em Aberto")
        .document("Carrinho")
        .collection(nomeEmpresa)
        .document(cartProduct.cid)
        .delete();

    products.remove(cartProduct);

    notifyListeners();
  }

  void decProduct(CartProduct cartProduct, String nomeEmpresa) {
    cartProduct.quantidade--;

    Firestore.instance
        .collection("ConsumidorFinal")
        .document(user.firebaseUser.uid)
        .collection("Em Aberto")
        .document("Carrinho")
        .collection(nomeEmpresa)
        .document(cartProduct.cid)
        .updateData(cartProduct.toMap());

    notifyListeners();
  }

  // ignore: missing_return
  bool setEntregaGratuita(bool entrega) {
    this.entregaGratis = entrega;
  }

  bool getEntregaGratuita() {
    return entregaGratis;
  }

  void incProduct(CartProduct cartProduct, String nomeEmpresa) {
    cartProduct.quantidade++;

    Firestore.instance
        .collection("ConsumidorFinal")
        .document(user.firebaseUser.uid)
        .collection("Em Aberto")
        .document("Carrinho")
        .collection(nomeEmpresa)
        .document(cartProduct.cid)
        .updateData(cartProduct.toMap());

    notifyListeners();
  }

  void loadCartItens(String nomeEmpresa) async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection("ConsumidorFinal")
        .document(user.firebaseUser.uid)
        .collection("Em Aberto")
        .document("Carrinho")
        .collection(nomeEmpresa)
        .getDocuments();

    products = querySnapshot.documents
        .map((doc) => CartProduct.fromDocument(doc))
        .toList();
    notifyListeners();
  }

  void setCupon(String cupomCodigo, int descontoPorcentagem) {
    this.cupomDesconto = cupomCodigo;
    this.discountPercentage = descontoPorcentagem;
  }

  void setDisponibilidade(String disponibilidade) {
    this.disponibilidadeEstabelecimento = disponibilidade;
  }

  void setFrete(String cupomCodigo, double precoFrete) {
    this.tipoFrete = cupomCodigo;
    this.precoFrete = precoFrete;
  }

  void setFreteKarona(double precoFrete) {
    this.precoFreteKarona = precoFrete;
  }

  void setProdutoPesquisado(String produtoPesquisado) {
    this.produtoPesquisar = produtoPesquisado;
  }

  double getProductPrice() {
    double price = 0.0;
    for (CartProduct c in products) {
      if (c.productData != null) price += c.quantidade * c.productData.price;
    }
    return price;
  }

  double getDesconto() {
    notifyListeners();

    return getProductPrice() - getProductPrice() + discountPercentage;
  }

  String getDisponibilidade() {
    return disponibilidadeEstabelecimento;
  }

  double getFrete() {
    return precoFrete;
  }

  double getFreteKarona() {
    return precoFreteKarona;
  }

  String getProduto() {
    return produtoPesquisar;
  }

  void updatePrice() {
    notifyListeners();
  }

  Future<String> finalizarCompra(String nomeEmpresa, String endereco,
      String cidade, String freteTipo, String formaPagamento) async {
//    print(endereco + " Deus no comando");
    if (products.length == 0) return null;

    isLoading = true;
    notifyListeners();

    double productsPrice = getProductPrice();
    double productsFrete = entregaGratis == false ? getFreteKarona() : 0.0;
    double productsDesconto = getDesconto();

    DocumentReference referenciaOrdem = await Firestore.instance
        .collection(cidade)
        .document(nomeEmpresa)
        .collection("ordensSolicitadas")
        .add({
      "clienteId": user.firebaseUser.uid,
      "produtos": products.map((catProduct) => catProduct.toMap()).toList(),
      "enderecoCliente": endereco,
      "precoDoFrete": productsFrete,
      "tipoFrete": freteTipo,
      "precoDosProdutos": productsPrice,
      "formaPagamento": formaPagamento,
      "solicitadoEntregador": false,
      "desconto": productsDesconto,
      "data": formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy]) +
          " às ${formatDate(DateTime.now(), [HH, ':', nn, ':', ss])}",
      "precoTotal": productsPrice - productsDesconto + productsFrete,
      "status": 3
    });

    await Firestore.instance
        .collection("ConsumidorFinal")
        .document(user.firebaseUser.uid)
        .collection("ordemPedidos")
        .document("realizados")
        .collection(nomeEmpresa)
        .document(referenciaOrdem.documentID)
        .setData({"ordemId": referenciaOrdem.documentID});

    QuerySnapshot querySnapshot = await Firestore.instance
        .collection("ConsumidorFinal")
        .document(user.firebaseUser.uid)
        .collection("Em Aberto")
        .document("Carrinho")
        .collection(nomeEmpresa)
        .getDocuments();
    for (DocumentSnapshot doc in querySnapshot.documents) {
      doc.reference.delete();
    }

    products.clear();

    cupomDesconto = null;
    discountPercentage = 0;

    isLoading = false;
    notifyListeners();

    return referenciaOrdem.documentID;
  }

  // ignore: missing_return
  Future<String> limparCarrinho(String nomeEmpresa, String endereco) async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection("ConsumidorFinal")
        .document(user.firebaseUser.uid)
        .collection("Em Aberto")
        .document("Carrinho")
        .collection(nomeEmpresa)
        .getDocuments();
    for (DocumentSnapshot doc in querySnapshot.documents) {
      doc.reference.delete();
    }
    products.clear();

    cupomDesconto = null;
    discountPercentage = 0;

    isLoading = false;
    notifyListeners();
  }
}
