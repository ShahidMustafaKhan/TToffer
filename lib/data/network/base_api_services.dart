

abstract class BaseApiServices {

  Future<dynamic> getGetApiResponse(String url);

  Future<dynamic> getPostApiResponse(String url , dynamic data);

  Future<dynamic> getDeleteApiResponse(String url , dynamic data);

  Future<dynamic> postMultiFileApiRequest(String url, Map<String, dynamic> fields, List<String> filePaths);

  Future<dynamic> postSingleFileApiRequest(String url, Map<String, dynamic> fields, String filePath);

}