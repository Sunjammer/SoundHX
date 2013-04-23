package treefortress.sound;
import com.furusystems.events.Signal;
import flash.errors.Error;
import flash.events.Event;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;

class SoundInstance {
	
	
	/**
	 * Registered type for this Sound
	 */
	public var type:String;
	
	/**
	 * URL this sound was loaded from. This is null if the sound was not loaded externally.
	 */
	public var url:String;
	
	/**
	 * Current instance of Sound object
	 */
	public var sound:Sound;
	
	/**
	 * Current playback channel
	 */
	public var channel:SoundChannel;
	
	/**
	 * Dispatched when playback has completed
	 */
	public var soundCompleted:Signal<SoundInstance>;
	
	/**
	 * Float of times to loop this sound. Pass -1 to loop forever.
	 */
	public var loops:Int;
	
	/**
	 * Allow multiple concurrent instances of this Sound. If false, only one instance of this sound will ever play.
	 */
	public var allowMultiple:Bool;
	
	var soundTransform:SoundTransform;
	var _muted:Bool;
	var _volume:Float;
	var pauseTime:Float;
	var _position:Int;
	
	public function new(sound:Sound = null){
		pauseTime = 0;
		_volume = 1;
		
		this.sound = sound;
		
		soundCompleted = new Signal<SoundInstance>();
		soundTransform = new SoundTransform();
	}
	
	/**
	 * Play this Sound 
	 * @param volume
	 * @param startTime Start position in milliseconds
	 * @param loops Float of times to loop Sound. Pass -1 to loop forever.
	 * @param allowMultiple Allow multiple concurrent instances of this Sound
	 */
	public function play(volume:Float = 1, startTime:Float = -1, loops:Int = 0, allowMultiple:Bool = true):SoundInstance {
		
		this.loops = loops;
		this.allowMultiple = allowMultiple;
		
		if(allowMultiple){
			channel = sound.play(startTime, loops);
		} else {
			if(channel != null){ 
				pauseTime = channel.position;
				stopChannel(channel);
			}
			channel = sound.play(startTime, loops == -1? 0 : loops);
		}
		channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
		this.volume = volume;	
		this.mute = mute;
		return this;
	}
	
	/**
	 * Pause currently playing sound. Use resume() to continue playback.
	 */
	public function pause():SoundInstance {
		if(channel == null){ return this; }
		pauseTime = channel.position;
		channel.stop();
		return this;
	}

	
	/**
	 * Resume from previously paused time, or start over if it's not playing.
	 */
	public function resume():SoundInstance {
		play(volume, pauseTime, loops, allowMultiple);
		return this;
	}
	
	/**
	 * Stop the currently playing sound and set it's position to 0
	 */
	public function stop():SoundInstance {
		pauseTime = 0;
		channel.stop();
		return this;
	}
	
	/**
	 * Mute current sound.
	 */
	public var mute(default, set_mute):Bool;
	public function set_mute(value:Bool):Bool {
		mute = value;
		if(channel != null){
			channel.soundTransform = mute? new SoundTransform(0) : soundTransform;
		}
		return mute;
	}
	
	/**
	 * Fade using the current volume as the Start Volume
	 */
	public function fadeTo(endVolume:Float, duration:Float = 1000):SoundInstance {
		SoundHX.addTween(type, -1, endVolume, duration);
		return this;
	}
	
	/**
	 * Fade and specify both the Start Volume and End Volume.
	 */
	public function fadeFrom(startVolume:Float, endVolume:Float, duration:Float = 1000):SoundInstance {
		SoundHX.addTween(type, startVolume, endVolume, duration);
		return this;
	}
	
	/**
	 * Indicates whether this sound is currently playing.
	 */
	public var isPlaying(get_isPlaying, null):Bool;
	public function get_isPlaying():Bool {
		return (channel!=null && channel.position > 0);
	}
	
	/**
	 * Set position of sound in milliseconds
	 */
	public var position(get_position, set_position):Float;
	public function get_position():Float { return channel!=null? channel.position : 0; }
	public function set_position(value:Float):Float {
		if(channel!=null){ 
			stopChannel(channel);
		}
		channel = sound.play(value, loops);
		return value;
	}
	

	/**
	 * Adjust volume for this sound. You can call this while muted to change volume, and it will not break the mute.
	 */
	public var volume(default, set_volume):Float;
	public function set_volume(value:Float):Float {
		volume = value;
		if (_muted) { return volume; }
		
		if(value < 0){ value = 0; } else if(value > 1){ value = 1; }
		if(soundTransform==null){ soundTransform = new SoundTransform(); }
		soundTransform.volume = value;
		if(channel!=null){
			channel.soundTransform = soundTransform;
		}
		return volume;
	}
	
	/**
	 * Create a duplicate of this SoundInstance
	 */
	public function clone():SoundInstance {
		var si:SoundInstance = new SoundInstance(sound);
		return si;
	}

	
	/**
	 * Dispatched when Sound has finished playback
	 */
	function onSoundComplete(event:Event):Void {
		soundCompleted.dispatch(this);
		if(loops == -1 && cast(event.target, SoundChannel) == channel){
			play(_volume, 0, -1, allowMultiple);
		}
	}
	
	/**
	 * Unload sound from memory.
	 */
	public function destroy():Void {
		soundCompleted.removeAll();
		try {
			sound.close();
		} catch (e:Error) { };
		sound = null;
		channel = null;
		soundTransform = null;
	}
	
	function stopChannel(channel:SoundChannel):Void {
		channel.stop(); 
		channel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
	}		
	
}