# The original THREE clock has a non-functional interface.
# When gettting a time, *every* call to elapsed or delta will cause
# a tick. This requires a single point to get and scale the time,
# and pass that value around.
#
# This clock ticks once per animation frame, and can gracefully handle
# pausing, both explicitly by calling pause(), and implicitly when
# the animation context is paused by the browser.
class S3age.Clock
	constructor: (performance = Date.now, autoStart = false)->
		started = old = @elapsed = @delta = 0
		running = !!autoStart
		tick = =>
			if running
				old = @elapsed
				@now = performance()
				@elapsed = @now - started
				@delta = @elapsed - old

		@start = ->
			running = true
			started = performance()
			tick()
			@

		@start() if running
		# TODO Add pause handling
		# TODO Add @seconds, which holds the time scaled by 0.001
		# TODO disabling setting properties (Object.defineProperty)
