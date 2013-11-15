_ = require "underscore"
schedule = require("../../lib/schedule")
assert  = require("chai").assert

describe "schedule class", ->
  it "run the schedule every second, and wait until the job runs twice", (done)->
    options =
      name: "tmp"
      cron_time: "* * * * * *"
      batches: [
      ]

    newSchedule = new schedule.Schedule options, null, _.after 2, ()->  done()

    newSchedule.start()
