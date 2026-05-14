# PYCSON Codex 半自动化转型脚印报告

## 0. 报告定位

这份报告记录的是 PYCSON 从“人工复制 PowerShell、人工运行、人工回贴结果”的传统推进方式，转向“Codex 半自动后台执行、用户只审批关键门禁”的一次关键工程转折。

这不是普通的功能更新，也不是某一个 V430 小版本的单点总结，而是 PYCSON 工作流本身的升级：从手工跑流水线，逐步变成由 Codex 作为后台工程执行员，根据 latest JSON、report、handoff、Git summary 和安全规则自动推进安全阶段。

这次转型的核心意义是：用户不再需要像机器人一样在两个窗口之间来回搬运代码和结果，而是逐步变成项目总指挥。简单、安全、可审计的阶段由 Codex 后台跑；涉及 DATA_BRIDGE、UI、active payload、official EV、fetch、BUY_NOW、TRADEUP_NOW、交易相关动作时，必须停下来请求用户审批。

本报告为 PYCSON 长期脚印系统的一部分，属于工程流程层面的 milestone footprint。

---

## 1. 初始痛点：用户像“人工中转机器人”

在 Codex 介入之前，PYCSON 的推进方式是：

1. ChatGPT 生成 PowerShell。
2. 用户复制 PowerShell 到本地 Windows PowerShell。
3. 用户等待脚本运行。
4. 用户复制 summary lines 回 ChatGPT。
5. ChatGPT 判断 PASS / HOLD / NEXT。
6. ChatGPT 再生成下一段 PowerShell。
7. 循环重复。

这种方式的优点是安全、透明、每一步都能人工确认；缺点也非常明显：用户需要一直盯着屏幕，需要手动复制粘贴，需要在“聊天窗口”和“PowerShell 窗口”之间反复切换。

随着 PYCSON 版本链推进到 V430，脚印系统、latest JSON、report JSON、handoff、Git summary、no-write proof 已经越来越成熟，但也带来了更多重复动作。每一个 stage 都要创建目录、写报告、写 latest、写 handoff、写 words.cossp、写 Git raw footprint、写 Git summary、commit、push。对一个长期工程来说，这些动作很重要，但并不都需要用户亲自手动搬运。

用户明确表达了一个关键需求：不是要 AI 替自己做危险决策，而是要把简单的、机械的、低风险的后台任务自动化。用户希望自己可以去写作业、看资料、问其他 AI，而 Codex 在后台推进 PYCSON 的安全阶段；只有遇到重要审批节点时再停下来让用户确认。

这个需求非常清晰：不是全自动交易，不是自动算 EV，不是自动写桥，而是半自动工程执行。

---

## 2. 发现 Codex：从“不知道有”到安装成功

一开始，用户并不知道 ChatGPT Plus 已经包含 Codex。我们先讨论了 agent / coding agent 与普通深度思考模式的差异。

普通深度思考模式更像“强分析 + 用户手动执行”。它能写代码、分析结果、制定下一步，但不能直接替用户操作本地环境。Codex 则更接近“本地工程助手”：可以连接本地项目，运行命令，读取文件，写 Git summary，处理 commit/push，并在需要时弹出权限确认。

之后，用户开始寻找 Codex 入口。第一次在普通 ChatGPT 左侧栏没有看到 Codex 图标，于是转向官方入口和 Microsoft Store。用户最终在 Microsoft Store 中找到了 OpenAI 的 Codex Windows app，并成功安装。

安装后，用户打开 Codex，看到 “Welcome to Codex” 和 “Continue with ChatGPT”。用户使用同一个 ChatGPT Plus 账号登录。登录成功后，进入 Codex 主界面。

这一阶段的关键发现是：Codex 并不是需要用户重新训练模型的东西，而是通过项目路径、权限规则、任务说明和本地环境来配置工作流。也就是说，用户不需要做机器学习意义上的训练，不需要喂大量数据，不需要微调模型；真正要做的是告诉 Codex：PYCSON 的路径在哪里、latest JSON 在哪里、哪些动作可以自动做、哪些动作必须停下来问用户。

