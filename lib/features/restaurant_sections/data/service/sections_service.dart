import '../../../../core/network/supabase_client.dart';
import '../model/section_model.dart';

class SectionsService {
  final SupabaseClientService supabaseClientService;

  SectionsService({
    required this.supabaseClientService});

  static const String _table = 'sections';

  Future<List<SectionModel>> getSections() async {
    final response = await supabaseClientService.request(
      type: SupabaseRequestType.select,
      table: _table,
      orderBy: 'id',
      ascending: true,
    );

    return (response.data as List)
        .map(
          (json) => SectionModel.fromJson(
        Map<String, dynamic>.from(json),
      ),
    )
        .toList();
  }

  Future<SectionModel> insertSection({
    required SectionModel sectionModel,
  }) async {

    final response = await supabaseClientService.request(
      type: SupabaseRequestType.insert,
      table: _table,
      data: sectionModel.toJson(),
    );

    return SectionModel.fromJson(response.data);
  }

  Future<SectionModel> updateSection({
    required SectionModel sectionModel,
  }) async {

    final response = await supabaseClientService.request(
      type: SupabaseRequestType.update,
      table: _table,
      data: sectionModel.toJson(),
      column: 'id',
      value: sectionModel.id,
    );

    return SectionModel.fromJson(response.data);
  }

  Future<void> deleteSection({
    required int id,
  }) async {
    await supabaseClientService.request(
      type: SupabaseRequestType.delete,
      table: _table,
      column: 'id',
      value: id,
    );
  }
}