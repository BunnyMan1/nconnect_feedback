/// Validates project credentials, such as project id and secret, and throws
/// errors if they are invalid.
///
/// Does validation only in debug mode to prevent crashing production applications.
class ProjectCredentialValidator {
  const ProjectCredentialValidator();

  Future<void> validate({
    required String projectId,
  }) async {
    assert(
      () {
        if (projectId == 'YOUR-PROJECT-ID') {
          throw ArgumentError.value(
            projectId,
            'projectId',
            "It seems like you forgot to add the projectId  in your Ndash widget.",
          );
        }

        return true;
      }(),
    );
  }
}
