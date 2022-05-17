import ujson as json
import numpy as np
import pandas as pd
import tqdm


mag_label_mapping = {
    0: "Art",
    1: "Biology",
    2: "Business",
    3: "Chemistry",
    4: "Computer science",
    5: "Economics",
    6: "Engineering",
    7: "Environmental science",
    8: "Geography",
    9: "Geology",
    10:	"History",
    11: "Materials science",
    12: "Mathematics",
    13:	"Medicine",
    14: "Philosophy",
    15: "Physics",
    16: "Political science",
    17: "Psychology",
    18: "Sociology",
}

mag_val = pd.read_csv("../../scidocs/data/mag/val.csv")
mag_val_pids = list(mag_val.pid)

output_dict = {}

num_facets = 3

for f in range(num_facets):
    output_dict['magnitude_{}'.format(f)] = []

output_dict['field'] = []

with open('cls_no_sum.jsonl', 'r') as mag_embeddings_file:
    for line in tqdm.tqdm(mag_embeddings_file):
        paper = json.loads(line)

        if paper["paper_id"] in mag_val_pids:
            for f in range(num_facets):
                emb = paper["embedding"][f]
                output_dict['magnitude_{}'.format(f)].append(np.linalg.norm(emb))

            output_dict['field'].append(mag_label_mapping[mag_val[mag_val.pid == paper["paper_id"]].iloc[0].class_label])
            
df = pd.DataFrame.from_dict(output_dict)
df.to_excel('magnitudes.xlsx')

mean_magnitudes_by_mag_field = df.groupby('field').mean()
mean_magnitudes_by_mag_field.to_excel('mean_magnitudes_by_mag_field.xlsx')

print(mean_magnitudes_by_mag_field)
