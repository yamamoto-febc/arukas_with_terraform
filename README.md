# arukas_with_terraform

[Qiita:Terraform for ArukasでSSHプロビジョニング](http://qiita.com/items/6a4a7e9231c58b9cebd2/)のサンプルコードです。

## Usage

```bash
$ git clone https://github.com/yamamoto-febc/arukas_with_terraform.git
$ cd arukas_with_terraform

# create SSH keypair.
$ ssh-keygen -C "" -f keys/id_rsa

# create html contents.
$ echo "Test contents." >> contents/index.html

# create & run container on arukas.
$ terraform apply

# confirm the endpoint URL.
$ terraform output endpoint_url
```
