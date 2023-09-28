class CloudStorageException implements Exception {
  const CloudStorageException();
}

class CouldNotCreateSessionException implements CloudStorageException {}

class CouldNotDeleteSessionException implements CloudStorageException {}

class CouldNotCreateClubException implements CloudStorageException {}

class CouldNotStartReviewsException implements CloudStorageException {}

class CouldNotStopReviewsException implements CloudStorageException {}

