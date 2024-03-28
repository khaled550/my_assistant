// ignore_for_file: public_member_api_docs, sort_constructors_first

class RequestModel {
  int? id;
  final String? Product_Line,
      Vender,
      Vehicle_type,
      start_point,
      end_point,
      Date,
      Requester,
      Cost,
      Notes;

  RequestModel(
      {this.id,
      this.Product_Line,
      this.Vender,
      this.Vehicle_type,
      this.start_point,
      this.end_point,
      this.Date,
      this.Requester,
      this.Cost,
      this.Notes = ''});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'Product_Line': Product_Line,
      'Vender': Vender,
      'Vehicle_type': Vehicle_type,
      'start_point': start_point,
      'end_point': end_point,
      'Date': Date,
      'Requester': Requester,
      'Cost': Cost,
      'Notes': Notes,
    };
  }

  static RequestModel fromDB(Map<dynamic, dynamic> data) {
    RequestModel requestModel = RequestModel(
      id: data['id'],
      Product_Line: data['Product_Line'],
      Vender: data['Vender'],
      Vehicle_type: data['Vehicle_type'],
      start_point: data['start_point'],
      end_point: data['end_point'],
      Date: data['Date'],
      Requester: data['Requester'],
      Cost: data['Cost'],
      Notes: data['Notes'],
    );
    return requestModel;
  }
}
