function gameStates.dream.load()
  dream = {
    states = {'sleep', 'normal', 'warp', 'pause'},
    state = 'normal',
    curRoom = 0,
    fade = 0,
    frameTimer = 0,
    warp = { goto = 0, spawn = 0, transition = false},
    frisk = { x = 170, y = 140, dir = 3, frame = 0, spd = 1, hsp = 0, vsp = 0,
      spr = {
        normal = {
          [0] = {
            [0] = love.graphics.newImage('img/dream/frisk/0_0.png'),
            [1] = love.graphics.newImage('img/dream/frisk/0_1.png'),
          },
          [1] = {
            [0] = love.graphics.newImage('img/dream/frisk/1_0.png'),
            [1] = love.graphics.newImage('img/dream/frisk/1_1.png'),
            [3] = love.graphics.newImage('img/dream/frisk/1_2.png'),
          },
          [2] = {
            [0] = love.graphics.newImage('img/dream/frisk/2_0.png'),
            [1] = love.graphics.newImage('img/dream/frisk/2_1.png'),
          },
          [3] = {
            [0] = love.graphics.newImage('img/dream/frisk/3_0.png'),
            [1] = love.graphics.newImage('img/dream/frisk/3_1.png'),
            [3] = love.graphics.newImage('img/dream/frisk/3_2.png'),
          },
        },
        sleep = {

        },
      },
    },
    room = {
      [0] = {
        bg = love.graphics.newImage('img/dream/room/0.png'),
        x = 90, -- room bg x offset
        y = 21, -- room bg y offset
        w = 400, --room width
        h = 240, -- room height
        wall = { --easy basic walls to set up
          [0] = 273, -- east x
          [1] = 100, -- north y
          [2] = 120, -- west x
          [3] = 272, -- south y
        },
        warp = { -- total number of warp/doors
          [0] = {x1 = 242, y1 = 200, x2 = 273, y2 = 215, goto = 1, spawn = 0,}
        },
        spawn = { --where you spawn/ arrive from a warp
          [0] = {x = 257, y = 188, dir = 1},
        },
        object = {
          [0] = {x1 = 235, y1 = 97, x2 = 276, y2 = 140,},
          [1] = {x1 = 255, y1 = 137, x2 = 276, y2 = 160,},
          [2] = {x1 = 116, y1 = 195, x2 = 241, y2 = 215,},
        },
      },
      [1] = {
        bg = love.graphics.newImage('img/dream/room/1.png'),
        x = 0,
        y = 42,
        w = 400,
        h = 240,
        wall = { --easy basic walls to set up
          [0] = 400, -- east x
          [1] = 104, -- north y
          [2] = 0 , -- west x
          [3] = 169, -- south y
        },
        warp = { -- total number of warp/doors
          [0] = {x1 = 160, y1 = 105, x2 = 180, y2 = 116, goto = 0, spawn = 0,},
        },
        spawn = { --where you spawn/ arrive from a warp
          [0] = {x = 170, y = 126, dir = 3,},
        },
        object = {
          [0] = {x1 = 0, y1 = 105, x2 = 159, y2 = 121,},
          [1] = {x1 = 181, y1 = 105, x2 = 368, y2 = 121,},
          [2] = {x1 = 258, y1 = 122, x2 = 331, y2 = 168,}, --hole
        },
      },
    },
  }
  function dream.doCollision(x0, y0, hsp, vsp, curRoom)
    --make local vars
    local x1 = x0 + hsp
    local y1 = y0 + vsp
    --wall collision
    if x1 > dream.room[curRoom].wall[0] then dream.frisk.hsp = 0 end
    if x1 < dream.room[curRoom].wall[2] then dream.frisk.hsp = 0 end
    if y1 > dream.room[curRoom].wall[3] then dream.frisk.vsp = 0 end
    if y1 < dream.room[curRoom].wall[1] then dream.frisk.vsp = 0 end
    --object collision
    for  i = 0, 30, 1 do
      if hsp == 0 and vsp == 0 then break end --skip collision if you aren't moving (stopped by wall collision)
      if x1 > dream.room[curRoom].object[i].x1 and x1 < dream.room[curRoom].object[i].x2 and y0 > dream.room[curRoom].object[i].y1 and y0 < dream.room[curRoom].object[i].y2 then
        dream.frisk.hsp = 0
      end
      if x0 > dream.room[curRoom].object[i].x1 and x0 < dream.room[curRoom].object[i].x2 and y1 > dream.room[curRoom].object[i].y1 and y1 <                   dream.room[curRoom].object[i].y2 then
        dream.frisk.vsp = 0
      end
      if dream.room[curRoom].object[i+1] == nil then break end
    end
  end

  -- do warp
  function dream.doWarp(room, spawn)
    dream.curRoom = room
    dream.frisk.x = dream.room[room].spawn[spawn].x
    dream.frisk.y = dream.room[room].spawn[spawn].y
    dream.frisk.dir = dream.room[room].spawn[spawn].dir
  end
  -- check if on a warp
  function dream.checkWarp(x, y)
    for i = 0, 10, 1 do
      if x > dream.room[dream.curRoom].warp[i].x1 and x < dream.room[dream.curRoom].warp[i].x2 and y > dream.room[dream.curRoom].warp[i].y1 and y < dream.room[dream.curRoom].warp[i].y2 then
        dream.warp.goto = dream.room[dream.curRoom].warp[i].goto
        dream.warp.spawn = dream.room[dream.curRoom].warp[i].spawn
        dream.warp.transition = 0
        dream.state = 'warp'
        dream.frameTimer = 0
      end
      if dream.room[dream.curRoom].warp[i+1] == nil then break end
    end
  end
