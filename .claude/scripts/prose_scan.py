#!/usr/bin/env python3
"""
prose_scan.py — seven mechanical prose diagnostics on a markdown chapter.

Each check catches a specific reader complaint pattern. Output is line-numbered
and severity-tagged so a writer can act on it without re-reading everything.

Checks:
  1. Dialogue placeholder regex          (CRITICAL — ship-blocker)
  2. Sentence opener variance            (LOW/MEDIUM/HIGH by run length)
  3. Burstiness collapse                 (MEDIUM — AI flatline)
  4. Echo detector                       (LOW/MEDIUM — repetitive description)
  5. Sensory vs. abstract ratio          (LOW/MEDIUM — thin description)
  6. Transition velocity                 (LOW/MEDIUM/HIGH — story jumps)
  7. Dialogue beat ratio                 (MEDIUM — ping-pong dialogue)
"""

import re
import sys
import statistics
from pathlib import Path
from collections import Counter, defaultdict


# ------------------------------------------------------------------------
# Lexicons
# ------------------------------------------------------------------------

SENSORY_WORDS = {
    # texture
    "velvet", "coarse", "smooth", "rough", "silk", "silken", "gritty", "slick",
    "damp", "wet", "dry", "brittle", "soft", "hard", "sticky", "slimy",
    "jagged", "prickly", "feathery", "grainy", "waxy", "fluffy",
    # taste
    "bitter", "sweet", "salty", "sour", "tart", "metallic", "copper", "iron",
    "coppery", "acrid", "rancid", "honeyed", "peppery", "tangy",
    # sound
    "creak", "creaked", "chime", "chimed", "hiss", "hissed", "rumble", "rumbled",
    "groan", "groaned", "crack", "cracked", "thud", "thudded", "whisper",
    "whispered", "roar", "roared", "click", "clicked", "rustle", "rustled",
    "clang", "clanged", "clatter", "clattered", "squeal", "squealed",
    "scream", "screamed", "hum", "hummed", "whine", "whined", "scrape",
    "scraped", "crunch", "crunched", "tick", "ticked",
    # smell
    "smoke", "smoky", "musk", "musky", "stench", "perfume", "fragrance",
    "bloom", "pine", "rot", "mildew", "sulfur", "ozone", "copper", "bread",
    # light / sight (concrete, not abstract)
    "glint", "glinted", "flicker", "flickered", "shadow", "shadowed",
    "gleam", "gleamed", "glow", "glowed", "shine", "shone", "spark", "sparked",
    "dim", "dimmed", "dusk", "dawn", "twilight", "amber", "crimson", "ember",
    # temperature / touch
    "warm", "cold", "hot", "chill", "chilled", "icy", "cool", "burning",
    "scorching", "frozen", "numb", "freezing", "stifling", "clammy",
    # motion / embodied
    "tremble", "trembled", "shiver", "shivered", "flinch", "flinched",
    "twitch", "twitched", "clench", "clenched", "tense", "tensed",
    "brush", "brushed", "grip", "gripped", "tighten", "tightened",
}

FILTER_VERBS = {
    "felt", "saw", "heard", "noticed", "realized", "watched", "thought",
    "seemed", "looked", "knew", "wondered", "believed", "understood",
    "sensed", "figured", "decided", "considered", "reflected",
}

LOW_EFFORT_TRANSITIONS = {
    "suddenly", "then", "meanwhile", "later", "soon", "eventually",
    "afterwards", "afterward", "subsequently", "thereafter",
}
LOW_EFFORT_PHRASES = [
    "moments later", "a moment later", "after a while", "some time later",
    "a little while later", "after a moment", "a short time later",
]

# Structural phrases that reliably signal AI authorship
ZERO_TOLERANCE_PHRASES = [
    "testament to", "reminder that", "dive in", "let's explore",
    "let's dive", "in today's digital age", "let that sink in",
    "only time will tell", "in conclusion", "at the end of the day",
    "it is important to note", "it's important to note",
    "it's not just about", "it is not just about",
    "to understand x, you", "think of x as", "think of it as",
    "whether it's", "whether it is",
]

