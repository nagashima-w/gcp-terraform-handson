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

0. 事前準備
1. シンプルにVMインスタンスを1台だけ構築してみる
2. 複数のVMインスタンスとロードバランサーを構築してみる
3. Cloud Runをデプロイしてみる
