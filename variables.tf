variable "prefix" {
  type = string
}

variable "location" {
  type = string
}

variable "password" {
  type      = string
  sensitive = true
  default   = "p@sSm0rD1!"
}