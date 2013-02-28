# Description:
#   Playing with Drush integration.
#
# Commands:
#   hubot drush cc <site alias> - Clears the cache for a given site alias.

util = require("util")
spawn = require("child_process").spawn

module.exports = (robot) ->
  robot.respond /drush sa$/i, (msg) ->
    if not process.env.DRUSH_UID?
      msg.send "DRUSH_UID is not set. Cannot complete this action."
      return
    try
      process.setuid Number process.env.DRUSH_UID
      msg.send "New UID set to: " + process.getuid()
    catch err
      msg.send "Unable to set uid. " + err

    #    sitelist = ''
    #    sitealias = spawn("drush", ["sa"])
    #    sitealias.stdout.on "data", (data) ->
    #      sitelist = sitelist + data

    #    sitealias.on "exit", (code) ->
    #  msg.send sitelist

  robot.respond /drush cc (.*)$/i, (msg) ->
    ccout = ''
    clearcache = spawn("drush", [msg.match[1], "cc", "all"])
    msg.send "This may take a minute, please be patient..."
    clearcache.stdout.on "data", (data) ->
      ccout = ccout + data

    clearcache.stderr.on "data", (data) ->
      ccout = ccout + data

    clearcache.on "exit", (code) ->
      if code is 0
        msg.send ccout
      else
        msg.send "Drush experienced and error."
