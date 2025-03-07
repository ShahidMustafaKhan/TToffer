

class AppException implements Exception {

   // ignore: prefer_typing_uninitialized_variables
   final _message;
   // ignore: prefer_typing_uninitialized_variables
   final _prefix;

   AppException([this._message , this._prefix]);

   @override
   String toString() {
     // Customize the exception's string representation
     return '${_message ?? _prefix}';
   }

}


class FetchDataException extends AppException {

  FetchDataException([String? message]) : super(message ,'Error During Communication');
}




class BadRequestException extends AppException {

  BadRequestException([String? message]) : super(message, 'Invalid request');
}


class UnauthorisedException extends AppException {

  UnauthorisedException([String? message]) : super(message,'Unauthorised request');
}

class InternalServerException extends AppException {

  InternalServerException([String? message]) : super(message,'Internal Server Error');
}

class DataNotFoundException extends AppException {

  DataNotFoundException([String? message]) : super(message,'Data not Found');
}

class UnProcessableEntity extends AppException {

  UnProcessableEntity([String? message]) : super(message,'Validation Error');
}

class InvalidInputException extends AppException {

  InvalidInputException([String? message]) : super(message, 'Invalid Input');
}


class NoInternetException extends AppException {

  NoInternetException([String? message]) : super(message,'No Internet Connection');
}