---

## 3. 初次接入：只读测试与锚点误判

第一次让 Codex 介入时，我们没有直接让它修改项目，而是给了一个非常保守的只读检查任务：

- 读取 PYCSON root。
- 读取 latest JSON 目录。
- 找出当前最新可靠锚点。
- 检查 Git 仓库状态。
- 禁止写 DATA_BRIDGE。
- 禁止改 UI。
- 禁止改 active payload。
- 禁止 fetch。
- 禁止 official EV。
- 禁止 BUY_NOW / TRADEUP_NOW。
- 禁止交易。

这一步成功证明 Codex 可以读取本地项目和 Git 仓库，并返回 STATUS、LATEST ANCHOR、NEXT SAFE STEP、GIT STATUS。

但第一次也暴露了一个问题：Codex 将某个旧版本号 V429A12K2E4F5L2R2P 错误识别为 latest anchor。它不是按主线 latest JSON 和 status/decision 判断锚点，而是混入了 version + stamp 的旧文件名或时间戳逻辑。

这个问题非常重要，因为 PYCSON 的主线绝不能靠“最新时间戳文件”乱接。PYCSON 必须以 latest JSON、report JSON、handoff 和明确的 status/decision 为准。于是我们立刻纠正 Codex：当前锚点必须以 V430S latest JSON 为准，而不是按文件名或时间戳猜。

随后 Codex 被要求检查错误命名的 raw footprint。如果内容实际上是在描述 V430S，则改名为 V430S；如果内容无关，则隔离或删除。Codex 成功修正了 V430S Git footprint，并完成 git add、commit、push。之后又做了只读核查，返回 CLEAN，可以继续 V430T。

这一段的意义是：Codex 能工作，但必须接受 PYCSON 的锚点规则。不能按时间戳乱认锚点，必须按 latest JSON 和 status/decision 判断主线。

---

## 4. Git 仓库结构整理：从混乱到分层

在 Codex 介入过程中，我们同时整理了 GitHub 仓库结构。用户提出一个重要想法：能否同时保留两类内容？

第一类是细碎的真实脚印，像工程审计档案一样，记录小版本、小门禁、小修复、小验证。

第二类是给外人看的阶段性总结，清晰、干净、有可读性，适合展示项目价值。

这个思路被确认为正确。于是 Git 仓库被分为几层：

- architecture：长期系统结构说明。
- git_summaries：日常 Git 小总结。
- raw_footprints_archive：细粒度工程脚印档案。
- milestone_summaries：阶段性总结。
- public_showcase：对外展示区。
- version_reports：版本链报告和结构化快照。
- version_summaries：版本段总结。
- milestones：大里程碑文件夹。

随后创建了 README_REPOSITORY_STRUCTURE.md，用来说明每个文件夹用途和 PYCSON 默认脚印规则。起初 GitHub 网页端没有显示部分文件夹，后来发现原因是 GitHub 不显示空文件夹，必须用 .gitkeep 占位。创建占位文件并 commit/push 后，GitHub 左侧树正常显示了 milestone_summaries、public_showcase、raw_footprints_archive 等目录。

这一阶段解决了一个关键问题：PYCSON 不再只是本地堆积文件，而是有了 GitHub 上的层级表达。细脚印负责审计，阶段总结负责解释，public_showcase 负责对外展示，architecture 负责长期结构。

---

## 5. V430T 到 V430X：证明 Codex 能跑完整安全 stage

在修正锚点和仓库结构后，我们让 Codex 进入 V430T。目标是根据 V430S 的结果创建 manual probability/output_pool evidence package。Codex 自动读取 V430S latest，生成本地 stage，写 manual evidence package，写 latest、report、handoff、no-write proof、words.cossp、Git raw footprint、Git summary，并完成 git add/commit/push。

