import pandas as pd
import re
import os

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

    # Look for table rows like: 1 & Pengenalan Kompilator & b & c & b & d & c \\
    rows = re.findall(r'(\d+)\s*&\s*[^&]+\s*&\s*([abcd])\s*&\s*([abcd])\s*&\s*([abcd])\s*&\s*([abcd])\s*&\s*([abcd])\s*\\\\', content)
    
    for row in rows:
        chap_num = int(row[0])
        answers = row[1:]
        answers_map[chap_num] = {i+1: ans for i, ans in enumerate(answers)}
    
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
        chap_content = chapters[i+1]
        
        q_blocks = re.findall(r'\\item\s+(.*?)\\begin\{enumerate\}\[label=\\alph\*\.\)\]\s*(.*?)\\end{enumerate}', chap_content, re.DOTALL)
        
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
                "Incorrect Answer 04": incorrect_answers[3] if len(incorrect_answers) > 3 else ""
            })
        
        if chapter_questions:
            chapter_data[chap_num] = chapter_questions
            
    return chapter_data

def export_chapters_to_excel(chapter_data):
    """
    Writes each chapter's questions to a separate quiz_N.xlsx file.
    """
    for chap_num, data in chapter_data.items():
        output_file = f"quiz_{chap_num}.xlsx"
        df = pd.DataFrame(data)
        try:
            df.to_excel(output_file, index=False, engine='openpyxl')
            print(f"Successfully created: {output_file} with {len(df)} questions.")
        except Exception as e:
            print(f"Error writing to {output_file}: {e}")

if __name__ == "__main__":
    q_file = os.path.join('sections', 'bab-18_sec01.tex')
    a_file = os.path.join('sections', 'bab-18_sec02.tex')
    
    ans_map = parse_answers(a_file)
    chap_data = parse_questions_by_chapter(q_file, ans_map)
    
    if chap_data:
        export_chapters_to_excel(chap_data)
    else:
        print("No quiz data extracted. Check LaTeX files.")
