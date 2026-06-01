For the advanced task, my goal was to create a more complete game sketch with better structure and additional mechanics than the Week 9 `game.pde`. I started by defining a stronger game concept, then expanded the base game logic with multiple characters, falling targets, physics forces, and score/life systems. I also improved the visual presentation with smoother motion, layered interactions, and a clear game over flow.

Compared to `game.pde`, the advanced sketch adds:
- multiple moving characters instead of a single player,
- falling target objects to collect,
- gravity and force-based movement,
- collision detection with score and lives,
- restart behavior when the game ends.

The step-by-step changes were:
1. Copied the original `game.pde` structure as a starting point.
2. Added two zombie objects with separate mass, size, and color so the game had more dynamic actors.
3. Created falling brain objects that the zombies collect, introducing a new target mechanic.
4. Added gravity and mouse/keyboard force controls to make movement feel more physics-driven.
5. Implemented collision checking between zombies and brains with score increase and reset.
6. Added lives and game-over logic so the sketch had a full play loop.
7. Built UI functions to display score, lives, and a restart instruction.

This helped me learn how to scale a simple sketch into a fuller game by adding more object types, managing game state, and making interactivity feel more complete.