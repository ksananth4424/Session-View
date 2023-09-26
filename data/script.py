import itertools
import csv

def generate(strings):
    combinations = []
    for r in range(1, len(strings)-1):
        combinations.extend(itertools.combinations(strings,r))
    return combinations

# matrix = [
#     ["good", "great", "bad", "worst", "average", "fine"],
#     ["good management", "bad management"],
#     ["resources", "no resources"],
#     ["fast", "quick", "lengthy", "perfect time"],
#     ["informative", "not informative"],
#     ["advanced", "begineer friendly"]
# ]

input_strings = ["good", "great", "bad", "lengthy", "quick", "fine", "okay", "average", "informative", "resources", "no resources", "advanced", "begineer friendly", "good", "good management", "bad management", "short", "knowledeable"]
combinations = generate(input_strings)

# combinations = list(itertools.product(*matrix))

file = "data/review_tags1.csv"
i=0
with open(file, "w", newline='') as file:
    writer = csv.writer(file)
    for i in range(0, len(combinations)):
        writer.writerow(combinations[i])