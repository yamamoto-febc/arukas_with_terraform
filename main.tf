resource "arukas_container" "arukas01"{
    name = "terraform_for_arukas_hello"

    # ArukasIOのCentOSイメージを利用
    image = "arukasio/quickstart-centos"

    # ポート0(エンドポイント経由で公開される、Web用に80番ポートを指定)
    ports = {
        protocol = "tcp"
        number = "80"
    }
    # ポート1(SSH接続用)
    ports = {
        protocol = "tcp"
        number = "22"
    }

    # SSH認証用に公開鍵を環境変数で指定
    environments {
        key = "AUTHORIZED_KEY"
        value = "${file("keys/id_rsa.pub")}"
    }

    ####################
    # 以下プロビジョニング
    ####################
    # SSH接続
    connection {
        user = "root"
        port = "${arukas_container.arukas01.port_mappings.1.service_port}"
        host = "${arukas_container.arukas01.port_mappings.1.host}"
        private_key = "${file("keys/id_rsa")}"
    }

    # Apacheをインストール、起動
    provisioner "remote-exec" {
        inline = [
          "yum install -y httpd httpd-devel",
          "/usr/sbin/httpd -k restart"
        ]
    }

    # 手元マシンからコンテンツをアップロード
    provisioner "file" {
        source = "contents/"
        destination = "/var/www/html/"
    }
}

###############################
# SSH接続コマンド(output)
###############################
output "ssh" {
    value = "ssh -p ${arukas_container.arukas01.port_mappings.1.service_port} -i ${path.root}/id_rsa root@${arukas_container.arukas01.port_mappings.1.host}"
}
###############################
# Endpoint(Arukasが自動割り当て)
###############################
output "endpoint_url" {
    value = "${arukas_container.arukas01.endpoint_full_url}"
}

