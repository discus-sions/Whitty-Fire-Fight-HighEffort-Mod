function onCreate()
	-- background shit
	makeLuaSprite('whittyBack', 'whittyBack', -600, -300);
	setLuaSpriteScrollFactor('whittyBack', 0.9, 0.9);
	
	makeLuaSprite('whittyFront', 'whittyFront', -650, 600);
	setLuaSpriteScrollFactor('whittyFront', 0.9, 0.9);
	scaleObject('whittyFront', 1.1, 1.1);

	-- sprites that only load if Low Quality is turned off

	addLuaSprite('whittyBack', false);
	addLuaSprite('whittyFront', false);
	addLuaSprite('stagelight_left', false);
	addLuaSprite('stagelight_right', false);
	addLuaSprite('stagecurtains', false);
	
	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end