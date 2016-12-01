# Description:
#   モクロー/もくろー
#
# Commands
#   もふう

module.exports = (robot) ->
  robot.hear /(もくろー|モクロー)/, (msg) ->
    msg.send 'もふう'
