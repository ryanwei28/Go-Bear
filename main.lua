-----------------------------------------------------------------------------------------
--設計一個小熊閃避仙人掌(?)的遊戲
-- 利用點擊畫面控制使小熊向上移動
--重力會使小熊下降
--利用遊戲經過時間來增加分數

--Author:Ryan
--Date:2016/07/31  09:28
----------------------------------------------------------------------------------------

--=======================================================================================
--引入各種函式庫
--=======================================================================================
display.setStatusBar( display.HiddenStatusBar )

local physics = require("physics")
physics.start( )
physics.pause( )
--測試加入物理性質的邊界以及實際執行效果
-- physics.setDrawMode("hybrid")
--=======================================================================================
--宣告各種變數
--=======================================================================================
_SCREEN = {
	_W = display.contentWidth ,
	_H = display.contentHeight
}
_SCREEN.CENTER = {
	X = display.contentCenterX,
	Y = display.contentCenterY
}

local bg
local obsTable = {}
local bear
local dieBear 
local startBtn
local over
local deltaX = 2 --設定一個位移量方便調整整個障礙物移動速度
local score = 0
local lebel_score 
local tmr_score 
--=======================================================================================
--宣告各個函式名稱
--=======================================================================================
local initial 
local bearImpulseUP
local endGame 
local becomeDie 
local removeStartBtn 
local rotation 
local onCollision 
local start 
local moveObs 
local addScore 
--=======================================================================================
--宣告與定義main()函式
--=======================================================================================
local main = function (  )
	initial()
end

--=======================================================================================
--定義其他函式
--=======================================================================================
initial = function ( )
	
	--加入背景圖
	bg = display.newImageRect( "images/bg2.jpg", _SCREEN._W, _SCREEN._H+100 )
	bg.x , bg.y = _SCREEN.CENTER.X , _SCREEN.CENTER.Y

	--加入障礙物仙人掌
	obsTable.top1 = display.newImageRect( "images/obsTop1.png" , _SCREEN._W*30/320 , _SCREEN._H*200/480 ) 
	obsTable.top1.x , obsTable.top1.y =  _SCREEN._W*100/320 , _SCREEN._H*(-45)/480
	obsTable.top1.anchorY = 0
	physics.addBody( obsTable.top1 , "static"  )

	obsTable.bot1 = display.newImageRect(  "images/obsBot1.png" , _SCREEN._W*30/320 , _SCREEN._H*200/480 )
	obsTable.bot1.x , obsTable.bot1.y = _SCREEN._W*100/320 , _SCREEN._H*525/480
	obsTable.bot1.anchorY = 1
	physics.addBody( obsTable.bot1 , "static"  )

	obsTable.top2 = display.newImageRect(  "images/obsTop1.png", _SCREEN._W*30/320, _SCREEN._H*240/480 )
	obsTable.top2.x , obsTable.top2.y = _SCREEN._W*230/320 , _SCREEN._H*(-45)/480
	obsTable.top2.anchorY = 0
	physics.addBody( obsTable.top2 , "static"  )

	obsTable.bot2 = display.newImageRect(  "images/obsBot1.png" , _SCREEN._W*30/320 , _SCREEN._H*160/480 )
	obsTable.bot2.x , obsTable.bot2.y = _SCREEN._W*230/320 , _SCREEN._H*525/480
	obsTable.bot2.anchorY = 1
	physics.addBody( obsTable.bot2 , "static"  )

	obsTable.top3 = display.newImageRect(  "images/obsTop1.png" , _SCREEN._W*30/320 , _SCREEN._H*280/480 )
	obsTable.top3.x , obsTable.top3.y = _SCREEN._W*360/320 , _SCREEN._H*(-45)/480
	obsTable.top3.anchorY = 0
	physics.addBody( obsTable.top3 , "static"  )

	obsTable.bot3 = display.newImageRect(  "images/obsBot1.png" , _SCREEN._W*30/320 , _SCREEN._H*120/480 )
	obsTable.bot3.x , obsTable.bot3.y = _SCREEN._W*360/320 , _SCREEN._H*525/480
	obsTable.bot3.anchorY = 1
	physics.addBody( obsTable.bot3 , "static"  )

	--加入主角小熊
	bear = display.newImageRect("images/bear.png",_SCREEN._W*60/320, _SCREEN._H*60/480)
	bear.x ,bear.y = _SCREEN._W*40/320 , _SCREEN._H*240/480
	physics.addBody( bear, "dymics" ) 

	--加入開始按鈕圖片
	startBtn = display.newImageRect("images/start2.png" ,  _SCREEN._W*130/320 , _SCREEN._H*130/480 )
	startBtn.x , startBtn.y = _SCREEN.CENTER.X , _SCREEN.CENTER.Y

	--加入遊戲結束圖片，設定為不可見
	over = display.newImageRect("images/gameover.png",_SCREEN._W*120/320 , _SCREEN._H*120/480)
	over.x , over.y = _SCREEN.CENTER.X , _SCREEN._H*50/480
	over.isVisible = false

	--加入分數text 
	lebel_score = display.newText( "Score : "..score, 15 , 10 , "Monaco" ,19 )
	lebel_score:setFillColor( 207/255 , 157/255 , 43/255 )
	lebel_score.anchorX = 0

	--偵聽到tap後開始遊戲
	startBtn:addEventListener( "tap", startGame )