V430T 的结果是：

- manual package rows = 80。
- official EV calculated = false。
- DATA_BRIDGE write = false。
- UI patch = false。
- Git commit/push = true。
- next safe step = V430U。

随后 Codex 又完成 V430U、V430V、V430W、V430X 等安全阶段。每一步都遵守了核心边界：不写 DATA_BRIDGE，不写 active payload，不改 UI，不 fetch，不算 EV，不 BUY_NOW，不 TRADEUP_NOW，不交易。

V430U 审查 manual evidence package，确认 80 行都没有完整 manual probability / output_pool / reference，因此保持 HOLD。

V430V 生成 manual fill candidate 和 rule repair candidate，80 行仍缺真实 evidence。

V430W 生成 manual/rule evidence application plan，只是计划，不应用真实证据。

V430X 审查 application plan，确认结构完整，但 80 行仍缺 evidence，因此进入 V430Y pre-application evidence package。

这一段证明了 Codex 可以替代用户完成“读取 latest → 生成 stage → 写脚印 → Git 提交 → 返回 summary”的整套机械流程。用户不再需要手动复制 PowerShell，也不需要每一步都盯着脚本跑完。

---

## 6. 从单任务到连续任务：半自动规则的建立

一开始，Codex 每次仍然需要用户给下一条指令。例如做完 V430T 后，需要用户再告诉它做 V430U；做完 V430U 后，需要用户再告诉它做 V430V。用户指出这还不是真正想要的后台自动化，因为仍然需要一直返回给 Codex 指令。

问题的本质是：Codex 还处于单任务模式。它知道如何完成当前任务，但不知道完成后应该自动读取最新 latest JSON 并继续判断 next safe step。

于是我们制定了 PYCSON semi-auto continuous mode：

- 每次从 latest JSON 判断最新锚点。
- 完成一个 stage 后，自动读取新 latest JSON。
- 如果 next safe step 是 review、package、plan、proof、audit、validation、dryrun、Git summary、handoff、latest/report generation 等安全阶段，可以自动继续。
- 如果遇到 approval required、real evidence application、DATA_BRIDGE、active payload、UI、official EV、fetch、BUY_NOW、TRADEUP_NOW、交易、删除大量文件、全项目递归扫描，必须停止并请求确认。
- 每个 stage 必须生成完整脚印体系。
- Git 脚印、summary、report、latest、handoff、no-write proof 属于低风险，可以自动执行。
- 核心系统写入和交易相关永远不能自动执行。

最初我们设置最多连续 3 个安全 stage，然后停下来汇报。Codex 随后成功连续推进 V430AD、V430AE、V430AF 三个 stage，并在 V430AF 停下，原因是 reached 3 safe stages and latest requires user approval。

用户认为如果只是因为 3 个 stage 的上限停下来还不够自动。于是我们进一步修改规则：最多连续推进 100 个安全 stage，但只要触发 STOP RULES 就立即停止。这样不是让 Codex盲跑 100 个，而是给它更大的后台连续空间，真正的停止条件变成红线规则，而不是固定步数。

---

## 7. STOP RULES：什么必须停

为了避免 Codex 失控，我们建立了明确的 STOP RULES。只要出现以下任何情况，Codex 必须停止：

1. approval required。
2. user approval required。
3. real evidence application。
4. actual evidence application。
5. trusted evidence promotion。
6. official EV calculation。
7. trusted EV promotion。
8. DATA_BRIDGE write。
9. active payload write。
10. UI patch。
11. mother UI modification。
12. live UI modification。
13. payload replacement。
14. BUFF fetch。
15. Steam fetch。
16. market fetch。
17. network fetch。
18. BUY_NOW。
19. TRADEUP_NOW。
20. trade / order / auto order。
21. core system write。
22. delete many files。
23. large rename。
24. full project recursive scan。
25. GitHub repository structure change。
26. public_showcase formal publish。
27. milestone_summaries formal publish。
28. latest JSON missing。
29. latest JSON unreadable。
30. report JSON missing。
31. Git status not clean before starting a new stage。
32. anchor mismatch。
33. next safe step unclear。
34. status/decision conflict。
35. any command touching DATA_BRIDGE / UI / active payload / market/fetch/trade path。

