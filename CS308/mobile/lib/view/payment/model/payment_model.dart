class PaymentModel {
  String? paymentMethod;
  String? cardName;
  String? cardNumber;
  String? cW;
  String? expiryDate;
  int? id;
  int? userId;

  PaymentModel(
      {this.paymentMethod,
      this.cardName,
      this.cardNumber,
      this.cW,
      this.expiryDate,
      this.id,
      this.userId});

  PaymentModel.fromJson(Map<String, dynamic> json) {
    paymentMethod = json['payment_method'];
    cardName = json['card_name'];
    cardNumber = json['cardnumber'];
    cW = json['CW'];
    expiryDate = json['expiry_date'];
    id = json['id'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['payment_method'] = paymentMethod;
    data['card_name'] = cardName;
    data['cardnumber'] = cardNumber;
    data['CW'] = cW;
    data['expiry_date'] = expiryDate;
    data['id'] = id;
    data['user_id'] = userId;
    return data;
  }
}

class PaymentsResponseModel {
  String? message;
  bool? isSuccess;
  List<PaymentModel>? data;

  PaymentsResponseModel({this.message, this.isSuccess, this.data});

  PaymentsResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    isSuccess = json['isSuccess'];
    if (json['data'] != null) {
      data = <PaymentModel>[];
      json['data'].forEach((v) {
        data!.add(PaymentModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['isSuccess'] = isSuccess;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PaymentResponseModel {
  String? message;
  bool? isSuccess;
  PaymentModel? data;

  PaymentResponseModel({this.message, this.isSuccess, this.data});

  PaymentResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    isSuccess = json['isSuccess'];
    data = json['data'] != null ? PaymentModel.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['isSuccess'] = isSuccess;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