end

--使小熊產生向上衝的動作
bearImpulseUP = function (event)
	bear:applyLinearImpulse( 0 , -0.13 ,bear.x , bear.y)
end 

--使障礙物移動
moveObs = function (event)

	obsTable.top1.x = obsTable.top1.x - deltaX 
	obsTable.bot1.x = obsTable.bot1.x - deltaX
	obsTable.top2.x = obsTable.top2.x - deltaX
	obsTable.bot2.x = obsTable.bot2.x - deltaX
	obsTable.top3.x = obsTable.top3.x - deltaX
	obsTable.bot3.x = obsTable.bot3.x - deltaX
	
	if obsTable.top1.x <= -20 then 
		obsTable.top1.x = obsTable.top3.x + 130
		obsTable.bot1.x = obsTable.bot3.x + 130
	elseif obsTable.top2.x <= -20 then
		obsTable.top2.x = obsTable.top1.x + 130
		obsTable.bot2.x = obsTable.top1.x + 130
	elseif obsTable.top3.x <= -20 then
		obsTable.top3.x = obsTable.top2.x + 130
		obsTable.bot3.x = obsTable.bot2.x + 130
	end	
end 

--碰撞後變成死掉的熊
becomeDie = function ()
	bear.isVisible = false
	dieBear = display.newImageRect("images/die.png",80,80)
	dieBear.x , dieBear.y = bear.x , bear.y
end	

--結束遊戲函式
endGame = function ( )
	Runtime:removeEventListener( "touch", bearImpulseUP )
	Runtime:removeEventListener( "enterFrame", moveObs )
	bear:removeEventListener( "collision", bear )
end 

--將gameover圖片加入旋轉
rotation = function( )
	transition.to (over , {time = 100 , rotation = 10 })
end 

--碰撞後結束遊戲
onCollision = function ( self , event )
	
    bear.id = "Bear" 
	obsTable.top1.id = "Crush"
	obsTable.bot1.id = "Crush"
	obsTable.top2.id = "Crush"
	obsTable.bot2.id = "Crush"
	obsTable.top3.id = "Crush"
	obsTable.bot3.id = "Crush"

    if ( event.phase == "began" ) then
    	if (self.id == "Bear" and event.other.id == "Crush") then
 			endGame()
    		becomeDie()
    		over.isVisible = true
    		transition.to( over , {time = 1000 ,y = _SCREEN.CENTER.Y } )
    		timer.performWithDelay( 1000 , rotation )
    		timer.cancel( tmr_score )
    	end
    end
end

--計算分數
addScore = function ()
	score = score + 100
	lebel_score.text = "Score : "..score
end

startGame = function()
	
	--開啟物理引擎
	physics.start( )
	
	--開始遊戲後將開始按鈕移除
	startBtn:removeSelf( )
	
	--點擊整個畫面都可以控制小熊
	Runtime:addEventListener( "touch", bearImpulseUP )

	--遊戲開始後障礙物開始移動
	Runtime:addEventListener( "enterFrame", moveObs )

	-- 碰撞後結束遊戲
 	bear.collision = onCollision
	bear:addEventListener( "collision", bear )

	--加入延時計算分數
	tmr_score = timer.performWithDelay( 80, addScore ,-1 )

end 

--=======================================================================================
--呼叫主函式
--=======================================================================================
main()
