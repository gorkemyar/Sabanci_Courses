class NetworkError {
  String? message;
  bool? isSuccess;

  NetworkError({this.message, this.isSuccess});

  NetworkError.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    isSuccess = json['isSuccess'];
  }
  

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['isSuccess'] = isSuccess;
    return data;
  }
}