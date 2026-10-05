import 'dart:async';
import 'dart:io';

import 'package:restaurant_admin_dashboard/core/network/api_response.dart';
import 'package:restaurant_admin_dashboard/core/network/network_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum SupabaseRequestType {
  select,
  insert,
  update,
  delete,
}

class SupabaseClientService {
  final SupabaseClient client;

  SupabaseClientService() : client = Supabase.instance.client;

  Future<ApiResponse<dynamic>> request({
    required SupabaseRequestType type,
    required String table,

    // Select
    String? orderBy,
    bool ascending = false,

    // Filters
    Map<String, dynamic>? filters,

    // Insert / Update
    Map<String, dynamic>? data,

    // Update / Delete
    String? column,
    dynamic value,
  }) async {
    try {
      dynamic query;

      switch (type) {
        case SupabaseRequestType.select:
          query = client.from(table).select();

          if (filters != null) {
            filters.forEach((key, value) {
              query = query.eq(key, value);
            });
          }

          if (orderBy != null) {
            query = query.order(
              orderBy,
              ascending: ascending,
            );
          }

          final response = await query;

          return ApiResponse(
            data: List<Map<String, dynamic>>.from(response),
          );

        case SupabaseRequestType.insert:
          if (data == null) {
            throw ArgumentError(
              'data is required for insert request.',
            );
          }

          final response = await client
              .from(table)
              .insert(data)
              .select()
              .single();

          return ApiResponse(
            data: Map<String, dynamic>.from(response),
          );

        case SupabaseRequestType.update:
          if (data == null) {
            throw ArgumentError(
              'data is required for update request.',
            );
          }

          if (column == null) {
            throw ArgumentError(
              'column is required for update request.',
            );
          }

          final response = await client
              .from(table)
              .update(data)
              .eq(column, value)
              .select()
              .single();

          return ApiResponse(
            data: Map<String, dynamic>.from(response),
          );

        case SupabaseRequestType.delete:
          if (column == null) {
            throw ArgumentError(
              'column is required for delete request.',
            );
          }

          await client
              .from(table)
              .delete()
              .eq(column, value);

          return ApiResponse(data: true);
      }
    } on PostgrestException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        NetworkException(
          message: error.message,
        ),
        stackTrace,
      );
    } on AuthException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        NetworkException(
          message: error.message,
        ),
        stackTrace,
      );
    } on StorageException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        NetworkException(
          message: error.message,
        ),
        stackTrace,
      );
    } on FunctionException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        NetworkException(
          message:
          error.details?.toString() ??
              error.reasonPhrase ??
              'The server function request failed.',
        ),
        stackTrace,
      );
    } on SocketException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        NetworkException(
          message:
          'Unable to connect. Check your internet connection.',
        ),
        stackTrace,
      );
    } on TimeoutException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        NetworkException(
          message:
          'The request timed out. Please try again.',
        ),
        stackTrace,
      );
    } on FormatException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        NetworkException(
          message:
          'The server returned a response in an unexpected format.',
        ),
        stackTrace,
      );
    }
  }
}