这些规则让 Codex 的半自动能力有边界。它可以跑简单任务，但不能决定真实证据应用、核心写入、EV、fetch 和交易。

这个边界非常符合 PYCSON 的长期工程哲学：候选不等于证据，证据不等于可信，可信不等于可执行，dryrun 不等于真实应用，WATCH/REVIEW 不等于 BUY_NOW。

---

## 8. V430Y 到 V430AF：连续半自动的首次成功

在设置半自动连续模式后，Codex 开始自动推进。它从 V430X latest 判断 next safe step，进入 V430Y，再继续到 V430Z。V430Z 的结果是 pre-application package review 完成，但进入 approval required 节点：

- STATUS = PASS_HOLD_V430Z_PRE_APPLICATION_PACKAGE_REVIEW_APPROVAL_REQUIRED_NO_EV。
- DECISION = HOLD_FOR_USER_APPROVAL_BEFORE_MANUAL_OR_RULE_EVIDENCE_EXECUTION_OR_HOLD。
- can proceed next = false。
- 安全项全 false。

这说明 Codex 正确停止，没有擅自进入 manual/rule evidence execution。

用户随后批准了一个更安全的下一步：只允许生成 dryrun / application-prep package，不允许真实证据应用。于是 V430AA 生成 dryrun prep package，V430AB 审查 dryrun prep package，V430AB 又在 dryrun execution 前停下要求用户批准。

用户批准 V430AC：只允许 dryrun execution，不允许真实 evidence application。Codex 完成 V430AC，生成 dryrun execution rows、validation rows、blocker rows，并保持 official EV、DATA_BRIDGE、active payload、UI、fetch、BUY_NOW、TRADEUP_NOW 全 false。

之后 semi-auto continuous mode 继续推进 V430AD、V430AE、V430AF 三个安全 stage。V430AF 最终停在：

- STATUS = PASS_HOLD_V430AF_DRYRUN_RESULT_PACKAGE_REVIEW_READY_NO_APPLICATION_NO_EV。
- DECISION = HOLD_FOR_USER_APPROVAL_BEFORE_REAL_EVIDENCE_APPLICATION_OR_NEXT_DRYRUN_PLAN。
- safety summary 全 false。
- Git status clean。

这说明半自动后台模式已经可以实际工作：简单阶段它自己做；遇到真实 evidence application 或 next dryrun plan 的选择时，它停下来。

---

## 9. 为什么需要保存实际执行脚本

在 Codex 自动运行过程中，用户提出一个关键问题：既然 Codex 自己生成和运行脚本，那代码在哪里？如果没有保存，未来复盘会不知道它到底跑了什么。

这个问题非常重要。Codex 自动化不能变成“黑箱执行”。PYCSON 的优势一直是可审计、可回滚、有脚印、有 no-write proof。因此，半自动化阶段必须把实际执行脚本保存下来。

于是新增规则：每个 stage 必须保存实际执行脚本：

- 目录：00_EXECUTED_SCRIPT。
- 文件名：RUN_<STAGE_NAME>_<STAMP>.ps1。
- report JSON 必须记录 executed_script_path 和 executed_script_sha256。
- handoff MD 必须记录 executed script 路径。
- Git raw footprint 必须记录 executed script 路径和 sha256。
- Git summary 只记录脚本路径和 sha256，不提交大型 CSV/payload。
- 如果某一步是内联命令执行，也必须把等价完整脚本保存到 00_EXECUTED_SCRIPT。

这个规则让 Codex 自动化仍然保持 PYCSON 的工程审计传统。以后即使用户没有亲眼看完整 PowerShell，也可以通过 executed script path 和 hash 追溯每一步到底执行了什么。

