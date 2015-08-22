#!/bin/bash

export PATH="node_modules/.bin:node_modules/hubot/node_modules/.bin:$PATH"

# 環境変数の設定
export HUBOT_HIPCHAT_JID="403375_2485546@chat.hipchat.com"
export HUBOT_HIPCHAT_PASSWORD="ikeda0501"

export HUBOT_CHATWORK_TOKEN="a099d2e3bd691a23212116532e48eb05" # APIのアクセストークンを入力します。
export HUBOT_CHATWORK_ROOMS="34268496"   # カンマ区切りでルームIDを指定します。
export HUBOT_CHATWORK_API_RATE="500"   # 1時間あたりのAPIリクエスト数(間隔)を指定します。

# foreverでhubotをデーモンで起動
case $1 in
    "start" | "stop" | "restart" )
       forever $1 \
           --pidfile /var/run/mana_bot.pid \
           -c coffee node_modules/.bin/hubot --adapter chatwork --name "mark2"
    ;;
    * ) echo "usage: manabot.sh start|stop|retart" ;;
esac

