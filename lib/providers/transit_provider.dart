import 'dart:async';
import 'package:another_telephony/telephony.dart';
import 'package:flutter/material.dart';
import 'package:nextbus/constants/transit_sms.dart';
import '../models/bus_arrival/bus_arrival.dart';
import '../services/sms_parser.dart';
import 'sms_provider.dart';

void _processIncomingSms(
  SmsMessage? message,
  StreamController<List<BusArrival>?> arrivalsController,
) {
  if (message != null) {
    if (message.address != TransitSmsConsts.phoneNumber) return;
    if (message.body != null) {
      try {
        final arrivals = SmsParser.parseArrivals(message.body!);
        if (arrivals.isNotEmpty) {
          arrivalsController.add(arrivals);
        }
      } catch (e) {
        arrivalsController.addError(e);
      }
    }
  }
}

class TransitProvider extends ChangeNotifier {
  final SmsProvider _smsProvider;
  final _arrivalsController = StreamController<List<BusArrival>?>.broadcast();

  TransitProvider(this._smsProvider) {
    _initSmsListener();
  }

  void _initSmsListener() {
    _smsProvider.listenIncomingSms(
      (SmsMessage message) {
        _processIncomingSms(message, _arrivalsController);
      },
      (SmsMessage message) {
        _processIncomingSms(message, _arrivalsController);
      },
    );
  }

  Future<void> sendSmsToNextBus(String stopId, String routeNumber) async {
    await _smsProvider.sendSms(
      TransitSmsConsts.phoneNumber,
      '$stopId,$routeNumber',
    );
  }

  Stream<List<BusArrival>?> nextBusesStream() {
    return _arrivalsController.stream;
  }

  void refreshArrivalStream() {
    _arrivalsController.add(null);
  }

  @override
  void dispose() {
    _arrivalsController.close();
    super.dispose();
  }
}
