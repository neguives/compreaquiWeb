class BaseDadosProdutos {
  String cODIGO;
  String vLVARJ;
  List<String> buscarProduto;

  BaseDadosProdutos({this.cODIGO, this.vLVARJ});

  BaseDadosProdutos.fromJson(Map<String, dynamic> json) {
    cODIGO = json['CODIGO'];
    vLVARJ = json['VL_VARJ'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CODIGO'] = this.cODIGO;
    data['VL_VARJ'] = this.vLVARJ;
    return data;
  }

  String toString() {
    return "${this.cODIGO} ${this.vLVARJ} \n";
  }
}
