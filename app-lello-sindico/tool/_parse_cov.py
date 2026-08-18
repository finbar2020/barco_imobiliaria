import re

html = open("coverage/html/index.html", encoding="utf-8").read()
rows = re.findall(
    r"<a href=\"[^\"]+\">([^<]+)</a></td>\s*<td>(\d+)/(\d+)</td>\s*<td>([\d.]+)%</td>",
    html,
)
missed = []
for path, hit, total, pct in rows:
    hit, total = int(hit), int(total)
    missed.append((total - hit, total, hit, float(pct), path.replace("\\", "/")))
missed.sort(reverse=True)
print("=== MAIORES BURACOS ===")
for m, t, h, p, path in missed[:50]:
    print(f"{m:4d} miss / {t:4d} ({p:5.1f}%)  {path}")
print()
print("=== FEATURE 20-80pct ===")
for m, t, h, p, path in missed:
    if path.startswith("lib/feature/") and 5 <= p < 80 and t >= 15:
        print(f"{m:4d} miss / {t:4d} ({p:5.1f}%)  {path}")
