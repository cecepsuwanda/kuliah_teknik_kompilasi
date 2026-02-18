import pandas as pd
import re
import os

# ---------------------------------------------------------------------------
# Format: ujian-akhir-semester.tex (book_2)
# Satu file berisi soal + kunci. Soal: \item \soal{...}\begin{enumerate}[label=(\Alph*)] ... \item A/B/C/D \end{enumerate}
# Kunci: tabel dengan baris seperti "1 & B & 11 & C & 21 & B & ... \\"
# ---------------------------------------------------------------------------

def parse_answers_ujian(content):
    """
    Parses kunci jawaban dari ujian-akhir-semester.tex (bagian tabular).
    Returns dict: {question_num: 'A'|'B'|'C'|'D'}
    """
    answers_map = {}
    # Cari baris data tabel: 1 & B & 11 & C & 21 & B & 31 & B & 41 & B \\
    # Abaikan baris yang berisi \textbf (header)
    pattern = r'^\s*(\d+)\s*&\s*([A-D])\s*&\s*(\d+)\s*&\s*([A-D])\s*&\s*(\d+)\s*&\s*([A-D])\s*&\s*(\d+)\s*&\s*([A-D])\s*&\s*(\d+)\s*&\s*([A-D])\s*\\\\'
    for line in content.splitlines():
        if '\\textbf' in line or not line.strip():
            continue
        m = re.match(pattern, line)
        if m:
            pairs = [(int(m.group(i)), m.group(i+1)) for i in range(1, 10, 2)]
            for num, letter in pairs:
                answers_map[num] = letter.upper()
    return answers_map


def _strip_tex(s):
    """Buang whitespace berlebih dan newline di dalam teks."""
    if not s:
        return ""
    s = s.strip()
    s = re.sub(r'\s+', ' ', s)
    return s


def _find_soal_blocks(content):
    r"""
    Menemukan blok \item \soal{...}\begin{enumerate}...\end{enumerate} dengan menghitung kurung kurawal.
    Returns list of (question_text, options_content).
    """
    bs = chr(92)  # backslash
    blocks = []
    start = 0
    # Pola: \item diikuti spasi/newline lalu \soal{ (gunakan literal agar sama dengan isi file)
    item_str = bs + "item"
    soal_str = bs + "soal{"
    while True:
        idx = content.find(item_str, start)
        if idx < 0:
            break
        # Cek apakah setelah "item" ada whitespace lalu \soal{
        after_item = content[idx + len(item_str):idx + len(item_str) + 20]
        if not re.match(r"\s+" + re.escape(soal_str), after_item):
            start = idx + 1
            continue
        # Posisi awal \soal{
        soal_start = idx + len(item_str)
        # Lewati whitespace
        j = soal_start
        while j < len(content) and content[j] in " \t\n\r":
            j += 1
        if not content[j:j + len(soal_str)].startswith(soal_str):
            start = idx + 1
            continue
        brace_start = j + len(soal_str) - 1  # posisi {
        depth = 1
        pos = brace_start + 1
        while pos < len(content) and depth > 0:
            if content[pos] == bs and pos + 1 < len(content) and content[pos + 1] in "{}":
                pos += 2
                continue
            if content[pos] == "{":
                depth += 1
            elif content[pos] == "}":
                depth -= 1
            pos += 1
        if depth != 0:
            start = idx + 1
            continue
        q_end = pos - 1
        q_text = content[brace_start + 1 : q_end]
        rest = content[q_end + 1 :]
        beg = rest.find(bs + "begin{enumerate}")
        if beg == -1:
            start = idx + 1
            continue
        end_marker = bs + "end{enumerate}"
        end = rest.find(end_marker, beg)
        if end == -1:
            start = idx + 1
            continue
        opts_content = rest[beg + len(bs + "begin{enumerate}") : end]
        if opts_content.lstrip().startswith("["):
            bracket = opts_content.find("]")
            if bracket != -1:
                opts_content = opts_content[bracket + 1 :]
        blocks.append((q_text, opts_content))
        start = (q_end + 1) + end + len(end_marker)
    return blocks


