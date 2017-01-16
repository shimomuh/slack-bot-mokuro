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
    responseMessages = []

    # ---------------
    # 追加
    # ---------------
    if result = /(追加|add)\s*(\S+.*)/i.exec(secondCommands)
      item = "#{result[2]} by #{msg.message.user.name}"
      buyList = robot.brain.get(key) ? []
      buyList.push { createdAt: moment(), name: item }
      robot.brain.set(key, buyList)
      robot.brain.save()
      responseMessages.push "もっふふー :heart: (#{result[2]}を追加したよ)"
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
        responseMessages.push "もふう :bangbang: (全部削除したよ)"

      # ---------------
      # 部分削除
      # ---------------
      if item.size == 0
        return msg.send "もふもふもっふー :bangbang: (買い物リストで表示される文字を入力してね)"

      candidates = []
      rest = []
      buyList = robot.brain.get(key) ? []
      for buyItem in buyList
        if (new RegExp(item)).exec(buyItem.name)?
          candidates.push buyItem
        else
          rest.push buyItem
      if candidates.length == 1
        robot.brain.set(key, rest)
        robot.brain.save()
        responseMessages.push "もふっ :exclamation: (#{candidates[0].name}を削除したよ)"
      else if candidates.length == 0
        responseMessages.push "もふもふふ (削除したいものが見つからないよ)"
      else
        responseMessages.push "もふー :x: :x: (削除したいものが多すぎるよ)"

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
      "#{index++}. #{moment(item.createdAt).format('YYYY-MM-DD(ddd)')} #{item.name}"
    .join '\n'
    responseMessages.push "```#{message}```"
    msg.send responseMessages.join '\n'