# AI-associated vocabulary — flag when clusters appear
AI_VOCAB = {
    "delve", "tapestry", "testament", "myriad", "plethora",
    "multifaceted", "crucial", "nuanced", "paradigm",
    "notably", "furthermore", "moreover", "seamlessly",
    "leverage", "harness", "foster", "cultivate", "invaluable",
    "indispensable", "paramount", "intricate",
    "cutting-edge", "revolutionary", "optimize", "facilitate",
}

WAN_INTENSIFIERS = {
    "very", "really", "quite", "rather", "somewhat", "just",
    "actually", "basically", "literally",
}

LITERAL_AI_PATTERNS = [
    r"\bas an ai\b",
    r"\blanguage model\b",
    r"\bi cannot (?:help|assist|provide|generate|produce|comply|discuss|create|write)\b",
    r"\bi'?m unable to (?:help|assist|provide|generate|produce|comply|discuss|create|write)\b",
    r"\bi apologize.{0,30}\b(?:cannot|unable|can't)\b",
    r"^here'?s (?:a|an|the|your).{0,60}:",
    r"^here are (?:a|some|the|your).{0,60}:",
    r"\bas (?:a|an) (?:large )?language model\b",
]

STOPWORDS = {
    # articles, pronouns, aux verbs, prepositions — classic stopwords
    "a","an","and","the","of","in","on","at","to","for","with","from","by",
    "is","was","were","are","be","been","being","am","i","me","my","you","your",
    "he","she","it","we","they","his","her","its","our","their","them","him",
    "this","that","these","those","there","here","as","but","or","if","so",
    "not","no","do","did","does","done","doing","have","has","had","having",
    "will","would","could","should","can","may","might","must","shall",
    "what","which","who","whom","whose","why","how","when","where",
    "up","down","out","over","under","off","into","onto","through","across",
    "very","just","too","also","about","than","then","some","any","all",
    "one","two","three","four","five","six","seven","eight","nine","ten",
    # dialogue-adjacent (they'll echo in any dialogue-heavy scene)
    "said", "say", "says", "ask", "asks", "asked", "reply", "replied",
    # high-frequency content words that repeat naturally in any English prose
    "like","still","back","small","first","second","third","last",
    "same","different","more","less","most","least","other","another",
    "thing","things","something","nothing","anything","everything",
    "good","bad","old","new","big","little","long","short","high","low",
    "since","because","while","until","though","although","before","after",
    "inside","outside","across","around","among","between","against",
    "almost","nearly","quite","rather","fairly","enough","always","never",
    "own","every","each","few","many","several","both","either","neither",
    "even","ever","once","twice","again","still","already","yet","soon",
    "way","ways","part","parts","side","sides","place","places","time","times",
    "day","days","night","nights","year","years","moment","moments",
    "hand","hands","eye","eyes","face","head","body","mind",  # anatomy — over-used in prose
    "find","finds","found","come","comes","came","go","goes","gone","went",
    "look","looks","looked","see","sees","seen","saw","know","knows","knew",
    "get","gets","got","take","takes","took","give","gives","gave",
    "make","makes","made","think","thinks","thought","want","wants","wanted",
    "tell","tells","told","feel","feels","felt","seem","seems","seemed",
    "turn","turns","turned","move","moves","moved","keep","keeps","kept",
    "hold","holds","held","let","lets","leave","leaves","left",
    "work","works","worked","need","needs","needed","try","tries","tried",
    # common adverbs/fillers
    "only","really","actually","maybe","perhaps","probably","certainly",
}

# Sentence opener classification
PRONOUNS = {"he","she","it","they","we","i","you","him","her","them","us"}
PREPOSITIONS = {
    "in","on","at","by","for","with","from","into","onto","through","under",
    "over","above","below","beside","between","among","across","around",
    "before","after","during","until","toward","towards","against","without",
    "beneath","behind","past","along",
}


