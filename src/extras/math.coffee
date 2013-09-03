THREE.Vector3::fromSpherical = (theta, phi, r)->
	st = Math.sin theta
	ct = Math.cos theta
	sp = Math.sin phi
	cp = Math.cos phi

	@x = r * sp * ct
	@z = r * sp * st
	@y = r * cp

	@

window.Damper = (@position = 0, @friction = 0.1)->
	@velocity = 0
	@
Damper::step = ->
	@position += @velocity
	@velocity *= 1 - @friction
	@

Damper::push = (acceleration)->
	@velocity += acceleration
	@

window.BoundDamper = (@min = -1, @max = 1, @position = 0, @friction = 0.1)->
	Damper.call @
	@delta = (@max - @min) * 2
	@
BoundDamper:: = Object.create Damper::
BoundDamper::step = ->
	Damper::step.call @
	@position = @position.clamp @min, @max
	@
BoundDamper::push = (acceleration)->
	Damper::push.call @, acceleration
	@velocity = @velocity.clamp -@friction * @delta, @friction * @delta
	@

window.SigmoidDamper = (@friction = 0.1)->
	@point = 0
	BoundDamper.call @, -6, 6
	Object.defineProperty @, 'position',
		set: (val)-> @point = val
		get: -> Math.sigmoid @point
	@

SigmoidDamper:: = Object.create BoundDamper::
SigmoidDamper::step = ->
	@point += @velocity
	@point = @point.clamp @min, @max
	@velocity *= 1 - @friction
	@velocity = @velocity.clamp -@friction * @delta, @friction * @delta
	@

Number::clamp = Number::clamp || (a, b)-> Math.min(b, Math.max(@, a))
Math.sigmoid = Math.sigmoid || (x)-> 1 / (1 + Math.exp(-x))
Math.lerp = (v, a, b, x, y) ->
	if v is a then x
	else (v - a) * (y - x) / (b - a) + x
Math.toRad = (deg)-> deg * Math.PI / 180