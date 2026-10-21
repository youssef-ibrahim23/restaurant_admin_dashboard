class ApiResponse<T> {
  final T data;
  final String? message;

  const ApiResponse({required this.data, this.message});
}