end

function gameStates.dream.draw()
  love.graphics.setScreen('top')
  love.graphics.setFont(fnt_main)
  love.graphics.setDepth(0)
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.draw(dream.room[dream.curRoom].bg, dream.room[dream.curRoom].x, dream.room[dream.curRoom].y)
  if dream.frisk.spr.normal[dream.frisk.dir][dream.frisk.frame] == nil then
    love.graphics.draw(dream.frisk.spr.normal[dream.frisk.dir][0], dream.frisk.x - 9, dream.frisk.y - 26)
  else
    love.graphics.draw(dream.frisk.spr.normal[dream.frisk.dir][dream.frisk.frame], dream.frisk.x - 9, dream.frisk.y - 26)
  end
  if dream.state == 'warp' then -- draw black screen fade
    love.graphics.setColor(0, 0, 0, dream.fade)
    love.graphics.rectangle('fill', -5, -5, 405, 245)
  end
end

function gameStates.dream.update(gt)
  if dream.state == 'normal' then
    dream.frisk.hsp = 0
    dream.frisk.vsp = 0
    dream.frameTimer = dream.frameTimer + 5 * gt
    dream.frisk.frame = 0
    if love.keyboard.isDown('right') then dream.frisk.hsp = dream.frisk.hsp + dream.frisk.spd end
    if love.keyboard.isDown('left') then dream.frisk.hsp = dream.frisk.hsp - dream.frisk.spd end
    if love.keyboard.isDown('up') then dream.frisk.vsp = dream.frisk.vsp - dream.frisk.spd end
    if love.keyboard.isDown('down') then dream.frisk.vsp = dream.frisk.vsp + dream.frisk.spd end
    if dream.frisk.hsp > 0 then dream.frisk.dir = 0 end
    if dream.frisk.hsp < 0 then dream.frisk.dir = 2 end
    if dream.frisk.vsp < 0 then dream.frisk.dir = 1 end
    if dream.frisk.vsp > 0 then dream.frisk.dir = 3 end
    if dream.frisk.vsp ~= 0 and dream.frisk.hsp ~= 0 then
      dream.frisk.hsp = dream.frisk.hsp*.5
      dream.frisk.vsp = dream.frisk.vsp*.5
    end
    dream.checkWarp(dream.frisk.x, dream.frisk.y)
    dream.doCollision(dream.frisk.x, dream.frisk.y, dream.frisk.hsp, dream.frisk.vsp, dream.curRoom)
    if dream.frisk.vsp ~= 0 or dream.frisk.hsp ~= 0 then
      dream.frisk.x = dream.frisk.x + dream.frisk.hsp
      dream.frisk.y = dream.frisk.y + dream.frisk.vsp
      if dream.frameTimer >= 4 then dream.frameTimer = 0 end
      if dream.frameTimer >= 2 and (dream.frisk.dir == 0 or dream.frisk.dir == 2 ) then dream.frameTimer = 0 end
      dream.frisk.frame = math.floor(dream.frameTimer)
    else
      dream.frameTimer = 0
    end
  end
  if dream.state == 'warp' then
    if dream.warp.transition then
      if dream.frameTimer < 1 then
        dream.frameTimer = dream.frameTimer + 2 * gt
      else
        dream.doWarp(dream.warp.goto, dream.warp.spawn)
        dream.warp.transition = false
        dream.frameTimer = 1
      end
    else
      if dream.frameTimer > 0 then
        dream.frameTimer = dream.frameTimer - 2 * gt
      else
        dream.frameTimer = 0
        dream.state = 'normal'
      end
    end
    dream.fade = 255 * dream.frameTimer
    if dream.fade > 255 then dream.fade = 255 end
    if dream.fade < 0 then dream.fade = 0 end
  end
  if love.keyboard.isDown('start') then love.event.quit() end
end
