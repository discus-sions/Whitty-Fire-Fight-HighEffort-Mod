function onCreate()
	-- background shit
	makeAnimatedLuaSprite('BallisticBackground', 'BallisticBackground', -650, -200);
	setLuaSpriteScrollFactor('BallisticBackground', 0.9, 0.9);
	

	-- sprites that only load if Low Quality is turned off

	addLuaSprite('BallisticBackground', false);
	addLuaSprite('whittyFront', false);
	addLuaSprite('stagelight_left', false);
	addLuaSprite('stagelight_right', false);
	addLuaSprite('stagecurtains', false);
	
	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end