def parse_questions_ujian(content, answers_map):
    """
    Parses soal pilihan ganda dari ujian-akhir-semester.tex.
    Returns list of dicts: [{"Question", "Correct Answer", "Incorrect Answer 01", ...}, ...]
    """
    questions_list = []
    blocks = _find_soal_blocks(content)

    for q_idx, (q_text, opts_content) in enumerate(blocks):
        q_num = q_idx + 1
        q_text = _strip_tex(q_text)

        # Opsi: tiap baris \item ... (empat opsi)
        opts = []
        for part in re.split(r'(?=\\item\s)', opts_content):
            part = part.strip()
            if not part or part.startswith(r'\end'):
                continue
            if part.startswith(r'\item'):
                opt = part[len(r'\item'):].strip()
                opt = re.sub(r'\s+', ' ', opt)
                if opt:
                    opts.append(opt)
        opts = opts[:4]  # maksimal 4 opsi

        if len(opts) < 4:
            continue

        correct_letter = answers_map.get(q_num, 'A')
        label_map = {'A': 0, 'B': 1, 'C': 2, 'D': 3}
        correct_idx = label_map.get(correct_letter.upper(), 0)
        if correct_idx >= len(opts):
            correct_idx = 0

        correct_answer = opts[correct_idx]
        incorrect_answers = [opts[i] for i in range(len(opts)) if i != correct_idx]
        while len(incorrect_answers) < 4:
            incorrect_answers.append("")

        questions_list.append({
            "Question": q_text,
            "Correct Answer": correct_answer,
            "Incorrect Answer 01": incorrect_answers[0],
            "Incorrect Answer 02": incorrect_answers[1],
            "Incorrect Answer 03": incorrect_answers[2],
            "Incorrect Answer 04": incorrect_answers[3] if len(incorrect_answers) > 3 else "",
        })
    return questions_list


def process_ujian_akhir_semester(tex_path, output_path=None):
    """
    Baca ujian-akhir-semester.tex, ekstrak soal + kunci, tulis ke satu file Excel.
    Mendukung format: \\item (spasi/newline) \\soal{...} \\begin{enumerate}[label=(\\Alph*)] ... \\end{enumerate}.
    Output: satu file quiz_ujian_akhir_semester.xlsx dengan kolom Question, Correct Answer, Incorrect Answer 01--04.
    """
    if not os.path.exists(tex_path):
        print(f"File tidak ditemukan: {tex_path}")
        return False
    with open(tex_path, 'r', encoding='utf-8') as f:
        content = f.read()
    answers_map = parse_answers_ujian(content)
    questions_list = parse_questions_ujian(content, answers_map)
    if not questions_list:
        print("Tidak ada soal yang berhasil diekstrak.")
        return False
    if output_path is None:
        base_dir = os.path.dirname(tex_path)
        output_path = os.path.join(base_dir, "quiz_ujian_akhir_semester.xlsx")
    df = pd.DataFrame(questions_list)
    try:
        df.to_excel(output_path, index=False, engine='openpyxl')
        print(f"Berhasil: {output_path} ({len(df)} soal).")
        return True
    except Exception as e:
        print(f"Error menulis Excel: {e}")
        return False


# ---------------------------------------------------------------------------
# Format lama: bab-18_sec01.tex + bab-18_sec02.tex (per bab)
# ---------------------------------------------------------------------------

def parse_answers(file_path):
    """
    Parses bab-18_sec02.tex to extract correct answers for each chapter and question.
    Returns a dict: {chapter_num: {q_num: 'a'/'b'/'c'/'d'}}
    """
    answers_map = {}
    if not os.path.exists(file_path):
        return answers_map
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    rows = re.findall(
        r'(\d+)\s*&\s*[^&]+\s*&\s*([abcd])\s*&\s*([abcd])\s*&\s*([abcd])\s*&\s*([abcd])\s*&\s*([abcd])\s*\\\\',
        content
    )
    for row in rows:
        chap_num = int(row[0])
        answers = row[1:]
        answers_map[chap_num] = {i + 1: ans for i, ans in enumerate(answers)}
    return answers_map


