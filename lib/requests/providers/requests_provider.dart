import 'package:faucet/shared/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:faucet/requests/models/request.dart';
import 'package:faucet/requests/providers/rate_limit_provider.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:faucet/chain/providers/selected_chain_provider.dart';
import 'package:faucet/chain/models/chains.dart';
import 'package:faucet/requests/utils/get_mock_requests.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';
import 'package:responsive_framework/responsive_row_column.dart';

import '../../shared/theme.dart';

//Future provider used for pagination of requests
final requestStateAtIndexProvider = FutureProvider.family<Request, int>((ref, index) async {
  return ref.watch(requestProvider.notifier).getRequestFromStateAtIndex(index);
});

final requestProvider = StateNotifierProvider<RequestNotifier, AsyncValue<List<Request>>>((ref) {
  final selectedChain = ref.watch(selectedChainProvider);
  return RequestNotifier(
    ref,
    selectedChain,
  );
});

class RequestNotifier extends StateNotifier<AsyncValue<List<Request>>> {
  final Chains selectedChain;
  final Ref ref;
  DateTime? lastRequestTime;

  RequestNotifier(
    this.ref,
    this.selectedChain,
  ) : super(
          const AsyncLoading(),
        ) {
    getRequests(setState: true);
  }

  /// It takes a bool [setState]
  ///
  /// If [setState] is true, it will update the state of the provider
  /// If [setState] is false, it will not update the state of the provider
  Future<List<Request>> getRequests({bool setState = false}) async {
    if (setState) state = const AsyncLoading();

    //get mock requests
    List<Request> requests = getMockRequests(10);

    // Adding delay here to simulate API call
    if (setState) {
      Future.delayed(
        const Duration(seconds: 1),
        () {
          // Do API call here
          state = AsyncData(requests);
        },
      );
    }
    return requests;
  }

  /// This method is used to get a request at a specific index
  /// If the request is not in the state, it will fetch the request
  /// It takes an [index] as a parameter
  ///
  /// It returns a [Future<Request>]
  Future<Request> getRequestFromStateAtIndex(int index) async {
    final requests = state.asData?.value;

    if (requests == null) {
      throw Exception('Error in requestProvider: requests are null');
    }

    // If the index is less than the length of the list, return the request at that index
    if (index <= requests.length) {
      return requests[index];
    } else {
      throw Exception('Error in requestProvider: no more requests');
    }
  }

  /// This method is used to get a request at a specific index
  /// If the request is not in the state, it will fetch the request
  /// It takes an [index] as a parameter
  ///
  /// It returns a [Future<Request>]
  Future<Request> makeRequest(BuildContext context, Request requestToMake) async {
    try {
      // Check if rate limit is reached
      if (lastRequestTime != null) {
        final currentTime = DateTime.now();
        final timeElapsed = currentTime.difference(lastRequestTime!);
        if (timeElapsed < const Duration(minutes: 30)) {
          throw Exception('Rate limit reached. Please try again in 30 minutes.');
        }
      }
      lastRequestTime = DateTime.now(); // Update the last request timestamp

      final requests = state.asData?.value ?? [];
      print(requests);

      //make request using provided parameters
      var submittedRequest = requestToMake.copyWith(transactionId: '28EhwUBiHJ3evyGidV1WH8QMfrLF6N8UDze9Yw7jqi6w');
      requests.add(submittedRequest);
      state = AsyncData([...requests]);

      ref.read(rateLimitProvider.notifier).setRateLimit();
      _successDialogBuilder(context);
      return submittedRequest;
    } catch (e) {
      errorDialogBuilder(context, e.toString());
      throw Exception(e);
    }
  }
}

Future<void> errorDialogBuilder(BuildContext context, String message) {
  final isMobile = ResponsiveBreakpoints.of(context).equals(MOBILE);
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return ErrorDialog(
        isMobile: isMobile,
        message: message,
      );
    },
  );
}

class ErrorDialog extends StatelessWidget {
  static const requestErrorDialogKey = Key('requestErrorDialogKey');

  const ErrorDialog({
    Key key = requestErrorDialogKey,
    required this.isMobile,
    required this.message,
  }) : super(key: key);

  final bool isMobile;
  final String message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: ResponsiveRowColumn(
        layout: isMobile ? ResponsiveRowColumnType.COLUMN : ResponsiveRowColumnType.ROW,
        rowMainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ResponsiveRowColumnItem(
            child: Text(
              'Something went wrong...',
              style: titleLarge(context),
            ),
          ),
          ResponsiveRowColumnItem(
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 400.0,
        child: Text(
          message,
          style: bodyMedium(context),
        ),
      ),
      actionsPadding: const EdgeInsets.all(16),
    );
  }
}

Future<void> _successDialogBuilder(BuildContext context) {
  final isMobile = ResponsiveBreakpoints.of(context).equals(MOBILE);

  final isTablet = ResponsiveBreakpoints.of(context).equals(TABLET);
  String transactionHash = 'a1075db55d416d3ca199f55b6e2115b9345e16c5cf302fc80';

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return SuccessDialog(isMobile: isMobile, isTablet: isTablet, transactionHash: transactionHash);
    },
  );
}

class SuccessDialog extends StatelessWidget {
  static const requestSuccessDialogKey = Key('requestSuccessDialogKey');
  const SuccessDialog({
    Key key = requestSuccessDialogKey,
    required this.isMobile,
    required this.isTablet,
    required this.transactionHash,
  }) : super(key: key);

  final bool isMobile;
  final bool isTablet;
  final String transactionHash;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: ResponsiveRowColumn(
        layout: isMobile ? ResponsiveRowColumnType.COLUMN : ResponsiveRowColumnType.ROW,
        rowMainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ResponsiveRowColumnItem(
            child: Text(
              '${Strings.statusConfirmed}!',
              style: titleLarge(context),
            ),
          ),
          ResponsiveRowColumnItem(
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 550.0,
        height: 300.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Strings.requestSuccessful,
              style: bodyMedium(context),
            ),
            const SizedBox(height: 30),
            Text(
              Strings.txnHash,
              style: titleSmall(context),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
              width: double.infinity,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color.fromRGBO(112, 64, 236, 0.04),
              ),
              child: ResponsiveRowColumn(
                layout: isTablet ? ResponsiveRowColumnType.COLUMN : ResponsiveRowColumnType.ROW,
                children: [
                  ResponsiveRowColumnItem(
                    child: SelectableText(
                      transactionHash,
                      style: bodyMedium(context),
                    ),
                  ),
                  const ResponsiveRowColumnItem(
                    child: SizedBox(width: 8),
                  ),
                  ResponsiveRowColumnItem(
                    child: IconButton(
                      icon: const Icon(
                        Icons.copy,
                        color: Color(0xFF858E8E),
                      ),
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(text: transactionHash),
                        );
                        FToast().showToast(
                          child: const Text(Strings.copyToClipboard),
                          gravity: ToastGravity.BOTTOM,
                          toastDuration: const Duration(seconds: 2),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  //  TODO: Add link to explorer using url_launcher
                },
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color(0xFF0DC8D4),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                child: Text(
                  Strings.viewExplorer,
                  style: titleSmall(context)!.copyWith(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.all(4),
    );
  }
}
