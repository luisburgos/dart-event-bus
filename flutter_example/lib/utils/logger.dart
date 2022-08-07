import 'dart:developer' as developer;

void logger(String message, {String name = 'EVENT-BUS'}) {
  developer.log(message, name: name);
}