# ------------------------------------------------------------------------
# Parsing helpers
# ------------------------------------------------------------------------

def read_prose(path):
    """Return list of (line_number, text) with markdown front-matter and
    heading lines stripped. Prose lines only."""
    lines = []
    in_front_matter = False
    with open(path, "r", encoding="utf-8") as f:
        for i, raw in enumerate(f.readlines(), start=1):
            line = raw.rstrip("\n")
            if i == 1 and line.strip() == "---":
                in_front_matter = True
                continue
            if in_front_matter:
                if line.strip() == "---":
                    in_front_matter = False
                continue
            if line.strip().startswith("#"):
                continue
            lines.append((i, line))
    return lines


SENT_SPLIT = re.compile(r'(?<=[.!?])["\')\]]*\s+(?=[A-Z"\(\[])')

def split_sentences(prose_lines):
    """Return list of (start_line, sentence_text). Tries to keep line mapping."""
    sentences = []
    buf = []
    buf_start = None
    for lineno, text in prose_lines:
        if not text.strip():
            if buf:
                joined = " ".join(s.strip() for s in buf)
                for s in split_joined(joined):
                    sentences.append((buf_start, s))
                buf = []
                buf_start = None
            continue
        if buf_start is None:
            buf_start = lineno
        buf.append(text)
    if buf:
        joined = " ".join(s.strip() for s in buf)
        for s in split_joined(joined):
            sentences.append((buf_start, s))
    return sentences

def split_joined(text):
    parts = SENT_SPLIT.split(text)
    return [p.strip() for p in parts if p.strip()]

def word_count(s):
    return len(re.findall(r"\b[\w'-]+\b", s))

def tokens(s):
    return re.findall(r"\b[\w'-]+\b", s.lower())


def detect_proper_nouns(prose_lines):
    """A word is a proper noun if it appears capitalized mid-sentence.
    Returns a set of lowercase forms to skip in echo detection."""
    proper = set()
    for _, text in prose_lines:
        # Skip first word of each sentence (capitalized by convention)
        parts = re.split(r'(?<=[.!?])\s+', text)
        for part in parts:
            words = re.findall(r"[A-Za-z][A-Za-z'-]*", part)
            for i, w in enumerate(words):
                if i == 0:
                    continue  # first word, skip
                if w[0].isupper() and len(w) >= 3:
                    proper.add(w.lower())
    return proper


# ------------------------------------------------------------------------
# Checks
# ------------------------------------------------------------------------

def check_placeholder(prose_lines):
    """CRITICAL: brackets/angles/parens inside dialogue quotes."""
    findings = []
    placeholder_pat = re.compile(r'"[^"]*[\[\(\<][^"]*[\]\)\>][^"]*"')
    for lineno, text in prose_lines:
        for m in placeholder_pat.finditer(text):
            findings.append({
                "severity": "CRITICAL",
                "check": "dialogue-placeholder",
                "line": lineno,
                "quote": m.group(0),
                "note": "Bracket/paren/angle inside dialogue — literal placeholder left in prose.",
            })
    return findings


def classify_opener(sent):
    words = re.findall(r"\b[\w'-]+\b", sent)
    if not words:
        return "other"
    w = words[0].lower()
    if w in PRONOUNS:
        return "pronoun"
    if w == "the":
        return "the-noun"
    if w in PREPOSITIONS:
        return "preposition"
    if w in {"because","although","though","while","if","when","since","as","after","before","until"}:
        return "dependent-clause"
    if len(words) < 5 and not sent.rstrip().endswith((".",)):
        return "fragment"
    if re.match(r"^[A-Z][a-z]+", sent) and w not in PRONOUNS and w != "the":
        return "name-or-noun"
    return "other"


