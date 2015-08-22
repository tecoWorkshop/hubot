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

