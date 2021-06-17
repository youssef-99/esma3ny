// Roles
const CLIENT = 'client';
const THERAPIST = 'therapist';

// last charge type
const String SUCCESS = 'success';
const String PENDING = 'pending';
const String REFUND = 'refund';
const String FAILED = 'failed';

// time slot status
const String AVAILABLE = 'available';
const String NOT_STARTED = 'not_started';
const String STARTED = 'started';
const String FINIDHED = 'finished';
const String CANCELLED = 'cancelled';

// session types
const String CHAT = 'chat';
const String VIDEO = 'video';
const String AUDIO = 'audio';

// account type
const String LOCAL = 'local';
const String FOREIGN = 'foreign';

// Exceprions
const String NETWORK_ERROR = 'networkError';
enum Exceptions {
  NetworkError,
  InvalidData,
  Timeout,
  ServerError,
  SomethingWentWrong,
}
