package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

#if sys
import sys.io.File;
import sys.FileSystem;
import haxe.io.Path;
import openfl.utils.ByteArray;
import lime.media.AudioBuffer;
import flash.media.Sound;
#end

import openfl.display.BitmapData;

using StringTools;

class StrumNote extends FlxSprite
{
	private var colorSwap:ColorSwap;
	public var resetAnim:Float = 0;
	private var noteData:Int = 0;
	public var direction:Float = 30;//plan on doing scroll directions soon -bb

	private var player:Int;
	public var flippedNotes:Bool = false;
	public var sY:Float = 0;

	public function new(x:Float, y:Float, leData:Int, player:Int) {
		colorSwap = new ColorSwap();
		shader = colorSwap.shader;
		noteData = leData;
		this.player = player;
		this.noteData = leData;
		this.sY = y;
		super(x, y);
		trace(PlayState.SONG.arrowSkin);

		switch (PlayState.SONG.arrowSkin)
				{
					case 'pixel':
						loadGraphic('assets/images/weeb/pixelUI/arrows-pixels.png', true, 17, 17);
						animation.add('green', [6]);
						animation.add('red', [7]);
						animation.add('blue', [5]);
						animation.add('purplel', [4]);
						if (flippedNotes) {
							animation.add('blue', [6]);
							animation.add('purplel', [7]);
							animation.add('green', [5]);
							animation.add('red', [4]);
						}
						setGraphicSize(Std.int(width * PlayState.daPixelZoom));
						updateHitbox();
						antialiasing = false;
	
						switch (Math.abs(leData))
						{
							case 2:
								x += Note.swagWidth * 2;
								animation.add('static', [2]);
								animation.add('pressed', [6, 10], 12, false);
								animation.add('confirm', [14, 18], 12, false);
								if (flippedNotes) {
									animation.add('static', [1]);
									animation.add('pressed', [5, 9], 12, false);
									animation.add('confirm', [13, 17], 12, false);
								}
							case 3:
								x += Note.swagWidth * 3;
								animation.add('static', [3]);
								animation.add('pressed', [7, 11], 12, false);
								animation.add('confirm', [15, 19], 24, false);
								if (flippedNotes) {
									animation.add('static', [0]);
									animation.add('pressed', [4, 8], 12, false);
									animation.add('confirm', [12, 16], 24, false);
								}
							case 1:
								x += Note.swagWidth * 1;
								animation.add('static', [1]);
								animation.add('pressed', [5, 9], 12, false);
								animation.add('confirm', [13, 17], 24, false);
								if (flippedNotes) {
									animation.add('static', [2]);
									animation.add('pressed', [6, 10], 12, false);
									animation.add('confirm', [14, 18], 12, false);
								}
							case 0:
								x += Note.swagWidth * 0;
								animation.add('static', [0]);
								animation.add('pressed', [4, 8], 12, false);
								animation.add('confirm', [12, 16], 24, false);
								if (flippedNotes) {
									animation.add('static', [3]);
									animation.add('pressed', [7, 11], 12, false);
									animation.add('confirm', [15, 19], 24, false);
								}
						}
	
					case 'normal':
					//	if (!FlxG.save.data.circleShit)
							frames = FlxAtlasFrames.fromSparrow('assets/images/NOTE_assets.png', 'assets/images/NOTE_assets.xml');
					//	else {
					//		frames = FlxAtlasFrames.fromSparrow('assets/images/noteassets/circle/NOTE_assets.png', 'assets/images/noteassets/circle/NOTE_assets.xml');
					//	}
		
						animation.addByPrefix('green', 'arrowUP');
						animation.addByPrefix('blue', 'arrowDOWN');
						animation.addByPrefix('purple', 'arrowLEFT');
						animation.addByPrefix('red', 'arrowRIGHT');
						if (flippedNotes) {
							animation.addByPrefix('blue', 'arrowUP');
							animation.addByPrefix('green', 'arrowDOWN');
							animation.addByPrefix('red', 'arrowLEFT');
							animation.addByPrefix('purple', 'arrowRIGHT');
						}
						antialiasing = true;
						setGraphicSize(Std.int(width * 0.7));
	
						switch (Math.abs(leData))
						{
							case 2:
								x += Note.swagWidth * 2;
								animation.addByPrefix('static', 'arrowUP');
								animation.addByPrefix('pressed', 'up press', 24, false);
								animation.addByPrefix('confirm', 'up confirm', 24, false);
								if (flippedNotes) {
									animation.addByPrefix('static', 'arrowDOWN');
									animation.addByPrefix('pressed', 'down press', 24, false);
									animation.addByPrefix('confirm', 'down confirm', 24, false);
								}
							case 3:
								x += Note.swagWidth * 3;
								animation.addByPrefix('static', 'arrowRIGHT');
								animation.addByPrefix('pressed', 'right press', 24, false);
								animation.addByPrefix('confirm', 'right confirm', 24, false);
								if (flippedNotes) {
									animation.addByPrefix('static', 'arrowLEFT');
									animation.addByPrefix('pressed', 'left press', 24, false);
									animation.addByPrefix('confirm', 'left confirm', 24, false);
								}
							case 1:
								x += Note.swagWidth * 1;
								animation.addByPrefix('static', 'arrowDOWN');
								animation.addByPrefix('pressed', 'down press', 24, false);
								animation.addByPrefix('confirm', 'down confirm', 24, false);
								if (flippedNotes) {
									animation.addByPrefix('static', 'arrowUP');
									animation.addByPrefix('pressed', 'up press', 24, false);
									animation.addByPrefix('confirm', 'up confirm', 24, false);
								}
							case 0:
								x += Note.swagWidth * 0;
								animation.addByPrefix('static', 'arrowLEFT');
								animation.addByPrefix('pressed', 'left press', 24, false);
								animation.addByPrefix('confirm', 'left confirm', 24, false);
								if (flippedNotes) {
									animation.addByPrefix('static', 'arrowRIGHT');
									animation.addByPrefix('pressed', 'right press', 24, false);
									animation.addByPrefix('confirm', 'right confirm', 24, false);
								}
						}
					default:
						
						if (FileSystem.exists('assets/images/'+PlayState.SONG.arrowSkin+"/NOTE_assets.xml") && FileSystem.exists('assets/images/'+PlayState.SONG.arrowSkin+"/NOTE_assets.png")) {
	
						  var noteXml = File.getContent('assets/images/custom_ui/ui_packs/'+PlayState.SONG.arrowSkin+"/NOTE_assets.xml");
						  var notePic = BitmapData.fromFile('assets/images/custom_ui/ui_packs/'+PlayState.SONG.arrowSkin+"/NOTE_assets.png");
							frames = FlxAtlasFrames.fromSparrow(notePic, noteXml);
							animation.addByPrefix('green', 'arrowUP');
							animation.addByPrefix('blue', 'arrowDOWN');
							animation.addByPrefix('purple', 'arrowLEFT');
							animation.addByPrefix('red', 'arrowRIGHT');
							if (flippedNotes) {
								animation.addByPrefix('blue', 'arrowUP');
								animation.addByPrefix('green', 'arrowDOWN');
								animation.addByPrefix('red', 'arrowLEFT');
								animation.addByPrefix('purple', 'arrowRIGHT');
							}
							antialiasing = true;
							setGraphicSize(Std.int(width * 0.7));
	
							switch (Math.abs(leData))
							{
								case 2:
									x += Note.swagWidth * 2;
									animation.addByPrefix('static', 'arrowUP');
									animation.addByPrefix('pressed', 'up press', 24, false);
									animation.addByPrefix('confirm', 'up confirm', 24, false);
									if (flippedNotes) {
										animation.addByPrefix('static', 'arrowDOWN');
										animation.addByPrefix('pressed', 'down press', 24, false);
										animation.addByPrefix('confirm', 'down confirm', 24, false);
									}
								case 3:
									x += Note.swagWidth * 3;
									animation.addByPrefix('static', 'arrowRIGHT');
									animation.addByPrefix('pressed', 'right press', 24, false);
									animation.addByPrefix('confirm', 'right confirm', 24, false);
									if (flippedNotes) {
										animation.addByPrefix('static', 'arrowLEFT');
										animation.addByPrefix('pressed', 'left press', 24, false);
										animation.addByPrefix('confirm', 'left confirm', 24, false);
									}
								case 1:
									x += Note.swagWidth * 1;
									animation.addByPrefix('static', 'arrowDOWN');
									animation.addByPrefix('pressed', 'down press', 24, false);
									animation.addByPrefix('confirm', 'down confirm', 24, false);
									if (flippedNotes) {
										animation.addByPrefix('static', 'arrowUP');
										animation.addByPrefix('pressed', 'up press', 24, false);
										animation.addByPrefix('confirm', 'up confirm', 24, false);
									}
								case 0:
									x += Note.swagWidth * 0;
									animation.addByPrefix('static', 'arrowLEFT');
									animation.addByPrefix('pressed', 'left press', 24, false);
									animation.addByPrefix('confirm', 'left confirm', 24, false);
									if (flippedNotes) {
										animation.addByPrefix('static', 'arrowRIGHT');
										animation.addByPrefix('pressed', 'right press', 24, false);
										animation.addByPrefix('confirm', 'right confirm', 24, false);
									}
							}
	
						} else if (FileSystem.exists('assets/images/custom_ui/ui_packs/'+PlayState.SONG.arrowSkin+"/arrows-pixels.png")){
							var notePic = BitmapData.fromFile('assets/images/custom_ui/ui_packs/'+PlayState.SONG.arrowSkin+"/arrows-pixels.png");
							loadGraphic(notePic, true, 17, 17);
							animation.add('green', [6]);
							animation.add('red', [7]);
							animation.add('blue', [5]);
							animation.add('purplel', [4]);
							if (flippedNotes) {
								animation.add('blue', [6]);
								animation.add('purplel', [7]);
								animation.add('green', [5]);
								animation.add('red', [4]);
							}
							setGraphicSize(Std.int(width * PlayState.daPixelZoom));
							updateHitbox();
							antialiasing = false;
	
							switch (Math.abs(leData))
							{
								case 2:
									x += Note.swagWidth * 2;
									animation.add('static', [2]);
									animation.add('pressed', [6, 10], 12, false);
									animation.add('confirm', [14, 18], 12, false);
									if (flippedNotes) {
										animation.add('static', [1]);
										animation.add('pressed', [5, 9], 12, false);
										animation.add('confirm', [13, 17], 12, false);
									}
								case 3:
									x += Note.swagWidth * 3;
									animation.add('static', [3]);
									animation.add('pressed', [7, 11], 12, false);
									animation.add('confirm', [15, 19], 24, false);
									if (flippedNotes) {
										animation.add('static', [0]);
										animation.add('pressed', [4, 8], 12, false);
										animation.add('confirm', [12, 16], 24, false);
									}
								case 1:
									x += Note.swagWidth * 1;
									animation.add('static', [1]);
									animation.add('pressed', [5, 9], 12, false);
									animation.add('confirm', [13, 17], 24, false);
									if (flippedNotes) {
										animation.add('static', [2]);
										animation.add('pressed', [6, 10], 12, false);
										animation.add('confirm', [14, 18], 12, false);
									}
								case 0:
									x += Note.swagWidth * 0;
									animation.add('static', [0]);
									animation.add('pressed', [4, 8], 12, false);
									animation.add('confirm', [12, 16], 24, false);
									if (flippedNotes) {
										animation.add('static', [3]);
										animation.add('pressed', [7, 11], 12, false);
										animation.add('confirm', [15, 19], 24, false);
									}
							}
						} else {
							// no crashing today :)
						//	if (!FlxG.save.data.circleShit)
						//		frames = FlxAtlasFrames.fromSparrow('assets/images/NOTE_assets.png', 'assets/images/NOTE_assets.xml');
						//	else {
						//		frames = FlxAtlasFrames.fromSparrow('assets/images/noteassets/circle/NOTE_assets.png', 'assets/images/noteassets/circle/NOTE_assets.xml');
						//	}
							animation.addByPrefix('green', 'arrowUP');
							animation.addByPrefix('blue', 'arrowDOWN');
							animation.addByPrefix('purple', 'arrowLEFT');
							animation.addByPrefix('red', 'arrowRIGHT');
							if (flippedNotes) {
								animation.addByPrefix('blue', 'arrowUP');
								animation.addByPrefix('green', 'arrowDOWN');
								animation.addByPrefix('red', 'arrowLEFT');
								animation.addByPrefix('purple', 'arrowRIGHT');
							}
							antialiasing = true;
							setGraphicSize(Std.int(width * 0.7));
	
							switch (Math.abs(leData))
							{
								case 2:
									x += Note.swagWidth * 2;
									animation.addByPrefix('static', 'arrowUP');
									animation.addByPrefix('pressed', 'up press', 24, false);
									animation.addByPrefix('confirm', 'up confirm', 24, false);
									if (flippedNotes) {
										animation.addByPrefix('static', 'arrowDOWN');
										animation.addByPrefix('pressed', 'down press', 24, false);
										animation.addByPrefix('confirm', 'down confirm', 24, false);
									}
								case 3:
									x += Note.swagWidth * 3;
									animation.addByPrefix('static', 'arrowRIGHT');
									animation.addByPrefix('pressed', 'right press', 24, false);
									animation.addByPrefix('confirm', 'right confirm', 24, false);
									if (flippedNotes) {
										animation.addByPrefix('static', 'arrowLEFT');
										animation.addByPrefix('pressed', 'left press', 24, false);
										animation.addByPrefix('confirm', 'left confirm', 24, false);
									}
								case 1:
									x += Note.swagWidth * 1;
									animation.addByPrefix('static', 'arrowDOWN');
									animation.addByPrefix('pressed', 'down press', 24, false);
									animation.addByPrefix('confirm', 'down confirm', 24, false);
									if (flippedNotes) {
										animation.addByPrefix('static', 'arrowUP');
										animation.addByPrefix('pressed', 'up press', 24, false);
										animation.addByPrefix('confirm', 'up confirm', 24, false);
									}
								case 0:
									x += Note.swagWidth * 0;
									animation.addByPrefix('static', 'arrowLEFT');
									animation.addByPrefix('pressed', 'left press', 24, false);
									animation.addByPrefix('confirm', 'left confirm', 24, false);
									if (flippedNotes) {
										animation.addByPrefix('static', 'arrowRIGHT');
										animation.addByPrefix('pressed', 'right press', 24, false);
										animation.addByPrefix('confirm', 'right confirm', 24, false);
									}
							}
						}
				}

		updateHitbox();
		scrollFactor.set();
	}

