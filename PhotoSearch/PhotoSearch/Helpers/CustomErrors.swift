import Foundation

enum CustomErrors: String, Error {
    case failedLoadingPhoto = "Не удалось загрузить фотографию"
    case unexpected = "Непонятная ошибка"
}
