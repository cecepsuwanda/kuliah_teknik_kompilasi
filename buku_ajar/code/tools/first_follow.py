"""first_follow.py - menghitung FIRST dan FOLLOW.

Format masukan: satu produksi per baris, misalnya

    E  -> T E'
    E' -> + T E' | epsilon

Simbol yang muncul di sisi kiri dianggap nonterminal; simbol lain
dianggap terminal. Gunakan "epsilon" untuk string kosong.
"""

import sys
from collections import defaultdict

EPSILON = "epsilon"


def parse_grammar(lines):
    productions = defaultdict(list)
    nonterminals = set()
    order = []

    for line in lines:
        line = line.strip()
        if not line or line.startswith("#") or line.startswith("//"):
            continue
        if "->" not in line:
            continue

        lhs, rhs = line.split("->", 1)
        lhs = lhs.strip()
        if not lhs:
            continue

        nonterminals.add(lhs)
        if lhs not in order:
            order.append(lhs)

        for alternative in rhs.split("|"):
            symbols = alternative.strip().split()
            productions[lhs].append(symbols)

    return productions, nonterminals, order


def first_of_sequence(sequence, first, nonterminals):
    result = set()

    for symbol in sequence:
        if symbol not in nonterminals:
            result.add(symbol)
            return result
        result |= first[symbol] - {EPSILON}
        if EPSILON not in first[symbol]:
            return result

    result.add(EPSILON)
    return result


def compute_first(productions, nonterminals):
    first = {symbol: set() for symbol in nonterminals}
    changed = True

    while changed:
        changed = False
        for lhs, alternatives in productions.items():
            for alternative in alternatives:
                if not alternative or alternative == [EPSILON]:
                    if EPSILON not in first[lhs]:
                        first[lhs].add(EPSILON)
                        changed = True
                    continue

                nullable = True
                for symbol in alternative:
                    if symbol not in nonterminals:
                        if symbol not in first[lhs]:
                            first[lhs].add(symbol)
                            changed = True
                        nullable = False
                        break

                    before = len(first[lhs])
                    first[lhs] |= first[symbol] - {EPSILON}
                    if len(first[lhs]) != before:
                        changed = True

                    if EPSILON not in first[symbol]:
                        nullable = False
                        break

                if nullable and EPSILON not in first[lhs]:
                    first[lhs].add(EPSILON)
                    changed = True

    return first


def compute_follow(productions, nonterminals, order, first):
    follow = {symbol: set() for symbol in nonterminals}
    if order:
        follow[order[0]].add("$")

    changed = True
    while changed:
        changed = False
        for lhs, alternatives in productions.items():
            for alternative in alternatives:
                for index, symbol in enumerate(alternative):
                    if symbol not in nonterminals:
                        continue

                    rest = alternative[index + 1:]
                    if rest:
                        first_rest = first_of_sequence(
                            rest, first, nonterminals
                        )
                        before = len(follow[symbol])
                        follow[symbol] |= first_rest - {EPSILON}
                        if len(follow[symbol]) != before:
                            changed = True
                        if EPSILON in first_rest:
                            before = len(follow[symbol])
                            follow[symbol] |= follow[lhs]
                            if len(follow[symbol]) != before:
                                changed = True
                    else:
                        before = len(follow[symbol])
                        follow[symbol] |= follow[lhs]
                        if len(follow[symbol]) != before:
                            changed = True

    return follow


def print_sets(title, sets, order):
    print(title)
    for symbol in order:
        values = ", ".join(sorted(sets[symbol]))
        print(f"  {symbol:>8} : {{ {values} }}")


def main():
    if len(sys.argv) > 1:
        with open(sys.argv[1], "r", encoding="utf-8") as handle:
            lines = handle.readlines()
    else:
        lines = sys.stdin.readlines()

    productions, nonterminals, order = parse_grammar(lines)
    first = compute_first(productions, nonterminals)
    follow = compute_follow(productions, nonterminals, order, first)

    print_sets("FIRST", first, order)
    print()
    print_sets("FOLLOW", follow, order)


if __name__ == "__main__":
    main()
