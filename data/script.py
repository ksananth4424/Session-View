import itertools
import csv

def generate(strings):
    combinations = []
    for r in range(1, len(strings)-1):
        combinations.extend(itertools.combinations(strings,r))
    return combinations

input_strings = ["good", "great", "bad", "lengthy", "quick", "fine", "okay", "average", "informative", "resources", "no resources", "advanced", "begineer friendly", "good", "good management", "bad management", "short", "knowledeable"]
combinations = generate(input_strings)

file = "data/review_tags.csv"
i=0
with open(file, "w", newline='') as file:
    writer = csv.writer(file)
    for i in range(0, len(combinations)):
        writer.writerow(combinations[i])    