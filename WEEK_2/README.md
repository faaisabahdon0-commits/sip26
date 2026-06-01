// Week 2: Manipulating and Analysing Pixels
Directory contents
Code sample for the colorswap, histogram and video examples are in examples/

Week 2 Portfolio Task, part 1.

Open the histogram sketch. It's a script which converts a photo into black and white, and shows a histogram of brightness. Working in pairs - as a Driver and Navigator - try to adapt the code so that it shows the image in its original colour, and then show three histograms: one for each of the R, G, B channels.
Try it with a different image of your choice.
Advanced: Make a copy of the sketch, swap colour channels, and display histograms for those.

Week 2 Portfolio Task, part 2.
Have a look at this blog post on glitch art made by pixel sorting: https://glitchology.com/pixel-sorting/
Make your own piece of glitch art and document it in your portfolio. You're encouraged to experiment with multiple versions and approaches.
You're welcome to use the code from the post as a starter, but please pick a different rule for sorting pixels.

For Week 2, my goal was to move from abstract gradients to real image processing and pixel manipulation in Processing. I began by loading `data/beyonce_cover.jpeg` and inspecting its pixels, then I built a histogram to measure red, green, and blue values across the image. From there, I wrote nested loops to scan the pixel array and identify areas of red and blue dominance.

The steps I took were: first, load the image and call `loadPixels()` so I could access the pixel data directly; second, create arrays to count color channel frequencies and understand the image’s data distribution; third, implement pixel sorting by brightness and saturation for selected segments; fourth, add glitch bands by shifting horizontal rows and applying chromatic offsets; and finally, combine those effects into a single sketch that felt both algorithmic and visually disruptive. This helped me learn how to work with `pixels[]`, how to structure multiple per-pixel operations cleanly, and how image processing blends technical analysis with creative distortion.
