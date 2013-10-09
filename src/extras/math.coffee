###
Given three prameters in spherical coordinates, set this vector's
rectangular coordinates.

@param theta {float} angle in radians from local meridian.
@param phi {float} angle in radians between 0 and Pi, angle from
	north in the spherical coordinates.
@param r {float} distance from origin of sphere.
###
THREE.Vector3::fromSpherical = (theta, phi, r)->
	st = Math.sin theta
	ct = Math.cos theta
	sp = Math.sin phi
	cp = Math.cos phi

	@x = r * sp * ct
	@z = r * sp * st
	@y = r * cp

	@

###
Geometric physical damper, along a single axis.
###
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

###
Geometric physical damper, along a boud axis.
###
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

###
Sigmoid damper.
###
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

###
Extend the Number prototype to return this number, clamped between a and b.
###
Number::clamp = Number::clamp || (a, b)-> Math.min(b, Math.max(@, a))
###
Return the value of evaluating the sigmoid function at x.
###
Math.sigmoid = Math.sigmoid || (x)-> 1 / (1 + Math.exp(-x))
###
Project between linear number line segments.
###
Math.lerp = (v, a, b, x, y) ->
	if v is a then x
	else (v - a) * (y - x) / (b - a) + x
Math.toRad = (deg)-> deg * Math.PI / 180