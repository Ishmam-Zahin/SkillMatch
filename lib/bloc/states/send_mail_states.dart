class MySendMailStates {}

class SendMailInitialSate extends MySendMailStates {}

class SendMailLoadingState extends MySendMailStates {}

class SendMailLoadedState extends MySendMailStates {}

class SendMailErrorState extends MySendMailStates {
  final String error;
  SendMailErrorState({required this.error});
}

class SendMailValidityInitialState extends MySendMailStates {}

class SendMailValidityLoadingState extends MySendMailStates {}

class SendMailValidityLoadedState extends MySendMailStates {
  final bool isValid;

  SendMailValidityLoadedState({
    required this.isValid,
  });
}

class SendMailValidityErrorState extends MySendMailStates {
  final String error;

  SendMailValidityErrorState({
    required this.error,
  });
}
