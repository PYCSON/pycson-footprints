# V430OX LIVE UI First Prototype User Acceptance Checklist

This package prepares the user acceptance check for the first usable LIVE UI prototype. It is preparation and review only; it does not patch LIVE UI, modify mother UI, write DATA_BRIDGE, write active payload, calculate EV, fetch Steam/BUFF, or create buy/trade actions.

## Acceptance Checks

- [ ] LIVE UI loads without a white screen.
- [ ] STEAM MATURE LOOP button is visible.
- [ ] Clicking STEAM MATURE LOOP scrolls to or highlights the existing Steam Mature Loop readonly module.
- [ ] Steam Mature Loop readonly module displays final target pool = 7.
- [ ] Steam Mature Loop readonly module displays excluded failed targets = 5.
- [ ] Runner policy is visible: public readonly, low-rate, cache-only, stop rules.
- [ ] Screening / handoff / feed status is visible.
- [ ] Boundary warnings are visible: no DATA_BRIDGE, no active payload, no BUY_NOW, no TRADEUP_NOW, no trade/order.
- [ ] No BUY_NOW / TRADEUP_NOW / trade action appears.
- [ ] No DATA_BRIDGE write occurs.
- [ ] Mother UI remains unchanged.
- [ ] Browser acceptance result is recorded in the manual observation template.
