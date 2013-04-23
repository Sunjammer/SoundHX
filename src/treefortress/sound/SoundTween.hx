package treefortress.sound;
import flash.Lib;
	
class SoundTween {
	
	public var startTime:Int;
	public var startVolume:Float;
	public var endVolume:Float;
	public var duration:Float;
	public var sound:SoundInstance;
	
	public function new(si:SoundInstance, endVolume:Float, duration:Float) {
		sound = si;
		startTime = Lib.getTimer();
		startVolume = si.volume;
		this.endVolume = endVolume;
		this.duration = duration;
	}
	
	public function update():Bool {
		sound.volume = easeOutQuad(Lib.getTimer() - startTime, startVolume, endVolume - startVolume, duration);
		if(Lib.getTimer() - startTime >= duration){
			sound.volume = endVolume;
		}
		return sound.volume == endVolume;
	}
	
	/**
	 * Equations from the man Robert Penner, see here for more:
	 * http://www.dzone.com/snippets/robert-penner-easing-equations
	 */
	static function easeOutQuad(position:Float, startValue:Float, change:Float, duration:Float):Float {
		return -change *(position/=duration)*(position-2) + startValue;
	}
	
	static function easeInOutQuad(position:Float, startValue:Float, change:Float, duration:Float):Float {
		if ((position/=duration/2) < 1){
			return change/2*position*position + startValue;
		}
		return -change/2 * ((--position)*(position-2) - 1) + startValue;
	}
}