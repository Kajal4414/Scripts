# Linux

-   Icons Directory: `/usr/share/applications` and `/home/sakshi/.local/share/applications`

    -   `/usr/share/applications` Available to all users on the system ( system-wide ).
    -   `/home/sakshi/.local/share/applications` Only available to the user who created them ( user-specific ).
 
---
 **Here are the steps to install the Tokyo Night GTK Theme on Linux Mint Cinnamon:**

**1. Download the theme:**

- Visit the GitHub repository: [https://github.com/Fausto-Korpsvart/Tokyo-Night-GTK-Theme](https://github.com/Fausto-Korpsvart/Tokyo-Night-GTK-Theme)
- Click the green "Code" button and select "Download ZIP".
- Extract the downloaded ZIP file to a convenient location, like your Downloads folder.

**2. Move the theme files:**

- Open a terminal window (Ctrl+Alt+T).
- Use the `mv` command to relocate the extracted theme files to the appropriate directory:

```bash
mv ~/Downloads/Tokyo-Night-GTK-Theme-master/themes/* .themes/
mv ~/Downloads/Tokyo-Night-GTK-Theme-master/icons/* .local/share/icons/
```

**3. Apply the theme:**

- Open the System Settings application.
- Go to Appearance > Themes.
- Under "Window borders," select "Tokyo Night."
- Optionally, you can also apply a matching icon theme and a GTK+ 2.0 theme for legacy applications.

**4. (Optional) Install a matching icon theme:**

- If you wish to use a matching icon theme, you can download one from websites like Gnome-Look.org and install it by placing the icons in `/usr/share/icons`.
- If you wish to use a matching terminal theme.

```bash
bash -c "$(wget -qO- https://git.io/vQgMr)"
```
- Enter `230` Tokyo Night, and restart the terminal.

**5. (Optional) Install a GTK+ 2.0 theme:**

- Some older applications might still use GTK+ 2.0. If you want to apply the theme to them as well, you can download a matching GTK+ 2.0 theme and place it in `/usr/share/themes`.

**6. Enjoy the new theme!**

- Once you've applied the themes, your desktop environment and applications should reflect the Tokyo Night theme's colors and styling.

**Additional notes:**

- **Compatibility:** Remember that GTK 4 themes might have some limitations in Cinnamon, especially with libadwaita applications.
- **Customization:** You can experiment with different color variants of the theme by editing the `gtk.css` file located in `/usr/share/themes/Tokyo Night/gtk-3.0/`.
- **Updates:** Keep an eye on the theme's GitHub repository for any updates or compatibility improvements.

---

**Adjust the spacing of the panel launchers in the Cinnamon desktop environment.**
- Navigate to `/usr/share/themes/THEME_NAME/cinnamon/cinnamon.css` where THEME_NAME is the name of your current theme.

**OR**

- Navigate to `~/.themes/THEME_NAME/cinnamon/cinnamon.css`.
- Look for sections in the CSS file that pertain to the taskbar or panel, such as `.panel-launcher`.
- For example, if you want to increase the spacing between launchers to 4 pixels, you would change.

`.panel-launcher { padding: 2px; }` to `.panel-launcher { padding: 4px; }`.
