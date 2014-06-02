# description:
# set jobs

cron = require('cron').CronJob
lunch_message = ["メッシ！", "はらへ", "ｼｭｯｼｭｯｼｭｯｼｭｯ"]


module.exports = (robot) ->
  robot.enter ->
  new cron
    cronTime: "0 0 13 * * 1-5"
    start: true
    timeZone: "Asia/Tokyo"
    onTick: ->
      robot.send {room: "#general"}, ["@everyone", lunch_message[Math.floor(Math.random() * lunch_message.length)]].join(" ")
  new cron
    cronTime: "0 0 19 * * *"
    start: true
    timeZone: "Asia/Tokyo"
    onTick: ->
      request = robot.http('http://animemap.net/api/table/tokyo.json').get()
      request (err, res, body) ->
        json = JSON.parse body
        result = "@moyashi @j_taro_origin 今日のアニメです！\n"
        for anime, i in json.response.item
          if anime.today is "1"
            result += [anime.time, "『" + anime.title + "』", anime.next, anime.station].join(" ")
            result += "\n"
        robot.send {room: "#general"}, result
  new cron
    cronTime: "0 */5 * * * *"
    start: true
    timeZone: "Asia/Tokyo"
    onTick: ->
      dateFormat = require('dateformat')
      dateObj = new Date();
      now = Math.floor(dateObj.getTime() / 1000)
      request = robot.http('http://animemap.net/api/table/tokyo.json').get()
      request (err, res, body) ->
        json = JSON.parse body
        for anime, i in json.response.item
          if anime.today is "1"
            start_time_array = anime.time.split(':')
            start_hours = parseInt(start_time_array[0])
            if start_hours >= 24
              start_time_array[0] = ('0' + String(start_hours - 24)).slice(-2)
            start_time_array.push('00')
            start_time = start_time_array.join(':')
            start_datetime = dateFormat(dateObj, 'yyyy/mm/dd ') + start_time
            start_timestamp = Date.parse(start_datetime) / 1000
            if start_timestamp in [now..now+299]
              robot.send {room: "#general"}, anime.title