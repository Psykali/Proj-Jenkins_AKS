######################
## Create JenkinsVM ##
######################
resource "azurerm_linux_virtual_machine" "jenkins_vm" {
  name                = "jenkins-vm"
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.jenkins_nic.id]
  size                  = "Standard_B2ms"
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  disable_password_authentication = false

  os_disk {
    name                 = "jenkins-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
####################
## Bash Scripting ##
####################

resource "null_resource" "install_packages_jenkins" {
  depends_on = [
    azurerm_linux_virtual_machine.jenkins_vm,
  ]

  connection {
    type     = "ssh"
    user     = var.admin_username
    password = var.admin_password
    host     = azurerm_linux_virtual_machine.jenkins_vm.public_ip_address
  }

provisioner "remote-exec" {
  inline = [
        "sudo apt-get update && sudo apt-get -y upgrade",
        "sudo apt-get install -y apache2 curl",
        "sudo apt-get install -y mariadb-server",
        "sudo apt-get install -y php libapache2-mod-php php-mysql",
#        "sudo apt install openjdk-8-jdk -y",
#        "sudo apt install openjdk-11-jdk -y",
#        "curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null",
#        "echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null",
#        "sudo apt update",
#        "sudo apt install jenkins -y",
#        "sudo ufw allow 8080"
  ]
  }
}