---

## 10. 当前半自动化状态总结

截至本报告生成时，Codex 已经完成以下能力验证：

1. 成功安装并登录。
2. 成功读取 PYCSON 本地项目。
3. 成功读取 latest JSON。
4. 成功检查 Git 仓库。
5. 成功修正一次错误锚点。
6. 成功提交和 push Git 脚印。
7. 成功连续跑多个安全 stage。
8. 成功在 approval gate 停下。
9. 成功区分 dryrun 和真实应用。
10. 成功保持 official EV、DATA_BRIDGE、active payload、UI、fetch、BUY_NOW、TRADEUP_NOW 全 false。
11. 成功进入 semi-auto continuous mode。
12. 成功生成本地 stage、words.cossp、latest、report、handoff、no-write proof、Git raw footprint、Git summary。
13. 成功使用户从“复制粘贴机器人”转向“审批总指挥”。

当前半自动模式可以概括为：

- 安全阶段：Codex 可以自动推进。
- 低风险文件：Codex 可以自动写入和提交。
- 关键门禁：Codex 必须停下请求用户。
- 危险动作：永远不能自动执行。
- 用户角色：从手动执行者转为授权者和审查者。

---

## 11. 当前最新 PYCSON 主线状态

本报告主要记录 Codex 半自动化转型，不作为最新 PYCSON 主线的唯一依据。主线仍以 latest JSON 为准。

截至本报告前后，最近可靠进展包括：

- V430T：manual probability/output_pool evidence package ready，80 rows，no EV。
- V430U：manual evidence review completed，0 complete rows，no EV。
- V430V：manual fill / rule repair package ready，80/80/80 rows，no EV。
- V430W：manual/rule evidence application plan ready，80/80/80 rows，no EV。
- V430X：application review structured but still missing evidence，no EV。
- V430Z：pre-application package review reached approval required。
- V430AA：dryrun prep package ready，no execution, no EV。
- V430AB：dryrun prep review ready, execution approval required。
- V430AC：dryrun execution simulated, no application, no EV。
- V430AF：dryrun result package review ready, approval required before real evidence application or next dryrun plan。

所有这些都保持以下安全项为 false：

- official EV calculated。
- DATA_BRIDGE write。
- active payload write。
- UI patch。
- fetch。
- BUY_NOW。
- TRADEUP_NOW。
- real evidence application。
- core write。

---

## 12. 结论：PYCSON 的工程方式升级了

这次 Codex 介入不是简单换了一个工具，而是 PYCSON 工程方式的升级。

以前，用户必须手动复制 PowerShell，手动运行，手动回贴结果。现在，Codex 已经可以作为后台执行员，在 PYCSON 的安全规则内自动推进多个 stage。用户不再需要一直盯着屏幕，只需要在 approval gate、真实 evidence application、DATA_BRIDGE、UI、EV、fetch、交易相关节点做决策。

这正是 PYCSON 作为长期工程需要的模式：

- 文件化接力，而不是聊天记忆接力。
- latest JSON 作为锚点，而不是时间戳猜测。
- no-write proof 作为安全边界证明。
- Git raw footprint 作为公开可追溯脚印。
- Git summary 作为阶段可读记录。
- executed script 存档作为自动化审计依据。
- STOP RULES 作为半自动化安全闸门。

用户最初的问题是：能不能不要像机器人一样一直复制代码和回传结果？答案已经被实践证明：可以。Codex 已经能承担大量机械工程流程。下一步的重点不是再证明 Codex 能不能跑，而是把 PYCSON_AGENT_RULES、STOP RULES、executed script 存档、连续 stage 限制和审批包机制固定下来，使它成为 PYCSON 的长期半自动工程制度。

最终目标不是让 Codex 失控地自动跑完一切，而是让它在安全边界内尽可能后台工作，让用户从“手动操作员”升级为“系统总指挥”。

PYCSON 半自动化第一阶段，正式成立。
