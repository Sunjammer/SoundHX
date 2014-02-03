[license]: https://github.com/treefortress/SoundAS/raw/master/license.txt

SoundHX
=======

A modern lightweight sound manager for the Haxe Flash target, ported from AS3 by Furu Systems. 

The goal of SoundHX is to simplifying playback of your audio files, with a focus on easily transitioning from one to another, and differentiating between SoundFX and Music Loops.

#Features
* Clean modern API
* Easy memory management
* API Chaining: SoundHX.play("music").fadeTo(0);
* Built-in Tweening system, no dependancies

#API Overview

Full documentation can be found here: http://treefortress.com/libs/SoundAS/docs/.

###SoundHX
This Static Class is the main interface for the library. It's responsible for loading and controlling all sounds globally.
Before you can use SoundHX, it needs to be set up with a call to initialize();

Initialization:

*    **initialize**():Void

Loading / Unloading: 

*    **addSound**(type:String, sound:Sound):Void
*    **loadSound**(url:String, type:String, buffer:Int = 100):Void
*    **removeSound**(type:String):Void
*    **removeAll**():Void

Playback:

*    **getSound**(type:String, forceNew:Bool = false):SoundInstance
*    **play**(type:String, volume:Float = 1, startTime:Float = -1, loops:Int = 0, allowMultiple:Bool = false, allowInterrupt:Bool = true):SoundInstance
*    **playFx**(type:String, volume:Float = 1, startTime:Float = -1, loops:Int = 0):SoundInstance
*    **playLoop**(type:String, volume:Float = 1, startTime:Float = -1):SoundInstance
*    **resume**(type:String, volume:Float = 1, startTime:Float = -1, loops:Int = 0):SoundInstance
*    **resumeAll**():Void
*    **pause**(type:String):SoundInstance
*    **pauseAll**():Void
*    **stop**(type:String):SoundInstance
*    **stopAll()**:Void
*    **set masterVolume**(value:Float):Void
*    **fadeFrom**(type:String, startVolume:Float = 0, endVolume:Float = 1, duration:Float = 1000)    
*    **fadeAllFrom**(startVolume:Float = 0, endVolume:Float = 1, duration:Float = 1000)
*    **fadeMasterFrom**(startVolume:Float = 0, endVolume:Float = 1, duration:Float = 1000)    
*    **fadeTo**(type:String, endVolume:Float = 1, duration:Float = 1000):SoundInstance
*    **fadeAllTo**(endVolume:Float = 1, duration:Float = 1000):SoundInstance
*    **fadeMasterTo**(endVolume:Float = 1, duration:Float = 1000)  
*    **getSoundBytes**(type:String):ByteArray

####SoundInstance
Controls playback of individual sounds, allowing you to easily stop, start, resume and set volume or position.

*     **play**(volume:Float = 1, startTime:Float = -1, loops:Int = 0, allowMultiple:Bool = true):SoundInstance
*     **pause**():SoundInstance
*     **resume**():SoundInstance
*     **stop**():SoundInstance
*     **set volume**(value:Float):Void
*     **set mute**(value:Bool):Void
*     **fadeFrom**(startVolume:Float, endVolume:Float, duration:Float = 1000):SoundInstance
*     **fadeTo**(endVolume:Float, duration:Float = 1000):SoundInstance
*     **destroy**():Void
*     **endFade**(applyEndVolume:Bool = false):SoundInstance
*     **getBytes**():ByteArray



#Code Examples

###Loading

    //Load sound from an external file
    SoundHX.loadSound("assets/Click.mp3", "click");

    //Inject an already loaded Sound instance
    SoundHX.addSound(clickSound, "click");

###Basic Playback

    //Play sound.
        //allowMultiple: Allow multiple overlapping sound instances.
        //allowInterrupt: If this sound is currently playing, start it over.
    SoundHX.play("click", volume, startTime, loops, allowMultiple, allowInterrupt);

    //Shortcut for typical game fx (no looping, allows for multiple instances)
    SoundHX.playFx("click");

    //Shortcut for typical game music (loops forever, no multiple instances)
    SoundHX.playLoop("click");

    //Toggle Mute 
    SoundHX.mute = !SoundHX.mute;

    //Fade Out
    SoundHX.getSound("click").fadeTo(0);

###Advanced 

    //Mute one sound
    SoundHX.getSound("click").mute = true;

    //Fade from .3 to .7 over 3 seconds
    SoundHX.getSound("click").fadeFrom(.3, .7, 3000);

	//Manage a SoundInstance directly
    var sound:SoundInstance = SoundHX.getSound("click");
    sound.play(volume);
    sound.position = 500; //Set position of sound in milliseconds
    sound.volume = .5; 
	sound.fadeTo(0);

---
### License
[WTFPL][license]

