class HttpResponse {
  String res;
  String message;

  HttpResponse({required this.res, required this.message});

  factory HttpResponse.fromJson(Map<String, dynamic> json) => HttpResponse(
        res: json["res"],
        message: json["message"],
      );
}