def check_sentence_opener_variance(sentences):
    """Flag runs of 4+ consecutive sentences with the same opener class."""
    findings = []
    if not sentences:
        return findings
    run_class = None
    run_start = None
    run_len = 0
    run_first_line = None
    run_last_line = None
    for start_line, sent in sentences:
        cls = classify_opener(sent)
        if cls == run_class:
            run_len += 1
            run_last_line = start_line
        else:
            if run_len >= 4 and run_class not in {"fragment","other"}:
                sev = "HIGH" if run_len >= 9 else "MEDIUM" if run_len >= 6 else "LOW"
                findings.append({
                    "severity": sev,
                    "check": "sentence-opener-variance",
                    "line": run_first_line,
                    "line_end": run_last_line,
                    "quote": f"{run_len} consecutive sentences starting with [{run_class}]",
                    "note": "Monotone opener pattern — vary structure.",
                })
            run_class = cls
            run_len = 1
            run_first_line = start_line
            run_last_line = start_line
    if run_len >= 4 and run_class not in {"fragment","other"}:
        sev = "HIGH" if run_len >= 9 else "MEDIUM" if run_len >= 6 else "LOW"
        findings.append({
            "severity": sev,
            "check": "sentence-opener-variance",
            "line": run_first_line,
            "line_end": run_last_line,
            "quote": f"{run_len} consecutive sentences starting with [{run_class}]",
            "note": "Monotone opener pattern — vary structure.",
        })
    return findings


def check_burstiness(sentences):
    """Flag 10-sentence windows whose length stddev < 4.0."""
    findings = []
    lengths = [word_count(s) for _, s in sentences]
    if len(lengths) < 10:
        return findings
    flagged_ranges = []
    for i in range(len(lengths) - 9):
        window = lengths[i:i+10]
        try:
            sd = statistics.stdev(window)
        except statistics.StatisticsError:
            continue
        if sd < 4.0 and 10 <= statistics.mean(window) <= 22:
            flagged_ranges.append((i, i+9, sd))
    if not flagged_ranges:
        return findings
    # Merge overlapping flagged ranges
    merged = [flagged_ranges[0]]
    for start, end, sd in flagged_ranges[1:]:
        last_start, last_end, last_sd = merged[-1]
        if start <= last_end + 1:
            merged[-1] = (last_start, max(last_end, end), min(last_sd, sd))
        else:
            merged.append((start, end, sd))
    for start, end, sd in merged:
        span = end - start + 1
        findings.append({
            "severity": "MEDIUM",
            "check": "burstiness-collapse",
            "line": sentences[start][0],
            "line_end": sentences[end][0],
            "quote": f"{span} consecutive sentences, stddev={sd:.1f} (AI flatline threshold 4.0)",
            "note": "Sentence lengths collapsed to a uniform band — break rhythm.",
        })
    return findings


def check_echo(prose_lines, sentences, proper_nouns):
    """Flag content words appearing 3+ times in 40 words or 4+ in 200 words.
    Excludes stopwords, proper nouns, short words, digits."""
    findings = []
    word_positions = []
    pos = 0
    for lineno, text in prose_lines:
        for w in tokens(text):
            if (
                w in STOPWORDS
                or w in proper_nouns
                or len(w) < 4
                or w.isdigit()
            ):
                pos += 1
                continue
            word_positions.append((pos, lineno, w))
            pos += 1

    by_word = defaultdict(list)
    for p, ln, w in word_positions:
        by_word[w].append((p, ln))

    reported = set()
    for w, entries in by_word.items():
        if len(entries) < 3:
            continue
        for i, (p1, ln1) in enumerate(entries):
            near40 = [e for e in entries[i:] if e[0] - p1 <= 40]
            near200 = [e for e in entries[i:] if e[0] - p1 <= 200]
            if w in reported:
                break
            if len(near40) >= 3:
                findings.append({
                    "severity": "LOW",
                    "check": "echo-tight",
                    "line": ln1,
                    "line_end": near40[-1][1],
                    "quote": f'"{w}" appears {len(near40)}× within 40 words',
                    "note": "Tight echo — vary word choice.",
                })
                reported.add(w)
                break
            elif len(near200) >= 4:
                findings.append({
                    "severity": "LOW",
                    "check": "echo-loose",
                    "line": ln1,
                    "line_end": near200[-1][1],
                    "quote": f'"{w}" appears {len(near200)}× within 200 words',
                    "note": "Loose echo — reader will notice.",
                })
                reported.add(w)
                break

    if len([f for f in findings if f["check"].startswith("echo")]) >= 5:
        for f in findings:
            if f["check"].startswith("echo") and f["severity"] == "LOW":
                f["severity"] = "MEDIUM"
                break
    return findings


