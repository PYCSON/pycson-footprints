# V430ON LIVE UI Button Entry Patch Diff Summary

Added one readonly button in the existing V307B crosslink navigation area:

- id: pycson-v430on-steam-mature-loop-entry
- label: STEAM MATURE LOOP
- onclick: pycsonV430ONFocusSteamMatureLoop()

Added a small style/script block bounded by:

- PYCSON_V430ON_STEAM_MATURE_LOOP_BUTTON_ENTRY : BEGIN
- PYCSON_V430ON_STEAM_MATURE_LOOP_BUTTON_ENTRY : END

The script only locates the existing pycson-v430oi-steam-mature-loop-readonly module, calls scrollIntoView, applies a temporary highlight class, then removes it. It does not fetch data, calculate EV, write DATA_BRIDGE, write active payload, or trade.