	public function postAddedToGroup() {
		playAnim('static');
		x += Note.swagWidth * noteData;
		x += 50;
		x += ((FlxG.width / 2) * player);
		ID = noteData;
	}

	override function update(elapsed:Float) {
		if(resetAnim > 0) {
			resetAnim -= elapsed;
			if(resetAnim <= 0) {
				playAnim('static');
				resetAnim = 0;
			}
		}
		if(animation.curAnim != null){ //my bad i was upset
			if(animation.curAnim.name == 'confirm' && !PlayState.isPixelStage) {
				centerOrigin();
			}
		}

		super.update(elapsed);
	}

	public function playAnim(anim:String, ?force:Bool = false) {
		animation.play(anim, force);
		centerOffsets();
		centerOrigin();
		if(animation.curAnim == null || animation.curAnim.name == 'static') {
			colorSwap.hue = 0;
			colorSwap.saturation = 0;
			colorSwap.brightness = 0;
		} else {
			colorSwap.hue = ClientPrefs.arrowHSV[noteData % 4][0] / 360;
			colorSwap.saturation = ClientPrefs.arrowHSV[noteData % 4][1] / 100;
			colorSwap.brightness = ClientPrefs.arrowHSV[noteData % 4][2] / 100;

			if(animation.curAnim.name == 'confirm' && !PlayState.isPixelStage) {
				centerOrigin();
			}
		}
	}

