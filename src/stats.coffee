# stats.coffee - http://github.com/mrdoob/stats.js
Stats = ->
  l = Date.now()
  m = l
  g = 0
  n = Infinity
  o = 0
  h = 0
  p = Infinity
  q = 0
  r = 0
  s = 0
  f = document.createElement("div")
  f.id = "stats"
  f.addEventListener "mousedown", ((b) ->
    b.preventDefault()
    t ++s % 2
  ), not 1
  f.style.cssText = "width:80px;opacity:0.9;cursor:pointer"
  a = document.createElement("div")
  a.id = "fps"
  a.style.cssText = "padding:0 0 3px 3px;text-align:left;background-color:#002"
  f.appendChild a
  i = document.createElement("div")
  i.id = "fpsText"
  i.style.cssText = "color:#0ff;font-family:Helvetica,Arial,sans-serif;font-size:9px;font-weight:bold;line-height:15px"
  i.innerHTML = "FPS"
  a.appendChild i
  c = document.createElement("div")
  c.id = "fpsGraph"
  c.style.cssText = "position:relative;width:74px;height:30px;background-color:#0ff"
  a.appendChild(c)
  while 74 > c.children.length
    j = document.createElement("span")
    j.style.cssText = "width:1px;height:30px;float:left;background-color:#113"
    c.appendChild j
  d = document.createElement("div")
  d.id = "ms"
  d.style.cssText = "padding:0 0 3px 3px;text-align:left;background-color:#020;display:none"
  f.appendChild d
  k = document.createElement("div")
  k.id = "msText"
  k.style.cssText = "color:#0f0;font-family:Helvetica,Arial,sans-serif;font-size:9px;font-weight:bold;line-height:15px"
  k.innerHTML = "MS"
  d.appendChild k
  e = document.createElement("div")
  e.id = "msGraph"
  e.style.cssText = "position:relative;width:74px;height:30px;background-color:#0f0"
  d.appendChild(e)
  while 74 > e.children.length
    j = document.createElement("span")
    j.style.cssText = "width:1px;height:30px;float:left;background-color:#131"
    e.appendChild(j)
  t = (b) ->
    s = b
    switch s
      when 0
        a.style.display = "block"
        d.style.display = "none"
      when 1
        a.style.display = "none"
        d.style.display = "block"

  REVISION: 11
  domElement: f
  setMode: t
  begin: ->
    l = Date.now()

  end: ->
    b = Date.now()
    g = b - l
    n = Math.min(n, g)
    o = Math.max(o, g)
    k.textContent = g + " MS (" + n + "-" + o + ")"
    a = Math.min(30, 30 - 30 * (g / 200))
    e.appendChild(e.firstChild).style.height = a + "px"
    r++
    b > m + 1e3 and (
      h = Math.round(1e3 * r / (b - m))
      p = Math.min(p, h)
      q = Math.max(q, h)
      i.textContent = h + " FPS (" + p + "-" + q + ")"
      a = Math.min(30, 30 - 30 * (h / 100))
      c.appendChild(c.firstChild).style.height = a + "px"
      m = b
      r = 0
    )
    b

  update: ->
    l = @end()
