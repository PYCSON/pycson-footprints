# LIVE UI Future Route Insertion Next Steps

1. Use V430OR route-family taxonomy before adding any new module.
2. Put major families in navigation, secondary routes in the route directory, route status in the central cockpit, and risk/boundary warnings in the right panel.
3. Keep bottom actions safe: navigation, review, refresh, export, or rollback only.
4. Require explicit authorization before any DATA_BRIDGE write, active payload write, EV calculation, fetch, scheduler execution, or UI integration route.
5. Never add BUY_NOW, TRADEUP_NOW, trade, or order triggers.
6. Preserve the mother UI as canonical source and patch LIVE UI only after backup.
7. Every future UI insertion should produce backup, rollback, boundary proof, report/latest JSON, footprint, Git raw footprint, and Git summary.
