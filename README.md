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
### スクリプトの構造
* `scripts` ディレクトリにファイルを作成する。（デフォルトで `src/scripts` と `scripts` にパスが通っている）
* `.coffee` か `.js` 形式で記述する
* 関数をエクスポートする
```
module.exports = (robot) ->
  # your code here
```

### ボットに話しかける
* `hear` メソッドでチャットルームのメッセージを監視する
```
module.exports = (robot) ->
  robot.hear /hoge/i, (res) ->
    # your code here
```

* `respond` メソッドで直接話しかけられたメッセージに応答する
```
module.exports = (robot) ->
  robot.respond /huga/i, (res) ->
    # your code here
```

### ボットに話させる
`res` インスタンスを使用して、ボットに話をさせる
* `send` メソッドでチャットルームに対して発言させる
```
module.exports = (robot) ->
  robot.hear /badger/i, (res) ->
    res.send "Badgers? BADGERS? WE DON'T NEED NO STINKIN BADGERS"
```

* `reply` メソッドで相手に返信させる
```
module.exports = (robot) ->
  robot.respond /open the pod bay doors/i, (res) ->
    res.reply "I'm afraid I can't let you do that."
```

### 入力メッセージの取得
入力メッセージのパターンマッチを利用して、処理の出し分けができる
```
module.exports = (robot) ->
  robot.respond /open the (.*) doors/i, (res) ->
    doorType = res.match[1]
    if doorType is "pod bay"
      res.reply "I'm afraid I can't let you do that."
    else
      res.reply "Opening #{doorType} doors"
```

### HTTP 通信
HTTP リクエストでサードパーティ製の API を呼ぶことができる
```
module.exports = (robot) ->
  robot.http("https://midnight-train")
    .get() (err, res, body) ->
      if err
        res.send "Encountered an error :( #{err}"
        return
      # your code here, knowing it was successful
```

### 例）天気予報
```
# Description:
#   各地の天気を検索
#
# Commands:
#  hubot <都市名>の天気は？
#
# Author:
#  ikeda

module.exports = (robot) ->

  robot.respond /(.*)の天気は？/i, (res) ->
    area = res.match[1]

    # 都市のIDを検索
    robot.http("http://weather.livedoor.com/forecast/rss/primary_area.xml")
    .get() (err, response, body) ->
      if response.statusCode isnt 200
        res.send "Request didn't come back HTTP 200 :("
        return

      cityId = null
      cityName = null

      {parseString} = require 'xml2js'
      parseString body, (err, result) ->
        if err
          res.send "Ran into an error parsing XML :("
          return

        prefList = result["rss"]["channel"][0]["ldWeather:source"][0]["pref"]

        for pref in prefList
          for cityObj in pref["city"]
            if cityObj["$"]["title"] == area
              cityName = cityObj["$"]["title"]
              cityId   = cityObj["$"]["id"]
              break

      # 都市が検索できなければ終了
      if cityId == null
        res.send "#{area} が見つかりません"
        return

      # 都市IDで検索
      robot.http("http://weather.livedoor.com/forecast/webservice/json/v1?city=#{cityId}")
      .get() (err, response, body) ->
        if response.statusCode isnt 200
          res.send "Request didn't come back HTTP 200 :("
          return

        data = null
        try
          data = JSON.parse body
        catch error
          res.send "Ran into an error parsing JSON :("
          return

        res.send data.description.text
        return
```

## HipChat と連携

HipChat でボット用のアカウントを作成しておく

### HipChat アダプターを追加
※ node.js のバージョンが 0.12 以上である必要がある
```
$ npm install hubot-hipchat
```

### 実行スクリプトを編集
`bin/hubot` ファイルを編集して HipChat 設定を追加する
```
export HUBOT_HIPCHAT_JID="xxxxxx_xxxxxx6@chat.hipchat.com" // HipChat の Jabber ID
export HUBOT_HIPCHAT_PASSWORD="<password>" // パスワード
```

### HipChat アダプターを指定して実行
```
bin/hubot --adapter hipchat
```








