// Berkas: examples/lex_demo.sc
// Program contoh untuk pengujian lexer.

// Identifier, literal, dan operator
int hitung(int a, int b) {
    int hasil = a + b * 2;
    float rasio = 3.14;
    char tanda = 'x';
    string pesan = "hasil = ";
    print(pesan);
    print(hasil);
    print(rasio);
    print(tanda);
    return hasil;
}

int main() {
    int x = 10;
    int y = 20;
    if (x <= y && y != 0) {
        print(hitung(x, y));
    } else {
        print(0);
    }
    while (x < y) {
        x = x + 1;
    }
    return 0;
}
