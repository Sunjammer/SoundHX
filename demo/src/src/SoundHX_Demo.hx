package;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.Lib;
import haxe.Timer;
import treefortress.sound.SoundHX;


class SoundHX_Demo extends Sprite
{
	public static function main():Void {
		Lib.current.addChild(new SoundHX_Demo());
	}
	
	public function new(){
		super();
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}
	
	private function onAddedToStage(e:Event):Void 
	{
		removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		SoundHX.initialize();
		
		SoundHX.loadSound("Click.mp3", "click");
		SoundHX.loadSound("Music.mp3", "music");
		
		SoundHX.playLoop("music");
		/*
		//Test Pause / Resume
		Timer.delay(function(){
			SoundHX.pauseAll();
			Timer.delay(function(){
				SoundHX.resumeAll();
			}, 2000);
		}, 2000);
		*/
		//Test Fade
		
		Timer.delay(function(){
			SoundHX.fadeTo("music", 0);
			//SoundHX.fadeAllTo(0);
			Timer.delay(function(){
				//SoundHX.fadeAllFrom(1, 0);
				SoundHX.fadeFrom("music", 0, 1);
			}, 2000);
		}, 2000);
		
		
		stage.addEventListener(MouseEvent.CLICK, function(e:Event){
			//SoundHX.playLoop("click", SoundHX.getSound("click").volume);
			SoundHX.play("click", 1, 0, -1, true, true);
		});
	}
}