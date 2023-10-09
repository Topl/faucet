import 'package:flutter/material.dart';
import 'package:faucet/requests/models/request.dart';
import 'package:faucet/requests/providers/rate_limit_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:faucet/requests/utils/get_mock_requests.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';
import 'package:responsive_framework/responsive_row_column.dart';

import '../../shared/theme.dart';

//Future provider used for pagination of requests
final requestStateAtIndexProvider = FutureProvider.family<Request, int>((ref, index) async {
  return ref.watch(requestProvider.notifier).getRequestFromStateAtIndex(index);
});

final requestProvider = StateNotifierProvider<RequestNotifier, AsyncValue<List<Request>>>((ref) {
  return RequestNotifier(
    ref,
  );
});

class RequestNotifier extends StateNotifier<AsyncValue<List<Request>>> {
  final Ref ref;
  RequestNotifier(
    this.ref,
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
      final remainingRateLimitTime = ref.read(remainingRateLimitTimeProvider);
      if (remainingRateLimitTime != null) {
        throw Exception(
          'Max token limit (100 LVL) reached. Please try again in half an hour.',
        );
      }

      final requests = state.asData?.value;
      if (requests == null) {
        throw Exception('Error in requestProvider: requests are null');
      }

      //make request using provided parameters
      //return Request with transactionId
      var submittedRequest = requestToMake.copyWith(transactionId: '28EhwUBiHJ3evyGidV1WH8QMfrLF6N8UDze9Yw7jqi6w');
      requests.add(submittedRequest);
      state = AsyncData([...requests]);

      ref.read(rateLimitProvider.notifier).setRateLimit();

      return submittedRequest;
    } catch (e) {
      _errorDialogBuilder(context, e.toString());
      throw Exception(e);
    }
  }
}

Future<void> _errorDialogBuilder(BuildContext context, String message) {
  final isMobile = ResponsiveBreakpoints.of(context).equals(MOBILE);
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
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
    },
  );
}
