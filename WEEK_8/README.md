// Week 8: Algorithmic music and sampling

Directory contents
 
code examples

// Week 8 Task

Using at least 4 samples, create a drum pattern. Make the pattern change in time. You could do that by:     - adding an element of randomness to at least one of the samples,     - alternate the pattern depending on time, e.g. count bars based on frameCount, seconds or milliseconds

How to start (optional prompts):

Pick some samples from the resources below (or find or record your own), and modify the example from class using them.
Pick a drum pattern or a beat from a song from the examples below (or your own example), and try to replicate it. If you're a beginner, replicating one of these would be a good start: Essential drum patterns (for hip hop).
Design your own beat using clapping, visuals, or however you like, and try to replicate it.

(Optional). Can you add an audio-reactive visualisation? For this, you may want to increase the frameRate to achieve a smooth animation. For example, if you want the music to play at 120 bpm, which is 2 times per second, set the frameRate to 60 and play the base sound every 30th frame (frameCount % 30 == 0). (Advanced). Can you combine sound synthesised with an oscillator (task from last week) with looped samples in a single piece of music?

** Have a look at the additional resources on Moodle ** (articles, free sample sources, technical documentation)

For Week 8, my goal was to learn how to use sound in Processing and make the sketch respond to audio. I loaded several WAV samples into the sketch, then built playback controls so I could trigger different sounds. After that, I used the sound data to influence the visuals, letting the audio shape the sketch’s movement and timing. This helped me learn how to combine sound and drawing in Processing, and how interaction changes when audio becomes part of the experience.