def parse_questions_by_chapter(file_path, answers_map):
    """
    Parses bab-18_sec01.tex and groups questions by chapter.
    Returns a dict: {chapter_num: [quiz_data_dicts]}
    """
    if not os.path.exists(file_path):
        return {}
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    chapters = re.split(r'\\subsection\{Quiz Bab (\d+):', content)
    chapter_data = {}
    for i in range(1, len(chapters), 2):
        chap_num = int(chapters[i])
        chap_content = chapters[i + 1]
        q_blocks = re.findall(
            r'\\item\s+(.*?)\\begin\{enumerate\}\[label=\\alph\*\.\)\]\s*(.*?)\\end{enumerate}',
            chap_content, re.DOTALL
        )
        chapter_questions = []
        for q_idx, (q_text, opts_content) in enumerate(q_blocks):
            q_num = q_idx + 1
            q_text = q_text.strip()
            options = re.findall(r'\\item\s+(.*?)(?=\\item|$)', opts_content, re.DOTALL)
            options = [o.strip() for o in options]
            if len(options) < 4:
                continue
            correct_label = answers_map.get(chap_num, {}).get(q_num)
            if not correct_label:
                continue
            label_map = {'a': 0, 'b': 1, 'c': 2, 'd': 3}
            correct_idx = label_map.get(correct_label, 0)
            correct_answer = options[correct_idx]
            incorrect_answers = [options[idx] for idx in range(len(options)) if idx != correct_idx]
            while len(incorrect_answers) < 4:
                incorrect_answers.append("")
            chapter_questions.append({
                "Question": q_text,
                "Correct Answer": correct_answer,
                "Incorrect Answer 01": incorrect_answers[0],
                "Incorrect Answer 02": incorrect_answers[1],
                "Incorrect Answer 03": incorrect_answers[2],
                "Incorrect Answer 04": incorrect_answers[3] if len(incorrect_answers) > 3 else "",
            })
        if chapter_questions:
            chapter_data[chap_num] = chapter_questions
    return chapter_data


def export_chapters_to_excel(chapter_data):
    """Writes each chapter's questions to a separate quiz_N.xlsx file."""
    for chap_num, data in chapter_data.items():
        output_file = f"quiz_{chap_num}.xlsx"
        df = pd.DataFrame(data)
        try:
            df.to_excel(output_file, index=False, engine='openpyxl')
            print(f"Successfully created: {output_file} with {len(df)} questions.")
        except Exception as e:
            print(f"Error writing to {output_file}: {e}")


if __name__ == "__main__":
    # Default: proses book_2/ujian-akhir-semester.tex (dari root repo) atau ./ujian-akhir-semester.tex (dari book_2)
    script_dir = os.path.dirname(os.path.abspath(__file__))
    uas_path = os.path.join(script_dir, "book_2", "ujian-akhir-semester.tex")
    if not os.path.exists(uas_path):
        uas_path = os.path.join(script_dir, "ujian-akhir-semester.tex")
    if os.path.exists(uas_path):
        process_ujian_akhir_semester(uas_path)
    else:
        # Fallback: format lama (bab-18)
        q_file = os.path.join('sections', 'bab-18_sec01.tex')
        a_file = os.path.join('sections', 'bab-18_sec02.tex')
        ans_map = parse_answers(a_file)
        chap_data = parse_questions_by_chapter(q_file, ans_map)
        if chap_data:
            export_chapters_to_excel(chap_data)
        else:
            print("No quiz data extracted. Check LaTeX files or path to book_2/ujian-akhir-semester.tex.")
