# Descripotion:
#   買い物リストを表示する子
#
# Commands:
#   買い物リスト
#   買い物リスト 追加 なすび
#   買い物リスト 削除 納豆
#   buylist
#   buylist add なすび
#   buylist remove 納豆
#
# Author:
#   shimomuh <shimomuh0501@gmail.com>

moment = require 'moment'

module.exports = (robot) ->
  moment.locale('ja')
  key = 'buy-list'
  robot.hear /(買い物リスト|buylist|buy-list|buy list)(.*)/i, (msg) ->
    secondCommands = msg.match[2]

    # ---------------
    # 追加
    # ---------------
    if result = /(追加|add)\s*(\S+.*)/i.exec(secondCommands)
      item = result[2]
      buyList = robot.brain.get(key) ? []
      buyList.push { createdAt: moment(), name: "#{item} by #{msg.message.user.name}" }
      robot.brain.set(key, buyList)
      robot.brain.save()
      msg.send "もっふふー :heart: (#{item}を追加したよ)"
      # 一覧表示のためあえて return しない

    # ---------------
    # 削除
    # ---------------
    else if result = /(削除|remove|delete)\s*(\S+.*)/i.exec(secondCommands)
      item = result[2]

      # ---------------
      # 全件
      # ---------------
      if /(全部|ぜんぶ|all)/i.exec(item)
        robot.brain.set(key, [])
        robot.brain.save()
        msg.send "もふう :bangbang: (全部削除したよ)"
        # 一覧表示のためあえて return しない

      # ---------------
      # 部分削除
      # ---------------
      if isNaN(parseInt(item))
        return msg.send "もふもふもっふー :bangbang: (買い物リストで表示される数字を入力してね)"
      index = item
      buyList = robot.brain.get(key) ? []
      sortedBuyList = buyList.sort (a, b) ->
        if a.createdAt == b.createdAt
          0
        else if a.createdAt < b.createdAt
          -1
        else
          1
      item = sortedBuyList.splice(index - 1, 1)
      robot.brain.set(key, sortedBuyList)
      robot.brain.save()
      msg.send "もふっ :exclamation: (削除したよ)"
      # あえて return せずリストを表示

    # ---------------
    # 一覧表示
    # ---------------
    buyList = robot.brain.get(key) ? []
    if buyList.length == 0
      return msg.send "もふもふ (買いたいものはないよ)"
    index = 1
    message = buyList.sort (a, b) ->
      if a.createdAt == b.createdAt
        0
      else if a.createdAt < b.createdAt
        -1
      else
        1
    .map (item) ->
      "#{index++}. #{item.createdAt.format('YYYY-MM-DD(ddd)')} #{item.name}"
    .join '\n'
    msg.send message
