# Dino Run — Meteor Dodge

**A University Project using Lua & Solar2D**

---

## 🏫 About This Project

This game was developed as a **final project for a college course**. The main goal was to demonstrate proficiency in game development using scripting languages, modular programming, and practical application of game design concepts.

---

## 🎮 Game Synopsis

**Dino Run** is an endless runner arcade game where you control a dinosaur that must **dodge falling meteors** for as long as possible. The only moves are to dash forward by holding the screen to avoid obstacles. The game progressively increases in difficulty, challenging your reflexes and timing!

* **Survive as long as you can.**
* **Pick up shields to survive meteor collisions.**
* **Compete for the highest score and beat your own records!**

---

## 🧩 Technologies Used

* **Lua** — Scripting language for all gameplay and logic
* **Solar2D (formerly Corona SDK)** — 2D game engine for rapid development and deployment to multiple platforms
* **Graphics** — Custom animated sprite sheets (meteors, dinosaur, power-ups) in PNG format
* **Audio** — MP3 sound effects and background music

---

## 🕹️ How to Play

* **Move Forward:** Hold anywhere on the screen
* **Move Back:** Release the screen
* **Avoid Meteors:** If you collide, the game is over—unless you have a shield!
* **Pick Up Shields:** Catch falling shields to gain temporary protection
* **Pause/Resume/Mute:** Control buttons available in all scenes

---

## ⚙️ Project Methodology

1. **Requirements Gathering:**
   Defined the core mechanics: endless survival, single-move control, progressively harder gameplay.

2. **Prototyping:**
   Rapid prototyping in Lua using Solar2D, with immediate feedback through the simulator.

3. **Modular Architecture:**
   All major features (player, meteors, shields, timers, UI, mute) were implemented as separate Lua modules for maintainability.

4. **Progression & Balancing:**
   Difficulty increases over time by accelerating meteor speed and spawn rate, tested through iterative play and peer feedback.

5. **Visual & Audio Design:**
   Custom animated sprites, background art, and original sound effects for a fun and engaging atmosphere.

6. **Testing & Debugging:**
   Utilized Solar2D Simulator for cross-platform testing and iterative bug fixing. Special developer flags (devmode) enabled quick testing of power-ups and game behaviors.

7. **Documentation & Submission:**
   All assets, code, and this README organized for clarity and academic review.

---

## 📁 Folder Structure

```
assets/
  audios/         # Background music & SFX
  buttons/        # UI button sprites
  sprites/        # Animated sprites (dino, meteor, shield, etc.)
modules/
  dino.lua        # Player logic
  fireball.lua    # Meteor logic
  shield.lua      # Shield power-up logic
  timers.lua      # Centralized timer management
  muteButton.lua  # Global mute/unmute button
  devmode.lua     # Developer/test flags
scenes/
  game.lua        # Main game loop
  menu.lua        # Main menu
  gameover.lua    # Game over / high score
  rate.lua        # High score / ranking
main.lua
env.lua           # Config variables
```

---

## 🏆 Project Highlights

* **Custom, visually clear meteor hitboxes for fairer gameplay**
* **Global mute button and modular UI**
* **Centralized, robust timer system**
* **Dev mode with shortcuts for rapid testing**

---

## 📦 Install & Run

See detailed instructions in [INSTALL.md](./INSTALL.md).