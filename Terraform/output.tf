output "server_public_ip" {
  description = "Public IP of the WireGuard server"
  value       = aws_eip.wg_eip.public_ip
}
