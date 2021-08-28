output "jenkins-master-public-ip" {
  value = "${aws_instance.jenkins-master.public_ip}"
}

output "jenkins-worker-public-ips" {
  value = {
    for instance in aws_instance.jenkins-worker-oregon : instance.id => instance.public_ip
  }
}
