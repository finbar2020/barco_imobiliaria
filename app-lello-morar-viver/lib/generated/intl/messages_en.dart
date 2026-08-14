// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(billetByEmailCounter, billetByEmailRemaining) =>
      "Currently, there are ${billetByEmailCounter} users registered to receive copies of bills by email. You can add ${billetByEmailRemaining} more users, totaling the limit of 3.";

  static String m1(count) => "Pending requests (${count})";

  static String m2(howMany) =>
      "${Intl.plural(howMany, one: '1 DAY REMAINING', other: '${howMany} DAYS REMAINING')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "aRequest": MessageLookupByLibrary.simpleMessage("a request"),
    "accessRequestApproveConfirmationMessage": MessageLookupByLibrary.simpleMessage(
      "Upon approval, they will be added to your list of users for this unit, where you can edit the data and permissions.",
    ),
    "addResidentDisclaimer": MessageLookupByLibrary.simpleMessage(
      "By adding a resident, the owner will have the permission to block them whenever they want.",
    ),
    "approve": MessageLookupByLibrary.simpleMessage("Approve"),
    "approvingSuccessfulUpperCase": MessageLookupByLibrary.simpleMessage(
      "Approval successfully completed!",
    ),
    "billetByEmailCounterMessage": m0,
    "blockingSuccessful": MessageLookupByLibrary.simpleMessage(
      "Blocking successfully completed!",
    ),
    "changeAccessRequestStatusToBlockedMessage":
        MessageLookupByLibrary.simpleMessage(
          "When blocked, all residents registered by them will also have their access suspended and will remain so until manually unblocked.",
        ),
    "changeOfOwnership": MessageLookupByLibrary.simpleMessage(
      "CHANGE OF OWNERSHIP",
    ),
    "changeOfOwnershipMessage": MessageLookupByLibrary.simpleMessage(
      "Upon approval, the residents they registered will remain in your list of users for this unit.",
    ),
    "clickTo": MessageLookupByLibrary.simpleMessage("Click to"),
    "conciergeRegistration": MessageLookupByLibrary.simpleMessage(
      "CONCIERGE REGISTRATION",
    ),
    "expirationAccessDate": MessageLookupByLibrary.simpleMessage(
      "Access expiration date",
    ),
    "or": MessageLookupByLibrary.simpleMessage("or"),
    "pendingRequestsCounter": m1,
    "pending_requests": MessageLookupByLibrary.simpleMessage(
      "Pending Requests",
    ),
    "profileWithTwoDots": MessageLookupByLibrary.simpleMessage("Profile:"),
    "registrationLello": MessageLookupByLibrary.simpleMessage(
      "LELLO REGISTRATION",
    ),
    "registrationWithoutContract": MessageLookupByLibrary.simpleMessage(
      "REGISTRATION WITHOUT CONTRACT",
    ),
    "remainingDays": m2,
    "subUserAlreadyRegistered": MessageLookupByLibrary.simpleMessage(
      "Resident already registered. May not be visible as it was added by the owner.",
    ),
    "updateRequestStatusSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "You can now view and edit the data and permissions.",
    ),
    "updateRequestStatusToBlockSuccessMessage":
        MessageLookupByLibrary.simpleMessage(
          "You can unblock or delete them at any time in My Unit, under Residents.",
        ),
  };
}
