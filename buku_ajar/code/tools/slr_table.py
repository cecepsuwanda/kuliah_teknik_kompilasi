"""slr_table.py - membangun himpunan item LR(0) dan tabel SLR(1).

Format grammar sama dengan first_follow.py:

    E -> E + T | T
    T -> T * F | F
    F -> ( E ) | id

Simbol di sisi kiri dianggap nonterminal; simbol lain terminal.
"""

import os
import sys
from collections import deque

sys.path.insert(0, os.path.dirname(__file__))
from first_follow import (  # noqa: E402
    parse_grammar,
    compute_first,
    compute_follow,
)

START_PRIME = "S'"


def closure(items, productions):
    result = set(items)
    changed = True

    while changed:
        changed = False
        for lhs, rhs, dot in list(result):
            if dot < len(rhs) and rhs[dot] in productions:
                symbol = rhs[dot]
                for alternative in productions[symbol]:
                    item = (symbol, tuple(alternative), 0)
                    if item not in result:
                        result.add(item)
                        changed = True

    return frozenset(result)


def goto(items, symbol, productions):
    moved = set()

    for lhs, rhs, dot in items:
        if dot < len(rhs) and rhs[dot] == symbol:
            moved.add((lhs, rhs, dot + 1))

    if not moved:
        return None

    return closure(moved, productions)


def canonical_collection(productions, start_symbol):
    augmented = dict(productions)
    augmented[START_PRIME] = [[start_symbol]]

    start = closure({(START_PRIME, (start_symbol,), 0)}, augmented)
    states = [start]
    index = {start: 0}
    transitions = {}
    queue = deque([start])

    while queue:
        current = queue.popleft()
        current_index = index[current]
        symbols = set()

        for lhs, rhs, dot in current:
            if dot < len(rhs):
                symbols.add(rhs[dot])

        for symbol in sorted(symbols):
            nxt = goto(current, symbol, augmented)
            if nxt is None:
                continue
            if nxt not in index:
                index[nxt] = len(states)
                states.append(nxt)
                queue.append(nxt)
            transitions[(current_index, symbol)] = index[nxt]

    return states, transitions, augmented


def build_slr_table(productions, nonterminals, start_symbol):
    states, transitions, augmented = canonical_collection(
        productions, start_symbol
    )
    first = compute_first(augmented, set(augmented.keys()))
    follow = compute_follow(
        augmented, set(augmented.keys()), list(augmented.keys()), first
    )

    actions = {}
    gotos = {}
    conflicts = []

    for state_index, state in enumerate(states):
        for lhs, rhs, dot in state:
            if dot < len(rhs):
                symbol = rhs[dot]
                if symbol in nonterminals:
                    target = transitions.get((state_index, symbol))
                    if target is not None:
                        gotos[(state_index, symbol)] = target
                else:
                    target = transitions.get((state_index, symbol))
                    if target is not None:
                        actions.setdefault(
                            (state_index, symbol), set()
                        ).add(("shift", target))
            else:
                if lhs == START_PRIME:
                    actions.setdefault(
                        (state_index, "$"), set()
                    ).add(("accept", None))
                else:
                    for terminal in follow.get(lhs, set()):
                        actions.setdefault(
                            (state_index, terminal), set()
                        ).add(("reduce", (lhs, tuple(rhs))))

    for key, values in actions.items():
        if len(values) > 1:
            conflicts.append((key, values))

    return states, transitions, actions, gotos, conflicts, follow


def format_item(lhs, rhs, dot):
    symbols = list(rhs)
    symbols.insert(dot, ".")
    return f"{lhs} -> {' '.join(symbols)}"


def main():
    if len(sys.argv) > 1:
        with open(sys.argv[1], "r", encoding="utf-8") as handle:
            lines = handle.readlines()
    else:
        lines = sys.stdin.readlines()

    productions, nonterminals, order = parse_grammar(lines)
    if not order:
        print("Grammar kosong.")
        return

    start_symbol = order[0]
    states, transitions, actions, gotos, conflicts, follow = \
        build_slr_table(productions, nonterminals, start_symbol)

    print(f"State awal: {start_symbol}")
    print(f"Jumlah state LR(0): {len(states)}")
    print()

    for index, state in enumerate(states):
        print(f"I{index}:")
        for lhs, rhs, dot in sorted(state):
            print(f"  {format_item(lhs, rhs, dot)}")
        print()

    print("Tabel ACTION:")
    for (state, terminal), values in sorted(actions.items()):
        rendered = []
        for kind, payload in sorted(values, key=str):
            if kind == "shift":
                rendered.append(f"s{payload}")
            elif kind == "reduce":
                rendered.append(f"r({payload[0]} -> {' '.join(payload[1])})")
            else:
                rendered.append("accept")
        print(f"  [{state}, {terminal}] = {', '.join(rendered)}")

    print()
    print("Tabel GOTO:")
    for (state, symbol), target in sorted(gotos.items()):
        print(f"  [{state}, {symbol}] = {target}")

    print()
    if conflicts:
        print(f"KONFLIK: {len(conflicts)}")
        for (state, terminal), values in conflicts:
            print(f"  [{state}, {terminal}] = {values}")
    else:
        print("Tidak ada konflik SLR.")


if __name__ == "__main__":
    main()
