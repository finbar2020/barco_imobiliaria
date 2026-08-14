import 'package:flutter/material.dart';

enum PaymentStatus {
	pending,
	approved,
	suspended,
	canceled
}

String paymentStatusToString(BuildContext context, PaymentStatus status) {
	switch(status) {

	  case PaymentStatus.pending:
	    return "Pendente";
	  case PaymentStatus.approved:
		  return "Aprovado";
	  case PaymentStatus.suspended:
		  return "Suspenso";
	  case PaymentStatus.canceled:
		  return "Cancelado";
	}
}