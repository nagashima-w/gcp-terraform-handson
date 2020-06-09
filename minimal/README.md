# 1.とりあえずTerraformを書いてデプロイしてみる

ここでは、最低限のTerraformファイルを作成してデプロイする方法を学びます

## 1.テンプレートを作成する書く前に

何を書くにしても必ず必要なことの解説です

### プロバイダーを定義する

- Terraformでリソースを操作するためのモジュールを取得するために、プロバイダーの指定が必要です
  - GCPやAWS、Azure、Akamai等、色々なプロバイダーがあります
- Terraformを実行するにあたり、絶対に必要なパラメーターの設定です
- 必ず以下を定義します
  - GCPのAPIを叩くためのクレデンシャル
    - `file()`のカッコの中にクレデンシャルのファイルパスを書きます
    - そうすることで、ファイルの中身を展開した状態でTerraformが読み込んでくれます
  - TerraformでリソースをデプロイするGCPプロジェクトのID
- regionは必須ではありませんが、どこのリージョンにデプロイされるのかが明確になるので、基本的に指定しておいたほうが無難です
- 書き方は↓のような感じです

```hcl
provider "google" {
  credentials = file(path/to/credential)
  project     = project id
  region      = region
}
```

### 変数を入れる

これから実行してもらうテンプレートには変数があるため、それに代入するためのファイルを作成します

```bash
$ cd minimal
$ vim terraform.tfvars
```

- vimで開くようなコマンドになっていますが、好きなエディタを使ってください

以下の内容を入力してください

```txt
CREDENTIAL = "クレデンシャルファイルのパス"
PROJECT    = "Terraformでリソースを操作するプロジェクトのID"
REGION     = "asia-northeast1"
ZONE       = "asia-northeast1-b"
```

## 2.terraformのファイルを作成する

では実際に書いていきます

- ファイル名は、拡張子が`.tf`になっていれば自由です
  - 今回は最小限の記述だけでVPC Networkをつくるので、`network.tf`とかにしておくのがいいと思います
- といってもいきなりは難しいと思うので、先述のプロバイダーの定義と↓のVPC Networkのリソース定義をコピペしましょう

```hcl
resource "google_compute_network" "terraform-vpc" {
  name = "terraform-vpc"
}
```

- すると、`network.tf`の内容は以下のようになります

```hcl
provider "google" {
  credentials = file(path/to/credential)
  project     = project id
  region      = region
}

resource "google_compute_network" "terraform-vpc" {
  name = "terraform-vpc"
}
```

- この状態で完成、というわけではなく、`terraform.tfvars`に記載したクレデンシャルやプロジェクト名を入れて上げる必要があります
- `network.tf`の先頭に以下の記述を追加します

```hcl
variable "CREDENTIAL" {}
variable "PROJECT" {}
variable "REGION" {}
```

- そして、変数を利用したい箇所に変数名を入力します
  - 今回の場合はプロバイダーの部分を書き換えます

```hcl
provider "google" {
  credentials = file(CREDENTIAL)
  project     = PROJECT
  region      = REGION
}
```

ここまで実行すると、以下の内容になっています

```hcl
variable "CREDENTIAL" {}
variable "PROJECT" {}
variable "REGION" {}

provider "google" {
  credentials = file(CREDENTIAL)
  project     = PROJECT
  region      = REGION
}

resource "google_compute_network" "terraform-vpc" {
  name = "terraform-vpc"
}
```

- これで完成です

## 3.terraformコマンドを実行してみる

では、書いた`network.tf`を使って、実際にVPC Networkをデプロイしてみます

- `terraform init`
  - このコマンドでイニシャライズが実行され、プロバイダーに応じたモジュールがインストールされます
  - このとき、`.terraform`フォルダが作成されますが、すでに存在している場合は失敗します
- `terraform plan`
  - このコマンドでは、TerraformのDry-Run（実際にデプロイしたらリソースがどのように変化するかの確認）が可能です
  - また、構文に問題があった場合はここでエラーが発生します
- `terraform apply`
  - 実際にリソースをデプロイするためのコマンドです
  - `plan`のときにエラーが出なくても、ここでエラーが発生する場合があります
    - その場合は対応してから再度コマンドを実行しましょう
    - `apply`時によくあるエラーは、APIを有効にしていない or クレデンシャルの権限が不足している の大体どちらかです
      - どちらもGCP側の問題です
    - どちらでもない場合は、指定するパラメーターが間違っている場合等です
      - よくありそうなものは、stringで書かないといけないのにそのまま数字を書いているパターンです

### 4.GCPのコンソールでリソースがデプロイされていることを確認してみる

GCPのwebコンソールからネットワークが作成されていることを確認してみましょう

### 5. リソースの削除

ネットワークが作成されていることを確認できたら、リソースを削除してみましょう

```bash
$ terraform destroy
```
