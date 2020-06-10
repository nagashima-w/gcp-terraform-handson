# gcp-terraform-handson

TerraformでGCPを操作するためのちょっとしたハンズオンのリポジトリ

## はじめる前に

このハンズオンを行うための想定環境は以下になります

- macOS 10.15
- VSCode & Terraformプラグイン
- Terraform version 0.12.26
  - tfenvをインストールして、そこからバージョンを切り替えることをおすすめします
    - `brew install tfenv`
    - `tfenv install 0.12.26`
    - `tfenv use 0.12.26`

## コンテンツ

0. [事前準備](preparation/README.md)
1. [とりあえずTerraformを書いてデプロイしてみる](minimal/README.md)
2. [VMインスタンスを1台だけ構築してみる](vm/README.md)
3. [Cloud Runをデプロイしてみる](cloud-run/README.md)
4. [TerraformのTips集](tips/README.md)
