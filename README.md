# HUBOT

https://hubot.github.com/

Github 社が作っているチャットのボットのフレームワーク

オープンソースで、 Node.js と CoffeeScript で書かれている

Hubot を使うことでチャットツールから様々なオペレーションが出来るようになる (ChatOps)

## Getting Start

node.js, npm, redis をインストール
```
$ yum install -y nodejs --enablerepo=epel
$ yum install -y npm --enablerepo=epel
$ yum install -y redis --enablerepo=epel
```

npm で coffe-script, hubot generator をインストール
```
$ npm install -g coffe-script
$ npm install -g yo
$ npm install -g generator-hubot
```

プロジェクトディレクトリを作成して、 Hubot のインスタンスを作成
```
$ mkdir hubot
$ cd hubot
$ yo hubot

                     _____________________________
                    /                             \
   //\              |      Extracting input for    |
  ////\    _____    |   self-replication process   |
 //////\  /_____\   \                             /
 ======= |[^_/\_]|   /----------------------------
  |   | _|___@@__|__
  +===+/  ///     \_\
   | |_\ /// HUBOT/\\
   |___/\//      /  \\
         \      /   +---+
          \____/    |   |
           | //|    +===+
            \//      |xx|

? Owner: User <user@example.com>
? Bot name: hubot
? Description: A simple helpful robot for your Company
? Bot adapter: campfire
   create bin/hubot
   create bin/hubot.cmd
   create Procfile
   create README.md
   create external-scripts.json
   create hubot-scripts.json
   create .gitignore
   create package.json
   create scripts/example.coffee
   create .editorconfig

                     _____________________________
 _____              /                             \
 \    \             |   Self-replication process   |
 |    |    _____    |          complete...         |
 |__\\|   /_____\   \     Good luck with that.    /
   |//+  |[^_/\_]|   /----------------------------
  |   | _|___@@__|__
  +===+/  ///     \_\
   | |_\ /// HUBOT/\\
   |___/\//      /  \\
         \      /   +---+
          \____/    |   |
           | //|    +===+
            \//      |xx|

```

## 実行

shell adapter で起動
```
$ bin/hubot
hubot>
```

起動確認
```
hubot> hubot ping
hubot> PONG
```

## スクリプト作成

## HipChat と連携

### HipChat アダプターを追加
※ node.js のバージョンが 0.12 以上である必要がある
```
$ npm install hubot-hipchat
```










