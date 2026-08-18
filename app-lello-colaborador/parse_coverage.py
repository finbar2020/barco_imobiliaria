import re
from pathlib import Path

html = Path("coverage/html/index.html").read_text(encoding="utf-8")
pattern = r'<a href="[^"]+">(lib\\[^<]+)</a></td>\s*<td>(\d+)/(\d+)</td>\s*<td>([\d.]+)%</td>'
rows = []
for m in re.finditer(pattern, html):
    path = m.group(1).replace("\\", "/")
    covered, total, pct = int(m.group(2)), int(m.group(3)), float(m.group(4))
    rows.append((path, covered, total, pct))

exclude_patterns = [
    "firebase",
    "application_container",
    "session_bloc",
    "digital_point_bloc",
    "me_bloc",
    ".g.dart",
    "_dao",
    "dao.g",
    "/database/",
    "face",
    "camera",
]

low = [r for r in rows if r[3] < 25 and r[2] >= 5]
low.sort(key=lambda x: (-x[2], x[3]))

categories = {
    "widget": ["presentation/", "widgets/", "widget/"],
    "bloc": ["_bloc", "_cubit"],
    "repo": ["repository", "data_source"],
    "usecase": ["use_case"],
    "controller": ["controller"],
    "enum": ["enum"],
    "model": ["data/model"],
}

def cat(path):
    for name, patterns in categories.items():
        if any(p in path for p in patterns):
            return name
    if "entity" in path:
        return "entity"
    return "other"

for path, cov, tot, pct in low:
    p = path.lower()
    skip = any(x in p for x in exclude_patterns)
    if not skip:
        print(f"{pct:5.1f}% {cov}/{tot:4d} [{cat(path)}] {path}")
