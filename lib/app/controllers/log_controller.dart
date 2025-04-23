import 'package:get/get.dart';

import '../models/graphql_request_log.dart';

class LogController extends GetxController{


  final List<GraphQLRequestLog> _logs=[];
  List<GraphQLRequestLog> get logs=>_logs;


  void addLogs(GraphQLRequestLog log){
    _logs.add(log);
    update();
  }

  void clearAll(){
    _logs.clear();
    update();
  }

}