//Week 1: Pixels and Colour
Directory contents
Code sample for the gradient is in examples/gradient
Week 1 Task
Experiment with the code in examples/gradient

Imagine you're desingning branding for a computational art gallery.
Find a colour palette of 3-5 colours. It can be taken from a photo, colour palette app, or from your Block 1 sketch from the class on Colour Interactions.
Create a gradient that would work well with the colour palette that could be used as a background for posters, website animation, etc.
Try slightly tweaking the colours.
Can you change the gradient direction?
Can you make a circular gradient centred on the middle of the screen?
For the portfolio, submit at least 5 gradient variations. Include notes about your design and learning process, and how you'd develop it further.

// REFLECTION

For Week 1, my goal was to learn how to generate visual effects in Processing by moving from simple drawing primitives to direct pixel control. I started with a basic horizontal gradient in `gradient_1.pde`, then created more complex versions using `gradient_02.pde`, `gradient_03/gradient_03.pde`, `gradient_04/gradient_04.pde`, and `gradient_05/gradient_05.pde`. Each version explored a different structure—linear, radial, non-linear, and diagonal—while I normalized screen coordinates into fractional values and mapped them into separate RGB channels.

The steps I took were: first, understand how x/y positions become color values; second, write loops that traverse the screen and compute color from coordinates; third, experiment with color blending and channel separation; and fourth, compare the different gradient styles to see how they change the mood of the image. This helped me learn that precise coordinate math gives fine-grained control over color harmony, that efficient loops are essential for generative visuals, and that simple math can produce dynamic, atmospheric graphics.

