module.exports = (robot) ->
  robot.error (err, msg) ->
    robot.logger.error "#{err}\n#{err.stack}"

    if msg?
      msg.reply "#{err}\n#{err.stack}"
