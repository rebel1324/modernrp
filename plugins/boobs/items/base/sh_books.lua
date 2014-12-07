ITEM.name = "Book"
ITEM.model = "models/props_lab/binderblue.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.desc = "This is something you can write a doodle on."

ITEM.isURL = false
ITEM.content = [[
<html>
  <head>
    <link rel="stylesheet" type="text/css" href="http://fonts.googleapis.com/earlyaccess/nanumbrushscript.css">
    <style>
      body {
        font-family: 'Nanum Brush Script', serif;
        font-size: 19px;
        color: black;

		background: url('http://i.imgur.com/BhjRYop.png');
		width: 95%;
		height: 350px; 
      }
      .title {
        font-family: 'Nanum Brush Script', serif;
        font-size: 40px;
        color: black;
      }
      .author {
        font-family: 'Nanum Brush Script', serif;
        font-size: 16px;
        color: black;
      }
    </style>
  </head>
  <body>
  	<center>
  	<p class="title">강강술래</p>
    <div>여울에 몰린 은어 떼<br>
	삐비꽃 손들이 둘레를 짜면<br>
	달무리가 비잉빙 돈다.<br>
	<br>
	가아응 가아응 수우워얼래에<br>
	목을 빼면 설움이 솟고......<br>
	<br>
	백장미 밭에<br>
	공작이 취했다<br>
	<br>
	뛰자 뛰자 뛰어나 보자<br>
	강강술래<br>
	<br>
	뉘누리에 테프가 감긴다<br>
	열두 발 상모가 마구 돈다<br>
	<br>
	달빛이 배이면 술보다 독한 것<br>
	기폭이 찢어진다<br>
	갈대가 쓰러진다<br>
	<br>
	강강술래<br>
	강강술래<br><br></div>
  </body>
</html>
]]

// On player uneqipped the item, Removes a weapon from the player and keep the ammo in the item.
ITEM.functions.use = { -- sorry, for name order.
	name = "Use",
	tip = "useTip",
	icon = "icon16/world.png",
	onRun = function(item)
		if (item.player and IsValid(item.player)) then
			netstream.Start(item.player, "readBook", item.uniqueID)
		end

		return false
	end,
}
