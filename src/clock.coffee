class S3age.Clock
	constructor: (performance = Date.now, autoStart = false)->
		started = old = @elapsed = @delta = 0
		running = !!autoStart
		window.requestAnimationFrame =>
			old = @elapsed
			@elapsed = performance() - started
			@delta = @elapsed - old
			@

		@start = ->
			started = performance()
			@

		if @running
			@start()
			@tick()

		# TODO Add pause handling