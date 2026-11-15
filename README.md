# godot-ci
This project is based on https://github.com/abarichello/godot-ci

Docker image to export Godot Engine games, primarily made on [Thunder Engine](https://github.com/Thunder-Engine-Dev/thunder-engine), using GitHub Actions.

It is using a custom Godot v4.7.x fork with patches applied: https://github.com/Thunder-Engine-Dev/godot-thunder

## Docker Hub
https://hub.docker.com/r/jue13/godot-ci/

## How To Use

`.github/workflows/godot-ci.yml` is included in this project as reference.
<br>Builds are uploaded as artifacts, which you can find in the summary of an action run in GitHub (at the bottom of the page).

Thunder Engine supports Debug Mode, and an option for it is included here. It does nothing unless the build is launched with `-- --developer-commands` (which Debug Mode `.bat`/`.sh` launchers do), enabling free Console usage in the build.

Builds are triggered automatically on each push in Debug Mode.
<br>You can also trigger the build manually with or without debug mode by going to `Actions` tab in GitHub, selecting the workflow (`godot-ci export`), and clicking `Run Workflow`.

For live projects, examples and tutorials using this template check the list below:<br>

- [Video tutorial by Kyle Luce](https://www.youtube.com/watch?v=wbc1qut0vT4)
- [Video tutorial series by David Snopek](https://www.youtube.com/watch?v=4oUs4IV_Mj4&list=PLCBLMvLIundAOAiCvluBNuEA0-ea7_EDp)
- Repository examples: [test-project](https://github.com/aBARICHELLO/godot-ci/tree/master/test-project) | [game-off](https://gitlab.com/BARICHELLO/game-off).

## Environment configuration

In `.github/workflows/godot-ci.yml` under `env`, replace `test-project` in `PROJECT_NAME` with your actual name and in `PROJECT_PATH` with `.` (or your actual project path, if it is located in a subdirectory).

Update `GODOT_VERSION` and `image: jue13/godot-ci:...` each time a new version of our Godot fork comes out.

## Platforms

Windows and Linux for x86-64 processors are supported. Other platforms are not included.

## Troubleshoot

#### Problems while exporting

- **Check that the export presets file (`export_presets.cfg`) is committed to version control.** In other words, `export_presets.cfg` must *not* be in `.gitignore`.
  - Make sure you don't accidentally commit Android release keystore or Windows codesigning credentials. These credentials cannot be revoked if they are leaked!
- Check that the export names on `export_presets.cfg` match the ones used in your CI script **(case-sensitive)**. Export preset names that contain spaces must be written within quotes (single or double).
- Check the paths used in your CI script. Some commands may be running in the wrong place if you are keeping the project in a folder (like the `test-project` template) or not.

