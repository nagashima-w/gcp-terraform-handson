# 2.VMインスタンスを1台だけ構築してみる

ここではVMインスタンスを構築しながら、複数のリソースを組み合わせてデプロイする方法とTerraformのバージョンを指定する方法を学びます

## 1.他リソースの属性を参照する方法

同じtfstateで管理されるリソースの属性を参照することができます

例えば、ネットワークを作成した上で、サブネットをそのネットワーク内に作成する場合、以下のような書き方ができます

```hcl
resource "google_compute_network" "vm-network" {
  name = "terraform-vm-network"
}

resource "google_compute_subnetwork" "vm-subnet" {
  name          = "terraform-subnet"
  ip_cidr_range = "10.0.1.0/24"
  network       = google_compute_network.vm-network.name
  region        = var.REGION
}
```

- ポイントは`google_compute_network.vm-network.name`の部分です
- `google_compute_network`という種類の`vm-network`で作成するリソースの`name`の属性を参照しています
- こうすることで、vm-networkの名前が変わってもサブネット側のネットワーク部分を書き直す必要がなくなります

## 2.Terraformのバージョンを指定する方法

- Terraformのバージョンはなるべく固定しましょう
- バージョンによって記法がマチマチなのと、未だこれから0.13がリリースされようかという頃（2020/05時点）なので、大きな変更も入りやすいです
- 指定する方法はとても簡単なので、基本的に書くようにしましょう
  - 指定されているバージョンが入っていなくても、tfenvで切り替えればいいだけの話です
- 方法ですが、tfファイルの先頭に↓を書くだけです

```hcl
terraform {
  required_version = "= 0.12.26"
}
```

## 3.VMインスタンスをTerraformでデプロイしてみる

ということで、Terraformのバージョンを固定しつつVMインスタンスをデプロイしてみましょう

### ファイルの作成

- 先程使った`terraform.tfvars`は使いまわしてしまいましょう

```bash
$ cd vm
$ cp ../minimal/terraform.tfvars ./
```

- ファイル名は`vm.tf`なんかがいいと思います
- 以下のリソースを定義してみましょう
  - Network
  - Subnet
  - compute instance（VM）
- サブネットは作成するVPCの中に、/24のCIDRで作成しましょう
- VMで利用するネットワークインターフェースは作成するサブネットに接続されるものにしましょう
  - 予約IPアドレスが存在するはずなので、IPアドレスを指定する場合は第4オクテットの範囲を10〜240の間にしておくと無難です
- 公式のリファレンスはこちらです
  - [compute instance](https://www.terraform.io/docs/providers/google/r/compute_instance.html)
  - [network](https://www.terraform.io/docs/providers/google/r/compute_network.html)
  - [subnetwork](https://www.terraform.io/docs/providers/google/r/compute_subnetwork.html)
  - `Required`とあるパラメーターは指定が必須のものです
  - `Optional`とあるものも、必要に応じて記述しましょう
- では、公式のリファレンスを見ながら書いてみましょう
  - 記述例は`vn.tf.example`にあります
    - **課金管理のため、compute instanceのラベルは必ず付け替えてください**

### デプロイ

- 作成ができたら、先程と同様にinit〜applyまでを実行してみてください
- 問題なくデプロイできたら、これも先程と同様に削除してしまいましょう

## 4.リソースの削除

確認ができたら、今回作成したリソースもdestroyコマンドで削除してしまいましょう