	private function generateStaticArrows(player:Int):Void{

	var flippedNotes = false;

			for (i in 0...4)
			{
				// FlxG.log.add(i);
				var babyArrow:FlxSprite = new FlxSprite(0, sY);
	
				switch (PlayState.SONG.arrowSkin)
				{
					case 'pixel':
						babyArrow.loadGraphic('assets/images/weeb/pixelUI/arrows-pixels.png', true, 17, 17);
						babyArrow.animation.add('green', [6]);
						babyArrow.animation.add('red', [7]);
						babyArrow.animation.add('blue', [5]);
						babyArrow.animation.add('purplel', [4]);
						if (flippedNotes) {
							babyArrow.animation.add('blue', [6]);
							babyArrow.animation.add('purplel', [7]);
							babyArrow.animation.add('green', [5]);
							babyArrow.animation.add('red', [4]);
						}
						babyArrow.setGraphicSize(Std.int(width * PlayState.daPixelZoom));
						babyArrow.updateHitbox();
						babyArrow.antialiasing = false;
	
						switch (Math.abs(noteData))
						{
							case 2:
								babyArrow.x += Note.swagWidth * 2;
								babyArrow.animation.add('static', [2]);
								babyArrow.animation.add('pressed', [6, 10], 12, false);
								babyArrow.animation.add('confirm', [14, 18], 12, false);
								if (flippedNotes) {
									babyArrow.animation.add('static', [1]);
									babyArrow.animation.add('pressed', [5, 9], 12, false);
									babyArrow.animation.add('confirm', [13, 17], 12, false);
								}
							case 3:
								babyArrow.x += Note.swagWidth * 3;
								babyArrow.animation.add('static', [3]);
								babyArrow.animation.add('pressed', [7, 11], 12, false);
								babyArrow.animation.add('confirm', [15, 19], 24, false);
								if (flippedNotes) {
									babyArrow.animation.add('static', [0]);
									babyArrow.animation.add('pressed', [4, 8], 12, false);
									babyArrow.animation.add('confirm', [12, 16], 24, false);
								}
							case 1:
								babyArrow.x += Note.swagWidth * 1;
								babyArrow.animation.add('static', [1]);
								babyArrow.animation.add('pressed', [5, 9], 12, false);
								babyArrow.animation.add('confirm', [13, 17], 24, false);
								if (flippedNotes) {
									babyArrow.animation.add('static', [2]);
									babyArrow.animation.add('pressed', [6, 10], 12, false);
									babyArrow.animation.add('confirm', [14, 18], 12, false);
								}
							case 0:
								babyArrow.x += Note.swagWidth * 0;
								babyArrow.animation.add('static', [0]);
								babyArrow.animation.add('pressed', [4, 8], 12, false);
								babyArrow.animation.add('confirm', [12, 16], 24, false);
								if (flippedNotes) {
									babyArrow.animation.add('static', [3]);
									babyArrow.animation.add('pressed', [7, 11], 12, false);
									babyArrow.animation.add('confirm', [15, 19], 24, false);
								}
						}
	
					case 'normal':
					//	if (!FlxG.save.data.circleShit)
							frames = FlxAtlasFrames.fromSparrow('assets/images/NOTE_assets.png', 'assets/images/NOTE_assets.xml');
					//	else {
					//		frames = FlxAtlasFrames.fromSparrow('assets/images/noteassets/circle/NOTE_assets.png', 'assets/images/noteassets/circle/NOTE_assets.xml');
					//	}
		
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');
						if (flippedNotes) {
							babyArrow.animation.addByPrefix('blue', 'arrowUP');
							babyArrow.animation.addByPrefix('green', 'arrowDOWN');
							babyArrow.animation.addByPrefix('red', 'arrowLEFT');
							babyArrow.animation.addByPrefix('purple', 'arrowRIGHT');
						}
						babyArrow.antialiasing = true;
						babyArrow.setGraphicSize(Std.int(width * 0.7));
	
						switch (Math.abs(noteData))
							{
								case 2:
									babyArrow.x += Note.swagWidth * 2;
									babyArrow.animation.addByPrefix('static', 'arrowUP');
									babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
									if (flippedNotes) {
										babyArrow.animation.addByPrefix('static', 'arrowDOWN');
										babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
										babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
									}
								case 3:
									babyArrow.x += Note.swagWidth * 3;
									babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
									babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
									if (flippedNotes) {
										babyArrow.animation.addByPrefix('static', 'arrowLEFT');
										babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
										babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
									}
								case 1:
									babyArrow.x += Note.swagWidth * 1;
									babyArrow.animation.addByPrefix('static', 'arrowDOWN');
									babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
									if (flippedNotes) {
										babyArrow.animation.addByPrefix('static', 'arrowUP');
										babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
										babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
									}
								case 0:
									babyArrow.x += Note.swagWidth * 0;
									babyArrow.animation.addByPrefix('static', 'arrowLEFT');
									babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
									if (flippedNotes) {
										babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
										babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
										babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
									}
							}
					default:
						
						if (FileSystem.exists('assets/images/'+PlayState.SONG.arrowSkin+"/NOTE_assets.xml") && FileSystem.exists('assets/images/'+PlayState.SONG.arrowSkin+"/NOTE_assets.png")) {
	
						  var noteXml = File.getContent('assets/images/'+PlayState.SONG.arrowSkin+"/NOTE_assets.xml");
							var notePic = BitmapData.fromFile('assets/images/'+PlayState.SONG.arrowSkin+"/NOTE_assets.png");
							babyArrow.frames = FlxAtlasFrames.fromSparrow(notePic, noteXml);
							babyArrow.animation.addByPrefix('green', 'arrowUP');
							babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
							babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
							babyArrow.animation.addByPrefix('red', 'arrowRIGHT');
							if (flippedNotes) {
								babyArrow.animation.addByPrefix('blue', 'arrowUP');
								babyArrow.animation.addByPrefix('green', 'arrowDOWN');
								babyArrow.animation.addByPrefix('red', 'arrowLEFT');
								babyArrow.animation.addByPrefix('purple', 'arrowRIGHT');
							}
							babyArrow.antialiasing = true;
							babyArrow.setGraphicSize(Std.int(width * 0.7));
	
							switch (Math.abs(noteData))
							{
								case 2:
									babyArrow.x += Note.swagWidth * 2;
									babyArrow.animation.addByPrefix('static', 'arrowUP');
									babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
									if (flippedNotes) {
										babyArrow.animation.addByPrefix('static', 'arrowDOWN');
										babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
										babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
									}
								case 3:
									babyArrow.x += Note.swagWidth * 3;
									babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
									babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
									if (flippedNotes) {
										babyArrow.animation.addByPrefix('static', 'arrowLEFT');
										babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
										babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
									}
								case 1:
									babyArrow.x += Note.swagWidth * 1;
									babyArrow.animation.addByPrefix('static', 'arrowDOWN');
									babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
									if (flippedNotes) {
										babyArrow.animation.addByPrefix('static', 'arrowUP');
										babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
										babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
									}
								case 0:
									babyArrow.x += Note.swagWidth * 0;
									babyArrow.animation.addByPrefix('static', 'arrowLEFT');
									babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
									if (flippedNotes) {
										babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
										babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
										babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
									}
							}
	
						} else if (FileSystem.exists('assets/images/'+PlayState.SONG.arrowSkin+"/arrows-pixels.png")){
							var notePic = BitmapData.fromFile('assets/images/'+PlayState.SONG.arrowSkin+"/arrows-pixels.png");
							babyArrow.loadGraphic(notePic, true, 17, 17);
							babyArrow.animation.add('green', [6]);
							babyArrow.animation.add('red', [7]);
							babyArrow.animation.add('blue', [5]);
							babyArrow.animation.add('purplel', [4]);
							if (flippedNotes) {
								babyArrow.animation.add('blue', [6]);
								babyArrow.animation.add('purplel', [7]);
								babyArrow.animation.add('green', [5]);
								babyArrow.animation.add('red', [4]);
							}
							babyArrow.setGraphicSize(Std.int(width * PlayState.daPixelZoom));
							babyArrow.updateHitbox();
							babyArrow.antialiasing = false;
	
							switch (Math.abs(noteData))
							{
								case 2:
									babyArrow.x += Note.swagWidth * 2;
									babyArrow.animation.addByPrefix('static', 'arrowUP');
									babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
									if (flippedNotes) {
										babyArrow.animation.addByPrefix('static', 'arrowDOWN');
										babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
										babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
									}
								case 3:
									babyArrow.x += Note.swagWidth * 3;
									babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
									babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
									if (flippedNotes) {
										babyArrow.animation.addByPrefix('static', 'arrowLEFT');
										babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
										babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
									}
								case 1:
									babyArrow.x += Note.swagWidth * 1;
									babyArrow.animation.addByPrefix('static', 'arrowDOWN');
									babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
									if (flippedNotes) {
										babyArrow.animation.addByPrefix('static', 'arrowUP');
										babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
										babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
									}
								case 0:
									babyArrow.x += Note.swagWidth * 0;
									babyArrow.animation.addByPrefix('static', 'arrowLEFT');
									babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
									if (flippedNotes) {
										babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
										babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
										babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
									}
							}
						} else {
							// no crashing today :)
						//	if (!FlxG.save.data.circleShit)
								frames = FlxAtlasFrames.fromSparrow('assets/images/NOTE_assets.png', 'assets/images/NOTE_assets.xml');
						//	else {
						//		frames = FlxAtlasFrames.fromSparrow('assets/images/noteassets/circle/NOTE_assets.png', 'assets/images/noteassets/circle/NOTE_assets.xml');
						//	}
						babyArrow.animation.addByPrefix('green', 'arrowUP');
							babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
							babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
							babyArrow.animation.addByPrefix('red', 'arrowRIGHT');
							if (flippedNotes) {
								babyArrow.animation.addByPrefix('blue', 'arrowUP');
								babyArrow.animation.addByPrefix('green', 'arrowDOWN');
								babyArrow.animation.addByPrefix('red', 'arrowLEFT');
								babyArrow.animation.addByPrefix('purple', 'arrowRIGHT');
							}
							babyArrow.antialiasing = true;
							babyArrow.setGraphicSize(Std.int(width * 0.7));
	
							switch (Math.abs(noteData))
							{
								case 2:
									babyArrow.x += Note.swagWidth * 2;
									babyArrow.animation.addByPrefix('static', 'arrowUP');
									babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
									if (flippedNotes) {
										babyArrow.animation.addByPrefix('static', 'arrowDOWN');
										babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
										babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
									}
								case 3:
									babyArrow.x += Note.swagWidth * 3;
									babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
									babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
									if (flippedNotes) {
										babyArrow.animation.addByPrefix('static', 'arrowLEFT');
										babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
										babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
									}
								case 1:
									babyArrow.x += Note.swagWidth * 1;
									babyArrow.animation.addByPrefix('static', 'arrowDOWN');
									babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
									if (flippedNotes) {
										babyArrow.animation.addByPrefix('static', 'arrowUP');
										babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
										babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
									}
								case 0:
									babyArrow.x += Note.swagWidth * 0;
									babyArrow.animation.addByPrefix('static', 'arrowLEFT');
									babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
									if (flippedNotes) {
										babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
										babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
										babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
									}
							}
						}
				}
	
				babyArrow.updateHitbox();
				babyArrow.scrollFactor.set();
	
				babyArrow.ID = i;
	
				babyArrow.animation.play('static');
				babyArrow.x += 50;
				babyArrow.x += ((FlxG.width / 2) * player);
			}
		}
}
