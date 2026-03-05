import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class FutureWidget<T> extends StatelessWidget {
  final Future<T> future;
  final Widget Function(T data) successBuilder;
  final Widget? loadingWidget;
  final Widget Function(Object error)? errorBuilder;

  const FutureWidget({
    super.key,
    required this.future,
    required this.successBuilder,
    this.loadingWidget,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingWidget ??
              const Center(
                child: CircularProgressIndicator(color: AppTheme.primaryBlue),
              );
        } else if (snapshot.hasError) {
          if (errorBuilder != null) {
            return errorBuilder!(snapshot.error!);
          }
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasData) {
          return successBuilder(snapshot.data as T);
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
