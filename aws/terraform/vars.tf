variable "bucket_name" {
  description = "Nombre del bucket donde se subirá el archivo"
  type        = string
}

variable "redis_username" {
  description = "redis username"
  type        = string
}

variable "redis_password" {
  description = "redis password"
  type        = string
}

variable "redis_DB" {
  description = "redis DB"
  type        = number
}
