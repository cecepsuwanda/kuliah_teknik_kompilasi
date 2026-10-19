"""fa_tool.py - simulasi DFA/NFA, subset construction, dan minimalisasi.

Dipakai untuk memverifikasi contoh pada Bab VI dan Bab VII.
Tidak memiliki dependensi pihak ketiga.
"""

from collections import deque

EPSILON = ""


class DFA:
    """DFA dengan transisi total atau parsial.

    delta: dict[(state, symbol)] -> state
    """

    def __init__(self, states, alphabet, delta, start, accepting):
        self.states = set(states)
        self.alphabet = set(alphabet)
        self.delta = dict(delta)
        self.start = start
        self.accepting = set(accepting)

    def step(self, state, symbol):
        return self.delta.get((state, symbol))

    def accepts(self, text):
        state = self.start
        for symbol in text:
            state = self.step(state, symbol)
            if state is None:
                return False
        return state in self.accepting

    def minimize(self):
        """Minimalisasi DFA dengan penyempurnaan partisi."""
        sink = "__sink__"
        states = set(self.states) | {sink}
        delta = {}
        for state in states:
            for symbol in self.alphabet:
                delta[(state, symbol)] = self.delta.get(
                    (state, symbol), sink
                )

        # Buang state yang tidak dapat dicapai.
        reachable = {self.start}
        queue = deque([self.start])
        while queue:
            state = queue.popleft()
            for symbol in self.alphabet:
                nxt = delta[(state, symbol)]
                if nxt not in reachable:
                    reachable.add(nxt)
                    queue.append(nxt)
        states = reachable

        accepting = set(self.accepting) & states
        groups = [accepting, states - accepting]
        groups = [group for group in groups if group]

        def group_index(state):
            for index, group in enumerate(groups):
                if state in group:
                    return index
            raise KeyError(state)

        while True:
            refined = []
            for group in groups:
                signatures = {}
                for state in group:
                    signature = tuple(
                        group_index(delta[(state, symbol)])
                        for symbol in sorted(self.alphabet)
                    )
                    signatures.setdefault(signature, set()).add(state)
                refined.extend(signatures.values())
            if len(refined) == len(groups):
                break
            groups = refined

        state_to_group = {}
        for index, group in enumerate(groups):
            for state in group:
                state_to_group[state] = index

        new_delta = {}
        for index, group in enumerate(groups):
            representative = next(iter(group))
            for symbol in self.alphabet:
                new_delta[(index, symbol)] = state_to_group[
                    delta[(representative, symbol)]
                ]

        new_accepting = {
            state_to_group[state]
            for state in accepting
            if state in state_to_group
        }
        return DFA(
            set(range(len(groups))),
            self.alphabet,
            new_delta,
            state_to_group[self.start],
            new_accepting,
        )


class NFA:
    """NFA dengan transisi epsilon.

    delta: dict[(state, symbol)] -> set(state)
    Gunakan EPSILON sebagai symbol untuk transisi epsilon.
    """

    def __init__(self, states, alphabet, delta, start, accepting):
        self.states = set(states)
        self.alphabet = set(alphabet)
        self.delta = {
            key: set(value) for key, value in delta.items()
        }
        self.start = start
        self.accepting = set(accepting)

    def epsilon_closure(self, states):
        closure = set(states)
        stack = list(states)
        while stack:
            state = stack.pop()
            for nxt in self.delta.get((state, EPSILON), set()):
                if nxt not in closure:
                    closure.add(nxt)
                    stack.append(nxt)
        return frozenset(closure)

    def move(self, states, symbol):
        result = set()
        for state in states:
            result |= self.delta.get((state, symbol), set())
        return result

    def accepts(self, text):
        current = self.epsilon_closure({self.start})
        for symbol in text:
            current = self.epsilon_closure(self.move(current, symbol))
        return bool(current & self.accepting)

    def to_dfa(self):
        start = self.epsilon_closure({self.start})
        states = {start}
        queue = deque([start])
        delta = {}

        while queue:
            current = queue.popleft()
            for symbol in self.alphabet:
                nxt = self.epsilon_closure(self.move(current, symbol))
                delta[(current, symbol)] = nxt
                if nxt not in states:
                    states.add(nxt)
                    queue.append(nxt)

        accepting = {
            state for state in states if state & self.accepting
        }
        return DFA(states, self.alphabet, delta, start, accepting)


def demo_identifier_dfa():
    """DFA untuk [A-Za-z_][A-Za-z0-9_]* (disederhanakan)."""
    letters = "abcxyz_"
    digits = "0123456789"

    delta = {}
    for char in letters:
        delta[(0, char)] = 1
    for char in letters + digits:
        delta[(1, char)] = 1

    return DFA({0, 1, 99}, set(letters + digits), delta, 0, {1})


def demo_ending_abb():
    """NFA untuk (a|b)*abb, lalu konversi ke DFA."""
    delta = {
        (0, "a"): {0, 1},
        (0, "b"): {0},
        (1, "b"): {2},
        (2, "b"): {3},
    }
    return NFA({0, 1, 2, 3}, {"a", "b"}, delta, 0, {3})


if __name__ == "__main__":
    nfa = demo_ending_abb()
    for text in ["abb", "aabb", "abab", "ab", "babb"]:
        print("NFA", text, nfa.accepts(text))

    dfa = nfa.to_dfa()
    print("DFA states:", len(dfa.states))
    for text in ["abb", "aabb", "abab", "ab", "babb"]:
        print("DFA", text, dfa.accepts(text))

    minimal = dfa.minimize()
    print("Minimal states:", len(minimal.states))
    for text in ["abb", "aabb", "abab", "ab", "babb"]:
        print("MIN", text, minimal.accepts(text))
