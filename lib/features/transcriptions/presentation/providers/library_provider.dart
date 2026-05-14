// lib/features/transcriptions/presentation/providers/library_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyecto/core/di/injection.dart';
import 'package:proyecto/features/transcriptions/domain/repositories/processing_repository.dart';

sealed class LibraryState {}

class LibraryLoading extends LibraryState {}

class LibraryLoaded extends LibraryState {
  final List<Map<String, dynamic>> items;
  final String query;

  LibraryLoaded({required this.items, this.query = ''});

  List<Map<String, dynamic>> get filtered {
    if (query.isEmpty) return items;
    final q = query.toLowerCase();
    return items.where((item) {
      final title = (item['title'] as String).toLowerCase();
      final transcript = (item['transcript'] as String).toLowerCase();
      return title.contains(q) || transcript.contains(q);
    }).toList();
  }
}

class LibraryError extends LibraryState {
  final String message;
  LibraryError(this.message);
}

class LibraryNotifier extends Notifier<LibraryState> {
  ProcessingRepository get _repository => getIt<ProcessingRepository>();

  @override
  LibraryState build() => LibraryLoading();

  Future<void> load() async {
    state = LibraryLoading();
    try {
      final items = await _repository.getAllTranscriptions();
      state = LibraryLoaded(items: items);
    } catch (e) {
      state = LibraryError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  void search(String query) {
    final current = state;
    if (current is LibraryLoaded) {
      state = LibraryLoaded(items: current.items, query: query);
    }
  }
}

final libraryProvider = NotifierProvider<LibraryNotifier, LibraryState>(
  LibraryNotifier.new,
);
