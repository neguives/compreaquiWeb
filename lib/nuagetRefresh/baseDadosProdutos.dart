class BaseDadosProdutos {
  String cODIGO;
  String vLVARJ;
  String estoque;
  List<String> buscarProduto;

  BaseDadosProdutos({this.cODIGO, this.vLVARJ});

  BaseDadosProdutos.fromJson(Map<String, dynamic> json) {
    cODIGO = json['CODIGO'];
    vLVARJ = json['VL_VARJ'];
    estoque = json['ESTOQUE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CODIGO'] = this.cODIGO;
    data['VL_VARJ'] = this.vLVARJ;
    data['ESTOQUE'] = this.estoque;
    return data;
  }

  String toString() {
    return "${this.cODIGO} ${this.vLVARJ} \n";
  }
}
