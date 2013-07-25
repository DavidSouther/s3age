class S3age.Clock
	constructor: (performance = Date.now, autoStart = false)->
		started = old = @elapsed = @delta = 0
		running = !!autoStart
		tick = =>
			if running
				old = @elapsed
				@elapsed = performance() - started
				@delta = @elapsed - old
			window.requestAnimationFrame tick

		@start = ->
			running = true
			started = performance()
			tick()
			@

		if @running
			@start()

		# TODO Add pause handling