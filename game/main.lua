version = 'V0.00'-- CRESTFALLEN - BY XAVYRR
gameStates = {
	start = {load, draw, update},
	menu = {load, draw, update},
	core = {load, draw, update},
	intro = {load, draw, update},
	game = {load, draw, update},
}
function changeState()
	love.audio.stop()
	love.load()
end
gameState = 'start'
require('start')
require('menu')
require('game')
require('intro')
fnt_main = love.graphics.newFont('data/fnt_main_mono.otf', 16)
--fnt_main_mono = love.graphics.newFont('data/fnt_main_mono.otf', 16)
fnt_small = love.graphics.newFont('data/fnt_small.ttf', 8)
img_select = love.graphics.newImage('img/menu/soul_small.png')
img_flower = love.graphics.newImage('img/dream/flower.png')
gt = 0 --gt is a substitute for dt, which only counts while in game, and not when the game is paused like when using the home menu. Prevents timer issues.
inputTimer = 0
allowInput = true
love.graphics.set3D(true)
math.randomseed(os.time())
function math.sign(x)
	return x>0 and 1 or x<0 and -1 or 0
end
function love.load()
	love.audio.stop()
	gameStates[gameState].load()
end

function love.draw()
	gameStates[gameState].draw()
	love.graphics.setScreen('bottom')
	if love.mouse.isDown(0) then
		love.graphics.setColor(255, 255, 255, 5)
		love.graphics.rectangle('fill', 0, 0, 320, 240)
		love.graphics.setColor(255, 255, 255, 10)
	else love.graphics.setColor(255, 255, 255, 5) end
	love.graphics.setFont(fnt_small)
	love.graphics.setDepth(0)
	love.graphics.draw(img_flower, 98, 59)
end

function love.update(dt)
	if dt >= 1 then gt = 0
	else gt = dt end-- gt can only increase WHILE the game is running and NOT in a paused state, unlike dt.
	gameStates[gameState].update(gt)
	inputTimer = inputTimer + gt
end

function love.keypressed(key)
end
function love.keyheld(key)
end

function love.quit()
	love.audio.stop()
end
