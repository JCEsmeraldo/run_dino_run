## 🚀 Install & Run Instructions

### 1. **Requirements**

* [**Solar2D (Corona SDK)**](https://solar2d.com/downloads/) — Download and install the latest version for your operating system (Windows or macOS).
* **IntelliJ IDEA** (optional, or any Lua-supporting code editor)
* **Git** (optional, for cloning if your code is hosted in a repo)

---

### 2. **Download or Clone the Project**

* **Clone using Git:**

  ```sh
  git clone https://github.com/JCEsmeraldo/run_dino_run.git
  ```
* **Or download the ZIP** and extract it to your workspace.

---

### 3. **Project Structure**

Make sure your folder contains:

```
main.lua
env.lua
assets/
modules/
scenes/
...
```

---

### 4. **Running the Game in the Solar2D Simulator**

1. **Open Solar2D Simulator**.
2. Go to **File > Open...** and select the folder containing your `main.lua`.
3. The game will start automatically in the simulator.

---

### 5. **Editing and Testing**

* Open the project folder in **IntelliJ IDEA** or your favorite code editor.
* Edit `.lua` files as needed.
* **Every time you save changes**, just **reload** the Solar2D Simulator window to see updates instantly.

---

### 6. **Running on Device (Optional/Advanced)**

* **iOS:** You must be enrolled in the [Apple Developer Program](https://developer.apple.com/programs/) to deploy to a real device. In Solar2D Simulator, use **Build > iOS** and follow the instructions.
* **Android:** Install [Android Studio](https://developer.android.com/studio), set up an emulator or connect a real device, then use **Build > Android APK** in Solar2D.

*For both platforms, you can transfer the built app to your device for testing.*

---

### 7. **Troubleshooting**

* If assets are missing, check that all folders (especially `assets/`) are correctly named and present.
* Check the **Solar2D console output** for any error messages.

---

## 💡 Tips

* **For development:** Use the “Developer Mode” flags to test power-ups, skip menus, or enable debug visuals.
* **Mute button:** Works in all screens, in real time, for easy testing.

---

If you need further help or want to package the game for distribution, see [Solar2D Documentation](https://docs.coronalabs.com/).
