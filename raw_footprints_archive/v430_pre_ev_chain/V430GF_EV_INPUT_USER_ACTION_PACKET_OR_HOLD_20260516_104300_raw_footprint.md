# V430GF_EV_INPUT_USER_ACTION_PACKET_OR_HOLD Local Footprint

Stamp: 20260516_104300

Status: PASS_HOLD_V430GF_EV_INPUT_USER_ACTION_PACKET_CREATED_NO_EV

Decision: READY_FOR_V430GG_EV_INPUT_WORKSPACE_FILL_RETRY_OR_HOLD

Rows:
- ev_input_user_action_packet_rows: 1
- required_file_value_checklist_rows: 9
- probability_output_pool_action_rows: 1
- price_source_action_rows: 5
- fee_slippage_liquidity_action_rows: 3
- stale_price_risk_action_rows: 1
- do_not_fake_values_guard_rows: 1

Safety:
- real_ev_input_values_filled: false
- official_ev_calculated: false
- trusted_ev_calculated: false
- fetch: false
- market_price_fetch: false
- buff_fetch: false
- steam_fetch: false
- data_bridge_write: false
- active_payload_write: false
- ui_patch: false
- buy_now: false
- tradeup_now: false
