# Description:
#   もくろーを呼びつけると返事してくれる子
#
# Commands:
#   もくろー
#   モクロー
#
# Author:
#   shimomuh <shimomuh0501@gmail.com>

module.exports = (robot) ->
  callList = [
    'もふう :exclamation:'
    'もっふふ♪'
    'もふぅ :question:'
    'もふーーー :bangbang:'
    'もふもふ :heart:'
    ':zzz:'
    ':bangbang:'
  ]
  robot.hear /(もくろー|モクロー)/, (msg) ->
    msg.send msg.random callList