def check_sensory_ratio(prose_lines):
    """Flag paragraphs with filter-verb-heavy emotion telling and low sensory density."""
    findings = []
    paragraphs = []  # (start_line, text)
    buf = []
    buf_start = None
    for lineno, text in prose_lines:
        if not text.strip():
            if buf:
                paragraphs.append((buf_start, " ".join(buf)))
                buf = []
                buf_start = None
            continue
        if buf_start is None:
            buf_start = lineno
        buf.append(text)
    if buf:
        paragraphs.append((buf_start, " ".join(buf)))

    for start_line, para in paragraphs:
        toks = tokens(para)
        if len(toks) < 30:
            continue
        filter_count = sum(1 for t in toks if t in FILTER_VERBS)
        sensory_count = sum(1 for t in toks if t in SENSORY_WORDS)
        if filter_count >= 3 and sensory_count <= max(1, filter_count // 3):
            findings.append({
                "severity": "LOW",
                "check": "sensory-ratio",
                "line": start_line,
                "quote": f"{filter_count} filter verbs vs. {sensory_count} sensory words",
                "note": "Telling emotion without rendering sensory reality.",
            })
    if len(findings) >= 5:
        for f in findings[:1]:
            f["severity"] = "MEDIUM"
    return findings


def check_transition_velocity(prose_lines, sentences):
    """Flag low-effort transition density."""
    findings = []
    total_words = sum(word_count(s) for _, s in sentences)
    if total_words == 0:
        return findings
    hits = []
    for lineno, text in prose_lines:
        low = text.lower()
        for t in LOW_EFFORT_TRANSITIONS:
            for m in re.finditer(r"\b" + re.escape(t) + r"\b", low):
                hits.append((lineno, t))
        for phrase in LOW_EFFORT_PHRASES:
            for m in re.finditer(re.escape(phrase), low):
                hits.append((lineno, phrase))
    density_per_300 = len(hits) / (total_words / 300.0) if total_words else 0
    if density_per_300 > 1.0:
        sev = "HIGH" if density_per_300 > 2.0 else "MEDIUM" if density_per_300 > 1.5 else "LOW"
        findings.append({
            "severity": sev,
            "check": "transition-velocity",
            "line": hits[0][0] if hits else 1,
            "quote": f"{len(hits)} low-effort transitions in {total_words} words ({density_per_300:.1f} per 300)",
            "note": f"Examples: {', '.join(set(h[1] for h in hits[:5]))}",
        })
    return findings


def check_zero_tolerance(prose_lines):
    """HIGH — structural AI phrases. Fire on any hit."""
    findings = []
    for lineno, text in prose_lines:
        low = text.lower()
        for phrase in ZERO_TOLERANCE_PHRASES:
            if phrase in low:
                # Skip generic placeholders in the phrase list
                if "x, you" in phrase or "think of x" in phrase:
                    continue
                findings.append({
                    "severity": "HIGH",
                    "check": "zero-tolerance-phrase",
                    "line": lineno,
                    "quote": f'"{phrase}" found',
                    "note": "Structural AI tell. Remove.",
                })
    return findings


def check_ai_vocab_cluster(prose_lines, sentences):
    """MEDIUM — flag when 3+ AI-associated words cluster in a chapter."""
    findings = []
    total_words = sum(word_count(s) for _, s in sentences)
    hits = []
    for lineno, text in prose_lines:
        for w in tokens(text):
            if w in AI_VOCAB:
                hits.append((lineno, w))
    if len(hits) >= 3:
        sev = "HIGH" if len(hits) >= 6 else "MEDIUM"
        seen = {}
        for ln, w in hits:
            seen.setdefault(w, []).append(ln)
        summary = ", ".join(f"{w} ×{len(lines)}" for w, lines in seen.items())
        findings.append({
            "severity": sev,
            "check": "ai-vocab-cluster",
            "line": hits[0][0],
            "quote": f"{len(hits)} AI-associated words in {total_words} words ({summary})",
            "note": "Cluster of AI vocabulary — replace with specific alternatives.",
        })
    return findings


def check_filter_word_density(prose_lines, sentences):
    """LOW/MEDIUM — distancing filter verbs."""
    findings = []
    total_words = sum(word_count(s) for _, s in sentences)
    if total_words == 0:
        return findings
    hits = []
    for lineno, text in prose_lines:
        for w in tokens(text):
            if w in FILTER_VERBS:
                hits.append((lineno, w))
    density_per_1000 = len(hits) / (total_words / 1000.0)
    if density_per_1000 > 4:
        sev = "MEDIUM" if density_per_1000 > 8 else "LOW"
        findings.append({
            "severity": sev,
            "check": "filter-word-density",
            "line": hits[0][0] if hits else 1,
            "quote": f"{len(hits)} filter verbs in {total_words} words ({density_per_1000:.1f} per 1000)",
            "note": "High filter-word density — cut 'saw/heard/felt/noticed' to bring the reader closer.",
        })
    return findings


def check_wan_intensifiers(prose_lines, sentences):
    """LOW — empty intensifiers."""
    findings = []
    total_words = sum(word_count(s) for _, s in sentences)
    if total_words == 0:
        return findings
    hits = []
    for lineno, text in prose_lines:
        for w in tokens(text):
            if w in WAN_INTENSIFIERS:
                hits.append((lineno, w))
    density_per_1000 = len(hits) / (total_words / 1000.0)
    if density_per_1000 > 3:
        findings.append({
            "severity": "LOW",
            "check": "wan-intensifiers",
            "line": hits[0][0] if hits else 1,
            "quote": f"{len(hits)} wan intensifiers in {total_words} words (very, really, quite, just...)",
            "note": "Intensifiers weaken the verb they modify. Replace with a stronger verb.",
        })
    return findings


def check_literal_ai_remnants(prose_lines):
    """CRITICAL — literal traces of AI generation."""
    findings = []
    compiled = [re.compile(p, re.IGNORECASE) for p in LITERAL_AI_PATTERNS]
    for lineno, text in prose_lines:
        # Skip lines that look like markdown headings or code fences
        if text.strip().startswith(("#", "```")):
            continue
        for pat in compiled:
            m = pat.search(text)
            if m:
                findings.append({
                    "severity": "CRITICAL",
                    "check": "literal-ai-remnant",
                    "line": lineno,
                    "quote": m.group(0),
                    "note": "Literal AI artifact left in prose.",
                })
    return findings


def check_dialogue_beat_ratio(prose_lines):
    """Flag dialogue-heavy stretches that are mostly tags, no beats."""
    findings = []
    dialogue_line_re = re.compile(r'^\s*".*"')
    tag_re = re.compile(r'"\s*,?\s*(he|she|they|[A-Z][a-z]+)\s+(said|asked|replied|answered|whispered|shouted|murmured)', re.IGNORECASE)
    current_scene_start = None
    current_scene_lines = []
    scenes = []
    prev_blank = True
    for lineno, text in prose_lines:
        if not text.strip():
            if current_scene_lines:
                scenes.append((current_scene_start, current_scene_lines))
                current_scene_lines = []
                current_scene_start = None
            prev_blank = True
            continue
        if dialogue_line_re.match(text) or '"' in text:
            if current_scene_start is None:
                current_scene_start = lineno
            current_scene_lines.append((lineno, text))
        else:
            if current_scene_lines:
                current_scene_lines.append((lineno, text))
        prev_blank = False
    if current_scene_lines:
        scenes.append((current_scene_start, current_scene_lines))

    for start_line, lines in scenes:
        dialogue_lines = [l for l in lines if '"' in l[1]]
        if len(dialogue_lines) < 10:
            continue
        tag_only = 0
        for _, t in dialogue_lines:
            if tag_re.search(t):
                tag_only += 1
        ratio = tag_only / len(dialogue_lines)
        if ratio >= 0.75:
            findings.append({
                "severity": "MEDIUM",
                "check": "dialogue-beat-ratio",
                "line": start_line,
                "quote": f"{tag_only}/{len(dialogue_lines)} dialogue lines are tag-only",
                "note": "Ping-pong dialogue — add staging beats (action, setting) between exchanges.",
            })
    return findings


# ------------------------------------------------------------------------
# Reporting
# ------------------------------------------------------------------------

def fmt(findings, severity):
    lines = []
    for f in findings:
        if f["severity"] != severity:
            continue
        loc = f"line {f['line']}"
        if "line_end" in f and f["line_end"] != f["line"]:
            loc = f"lines {f['line']}–{f['line_end']}"
        lines.append(f"- **[{f['check']}]** {loc}: {f['quote']}")
        if f.get("note"):
            lines.append(f"    > {f['note']}")
    return "\n".join(lines) if lines else "(none)"


def main():
    # Force UTF-8 output so em-dashes and smart quotes render on any terminal
    # (fixes legacy Windows cmd.exe which defaults to cp1252)
    try:
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    except AttributeError:
        pass  # Python < 3.7; rarely encountered, degrades gracefully

    path = Path(sys.argv[1])
    prose_lines = read_prose(path)
    sentences = split_sentences(prose_lines)
    proper_nouns = detect_proper_nouns(prose_lines)

    all_findings = []
    all_findings += check_placeholder(prose_lines)
    all_findings += check_literal_ai_remnants(prose_lines)
    all_findings += check_zero_tolerance(prose_lines)
    all_findings += check_ai_vocab_cluster(prose_lines, sentences)
    all_findings += check_sentence_opener_variance(sentences)
    all_findings += check_burstiness(sentences)
    all_findings += check_echo(prose_lines, sentences, proper_nouns)
    all_findings += check_sensory_ratio(prose_lines)
    all_findings += check_transition_velocity(prose_lines, sentences)
    all_findings += check_filter_word_density(prose_lines, sentences)
    all_findings += check_wan_intensifiers(prose_lines, sentences)
    all_findings += check_dialogue_beat_ratio(prose_lines)

    total_words = sum(word_count(s) for _, s in sentences)

    by_sev = Counter(f["severity"] for f in all_findings)

    print(f"# Prose Scan: {path.name}")
    print()
    print(f"**File:** {path}")
    print(f"**Word count:** {total_words}")
    print(f"**Sentences:** {len(sentences)}")
    print()
    print("## Summary")
    print(f"- CRITICAL: {by_sev.get('CRITICAL', 0)}")
    print(f"- HIGH:     {by_sev.get('HIGH', 0)}")
    print(f"- MEDIUM:   {by_sev.get('MEDIUM', 0)}")
    print(f"- LOW:      {by_sev.get('LOW', 0)}")
    print()
    print("## Findings")
    for sev in ("CRITICAL", "HIGH", "MEDIUM", "LOW"):
        print(f"\n### {sev}")
        print(fmt(all_findings, sev))

    # Exit code: non-zero only on CRITICAL (ship-blocker)
    sys.exit(1 if by_sev.get("CRITICAL", 0) > 0 else 0)


if __name__ == "__main__":
    main()
