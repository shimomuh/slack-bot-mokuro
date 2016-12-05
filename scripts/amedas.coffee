# Description:
#   yahoo japan雨雲サーチ
#
# Configuration:
#   HUBOT_YAHOO_APP_ID
#
# Commands:
#   hubot amesh <trigger> - 指定した住所の雨雲レーダー
#   hubot amesh zoom <trigger> - 指定した住所にズームした雨雲レーダー
#
# Notes:
#   住所しか受け付けない君です
#
# Author:
#   shimomuh <shimomuh0501@gmail.com>

ameshStaticMapUrl = (lat, lon, zoom) ->
  url = [
    "http://map.olp.yahooapis.jp/OpenLocalPlatform/V1/static"
    "?appid=#{process.env.HUBOT_YAHOO_APP_ID}"
    "&lat=#{lat}"
    "&lon=#{lon}"
    "&z=#{zoom}"
    "&overlay=type:rainfall"
  ].join('')

module.exports = (robot) ->
  unless process.env.HUBOT_YAHOO_APP_ID?
    robot.logger.warning 'Required HUBOT_YAHOO_APP_ID env'
    return

  robot.hear /(アメダス|あめだす|amedasu|amedas)\s*(zoom|ズーム|ずーむ)? (.*)/i, (msg) ->
    zoom = if msg.match[2] then 14 else 12
    area = msg.match[3]

    msg.http("http://geo.search.olp.yahooapis.jp/OpenLocalPlatform/V1/geoCoder")
      .query(
        appid: process.env.HUBOT_YAHOO_APP_ID
        query: area
        results: 1
        output: 'json'
        sort: 'address2'
      )
      .get() (err, res, body) ->
        json = JSON.parse(body)
        unless json.Feature?
          msg.send 'もふぅ :question: (その場所しらないよ)'
          return

        coordinates = json.Feature[0].Geometry.Coordinates.split(",")
        msg.send ameshStaticMapUrl(coordinates[1], coordinates[0], zoom)
