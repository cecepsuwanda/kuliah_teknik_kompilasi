int main() {
    int i = 0;
    while (i < 3) {
        i = i + 1;
        if (i == 2) {
            continue;
        }
        print(i);
    }
    return 0;
}
