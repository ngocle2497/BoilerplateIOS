enum HttpStatusCode: Int {
    case OK = 200
    case UNKNOWN = -100
    case CANCELED = -999
    case DECODE_ERROR = -101
    case UN_AUTHORIZED = 401
}
